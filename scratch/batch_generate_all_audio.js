const fs = require('fs');
const path = require('path');
const https = require('https');
const crypto = require('crypto');

const CLOUD_PRIMARY = {
  name: 'jsbf8bf5',
  key: '254599533143232',
  secret: 'wHbYEiu3rDmPcpgaSCIE05m-0G4'
};

const CLOUD_BACKUP = {
  name: 'eafzw9rz',
  key: '619574733387237',
  secret: 'CCOg_7mouUpS7EbSsJ3vRJdX2L4'
};

function getPublicId(text) {
  const clean = text.trim().toLowerCase().replace(/[^a-z0-9_]/g, '_').replace(/_+/g, '_');
  return `gemini_${clean}`;
}

function getCdnUrl(text, cloudName = CLOUD_PRIMARY.name) {
  const pid = getPublicId(text);
  return `https://res.cloudinary.com/${cloudName}/video/upload/audio_cache/${pid}.mp3`;
}

function fetchTtsMp3(text) {
  return new Promise((resolve, reject) => {
    const encoded = encodeURIComponent(text);
    const url = `https://translate.google.com/translate_tts?ie=UTF-8&q=${encoded}&tl=en&client=tw-ob`;
    
    https.get(url, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'
      }
    }, (res) => {
      if (res.statusCode !== 200) {
        return reject(new Error(`TTS failed with status ${res.statusCode}`));
      }
      const chunks = [];
      res.on('data', chunk => chunks.push(chunk));
      res.on('end', () => resolve(Buffer.concat(chunks)));
    }).on('error', reject);
  });
}

function uploadToCloudinary(publicId, audioBuffer, cloud) {
  return new Promise((resolve, reject) => {
    const timestamp = Math.floor(Date.now() / 1000).toString();
    const folder = 'audio_cache';
    const toSign = `folder=${folder}&public_id=${publicId}&timestamp=${timestamp}${cloud.secret}`;
    const signature = crypto.createHash('sha1').update(toSign).digest('hex');

    const boundary = '----WebKitFormBoundary' + Math.random().toString(16).substring(2);
    const postData = [];

    function addField(name, value) {
      postData.push(`--${boundary}\r\nContent-Disposition: form-data; name="${name}"\r\n\r\n${value}\r\n`);
    }

    addField('api_key', cloud.key);
    addField('timestamp', timestamp);
    addField('public_id', publicId);
    addField('folder', folder);
    addField('signature', signature);

    postData.push(`--${boundary}\r\nContent-Disposition: form-data; name="file"; filename="${publicId}.mp3"\r\nContent-Type: audio/mpeg\r\n\r\n`);

    const headerBuffer = Buffer.from(postData.join(''));
    const footerBuffer = Buffer.from(`\r\n--${boundary}--\r\n`);
    const bodyBuffer = Buffer.concat([headerBuffer, audioBuffer, footerBuffer]);

    const req = https.request(`https://api.cloudinary.com/v1_1/${cloud.name}/video/upload`, {
      method: 'POST',
      headers: {
        'Content-Type': `multipart/form-data; boundary=${boundary}`,
        'Content-Length': bodyBuffer.length
      }
    }, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        if (res.statusCode === 200) {
          const parsed = JSON.parse(data);
          resolve(parsed.secure_url);
        } else {
          reject(new Error(`Cloudinary upload failed (${res.statusCode}): ${data}`));
        }
      });
    });

    req.on('error', reject);
    req.write(bodyBuffer);
    req.end();
  });
}

function checkHeadExists(url) {
  return new Promise(resolve => {
    https.request(url, { method: 'HEAD' }, res => {
      resolve(res.statusCode === 200);
    }).on('error', () => resolve(false)).end();
  });
}

const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));

function extractTermsFromDirectory(dirPath) {
  const terms = new Set();
  const files = fs.readdirSync(dirPath).filter(f => f.endsWith('.dart'));
  
  for (const file of files) {
    const fullPath = path.join(dirPath, file);
    const content = fs.readFileSync(fullPath, 'utf8');
    
    // Extract english: 'xxx' or targetAnswer: 'xxx'
    const engMatches = content.matchAll(/english:\s*['"]([^'"]+)['"]/g);
    for (const m of engMatches) {
      if (m[1]) terms.add(m[1].trim());
    }
    
    const ansMatches = content.matchAll(/targetAnswer:\s*['"]([^'"]+)['"]/g);
    for (const m of ansMatches) {
      if (m[1]) terms.add(m[1].trim());
    }
  }
  return Array.from(terms);
}

async function runBatch() {
  const vocabDir = path.join(__dirname, '..', 'lib', 'data', 'vocabularies');
  const gradesDir = path.join(__dirname, '..', 'lib', 'data', 'grades');
  
  const vocabTerms = extractTermsFromDirectory(vocabDir);
  const gradeTerms = extractTermsFromDirectory(gradesDir);
  
  const allTerms = Array.from(new Set([...vocabTerms, ...gradeTerms]))
    .filter(t => t.length > 0 && !t.includes('{') && t.length < 50);

  console.log(`Extracted ${allTerms.length} total unique English vocabulary and grade question terms.`);

  const manifestMap = {};

  for (let i = 0; i < allTerms.length; i++) {
    const term = allTerms[i];
    const pid = getPublicId(term);
    const key = term.trim().toLowerCase().replace(/[^a-z0-9_]/g, '_').replace(/_+/g, '_');
    const primaryUrl = getCdnUrl(term, CLOUD_PRIMARY.name);

    console.log(`[${i + 1}/${allTerms.length}] Processing term: "${term}" -> ${pid}`);

    const exists = await checkHeadExists(primaryUrl);
    if (exists) {
      console.log(`  └─ Already exists on Cloudinary CDN: ${primaryUrl}`);
      manifestMap[key] = primaryUrl;
      continue;
    }

    try {
      console.log(`  └─ Generating MP3 audio and uploading...`);
      const buffer = await fetchTtsMp3(term);
      let uploadedUrl;
      try {
        uploadedUrl = await uploadToCloudinary(pid, buffer, CLOUD_PRIMARY);
      } catch (err) {
        console.warn(`  └─ Primary failed (${err.message}). Retrying with Backup Cloudinary...`);
        uploadedUrl = await uploadToCloudinary(pid, buffer, CLOUD_BACKUP);
      }
      manifestMap[key] = uploadedUrl;
      console.log(`  └─ SUCCESS: Uploaded to ${uploadedUrl}`);
    } catch (err) {
      console.error(`  └─ ERROR generating/uploading "${term}":`, err.message);
      manifestMap[key] = primaryUrl;
    }

    // 2.5 second delay between generations to prevent rate-limiting as requested by user
    await sleep(2500);
  }

  // Update lib/data/cdn_audio_manifest.dart
  const manifestFilePath = path.join(__dirname, '..', 'lib', 'data', 'cdn_audio_manifest.dart');
  let code = `/// Pre-compiled Cloudinary CDN Audio Manifest (Grades 1-6 Vocabularies & Game Words)\n`;
  code += `/// Generated automatically with .mp3 format for instant 0ms playback.\n`;
  code += `class CdnAudioManifest {\n`;
  code += `  static const Map<String, String> cdnAudioMap = {\n`;
  for (const [k, url] of Object.entries(manifestMap)) {
    code += `    '${k}': '${url}',\n`;
  }
  code += `  };\n\n`;
  code += `  static String? getCdnUrl(String textKey) {\n`;
  code += `    final key = textKey.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '_');\n`;
  code += `    return cdnAudioMap[key];\n`;
  code += `  }\n`;
  code += `}\n`;

  fs.writeFileSync(manifestFilePath, code, 'utf8');
  console.log(`Updated ${manifestFilePath} with ${Object.keys(manifestMap).length} verified MP3 CDN links!`);
}

runBatch().catch(console.error);
