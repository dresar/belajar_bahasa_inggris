const fs = require('fs');
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

function fetchGoogleTtsMp3(text) {
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

async function testSingle() {
  console.log('Fetching TTS audio for "hello"...');
  const buffer = await fetchGoogleTtsMp3('hello');
  console.log(`Audio buffer received: ${buffer.length} bytes.`);

  const pid = getPublicId('hello');
  console.log('Uploading to Primary Cloudinary...');
  let url;
  try {
    url = await uploadToCloudinary(pid, buffer, CLOUD_PRIMARY);
  } catch (err) {
    console.warn('Primary failed, trying backup...', err.message);
    url = await uploadToCloudinary(pid, buffer, CLOUD_BACKUP);
  }
  console.log('Uploaded Cloudinary MP3 URL:', url);
}

testSingle().catch(console.error);
