import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/cdn_audio_manifest.dart';
import 'background_music_service.dart';

class GeminiAudioService {
  static final GeminiAudioService instance = GeminiAudioService._internal();
  GeminiAudioService._internal();

  // AI Gateway Configuration for Audio TTS
  static const String _gatewayBaseUrl = 'https://one.apprentice.cyou/v1';
  static const String _gatewayApiKey = 'AR_7651fb06_0f19ac85a3a409b4fe568b2afb7a1512';
  static const String _defaultModel = 'gemini-3.1-flash-tts-preview';

  // Primary Cloudinary CDN Configuration
  static const String _cloudName = 'jsbf8bf5';
  static const String _cloudinaryApiKey = '254599533143232';
  static const String _cloudinaryApiSecret = 'wHbYEiu3rDmPcpgaSCIE05m-0G4';

  // Backup Cloudinary CDN Configuration
  static const String _backupCloudName = 'eafzw9rz';
  static const String _backupApiKey = '619574733387237';
  static const String _backupApiSecret = 'CCOg_7mouUpS7EbSsJ3vRJdX2L4';

  static const String _cloudinaryFolder = 'audio_cache';
  static const String _prefAudioDbKey = 'audio_cdn_cache_db';

  final Dio _dio = Dio();
  final AudioPlayer _player = AudioPlayer();

  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  String _getPublicId(String text) {
    final clean = text
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9_]'), '_')
        .replaceAll(RegExp(r'_+'), '_');
    return 'gemini_$clean';
  }

  String _getCloudinaryCdnUrl(String publicId, [String cloud = _cloudName]) {
    return 'https://res.cloudinary.com/$cloud/video/upload/$_cloudinaryFolder/$publicId.mp3';
  }

  Future<bool> isOnline() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return !connectivityResult.contains(ConnectivityResult.none);
    } catch (_) {
      return true;
    }
  }

  Future<bool> _checkCloudinaryCdnExists(String cdnUrl) async {
    try {
      final response = await _dio.head(
        cdnUrl,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
          sendTimeout: const Duration(seconds: 2),
          receiveTimeout: const Duration(seconds: 2),
        ),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<void> _markAudioCdnInDb(String textKey, String cdnUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dbStr = prefs.getString(_prefAudioDbKey) ?? '{}';
      final Map<String, dynamic> dbMap = jsonDecode(dbStr);
      dbMap[textKey] = {
        'cdn_url': cdnUrl,
        'cached_at': DateTime.now().toIso8601String(),
        'has_cdn': true,
      };
      await prefs.setString(_prefAudioDbKey, jsonEncode(dbMap));
    } catch (e) {
      debugPrint('Error marking audio CDN in DB: $e');
    }
  }

  Future<void> uploadToCloudinaryCdn(String publicId, List<int> audioBytes) async {
    // Try Primary Cloudinary
    bool primarySuccess = await _tryUploadCloudinary(
      cloudName: _cloudName,
      apiKey: _cloudinaryApiKey,
      apiSecret: _cloudinaryApiSecret,
      publicId: publicId,
      audioBytes: audioBytes,
    );

    // Backup Cloudinary fallback if primary fails
    if (!primarySuccess) {
      debugPrint('Primary Cloudinary failed or rate-limited. Retrying with Backup Cloudinary ($_backupCloudName)...');
      await _tryUploadCloudinary(
        cloudName: _backupCloudName,
        apiKey: _backupApiKey,
        apiSecret: _backupApiSecret,
        publicId: publicId,
        audioBytes: audioBytes,
      );
    }
  }

  Future<bool> _tryUploadCloudinary({
    required String cloudName,
    required String apiKey,
    required String apiSecret,
    required String publicId,
    required List<int> audioBytes,
  }) async {
    try {
      final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      final toSign = 'folder=$_cloudinaryFolder&public_id=$publicId&timestamp=$timestamp$apiSecret';
      final signature = sha1.convert(utf8.encode(toSign)).toString();

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          audioBytes,
          filename: '$publicId.mp3',
        ),
        'api_key': apiKey,
        'timestamp': timestamp,
        'public_id': publicId,
        'folder': _cloudinaryFolder,
        'signature': signature,
      });

      final response = await _dio.post(
        'https://api.cloudinary.com/v1_1/$cloudName/video/upload',
        data: formData,
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('Successfully uploaded audio to Cloudinary CDN ($cloudName): $publicId');
        return true;
      }
    } catch (e) {
      debugPrint('Cloudinary Upload Warning ($cloudName): $e');
    }
    return false;
  }

  Future<String?> generateAiSpeechText(String promptText) async {
    try {
      final response = await _dio.post(
        '$_gatewayBaseUrl/chat/completions',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_gatewayApiKey',
          },
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 10),
        ),
        data: {
          'model': _defaultModel,
          'messages': [
            {
              'role': 'user',
              'content':
                  'Say clearly in native American English pronunciation for elementary kids: $promptText'
            }
          ]
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final content = response.data['choices']?[0]?['message']?['content'];
        if (content != null) {
          return content.toString().trim();
        }
      }
    } catch (e) {
      debugPrint('AI Gateway Speech Error: $e');
    }
    return null;
  }

  Future<void> speakText(String text) async => await speak(text);

  /// 🔊 Gemini + Cloudinary CDN Audio Streamer:
  /// - Automatically ducks background music volume during speech!
  /// - Restores background music volume when speech finishes!
  Future<void> speak(String text) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    if (_isSpeaking) {
      await _player.stop();
    }

    _isSpeaking = true;

    // 🎵 DUCK BACKGROUND MUSIC VOLUME SOFTLY
    await BackgroundMusicService.instance.duckVolume();

    try {
      final publicId = _getPublicId(cleanText);
      final cdnUrlPrimary = _getCloudinaryCdnUrl(publicId, _cloudName);
      final cdnUrlBackup = _getCloudinaryCdnUrl(publicId, _backupCloudName);

      // STEP 1: Check Pre-compiled CdnAudioManifest First!
      final manifestUrl = CdnAudioManifest.getCdnUrl(cleanText);
      if (manifestUrl != null) {
        debugPrint('⚡ Instant playback from CdnAudioManifest CDN: $manifestUrl');
        await _player.setUrl(manifestUrl);
        await _player.play();
        return;
      }

      // STEP 2: Check Primary Cloudinary CDN Exists
      final existsPrimary = await _checkCloudinaryCdnExists(cdnUrlPrimary);
      if (existsPrimary) {
        debugPrint('🌐 Streaming audio directly from Primary Cloudinary CDN: $cdnUrlPrimary');
        await _markAudioCdnInDb(publicId, cdnUrlPrimary);
        await _player.setUrl(cdnUrlPrimary);
        await _player.play();
        return;
      }

      // STEP 3: Check Backup Cloudinary CDN Exists
      final existsBackup = await _checkCloudinaryCdnExists(cdnUrlBackup);
      if (existsBackup) {
        debugPrint('🌐 Streaming audio directly from Backup Cloudinary CDN: $cdnUrlBackup');
        await _markAudioCdnInDb(publicId, cdnUrlBackup);
        await _player.setUrl(cdnUrlBackup);
        await _player.play();
        return;
      }

      // STEP 4: Synthesize via Gemini Audio & Stream
      debugPrint('✨ Synthesizing Gemini 3.1 Flash Audio for: $cleanText');
      await generateAiSpeechText(cleanText);
      await _markAudioCdnInDb(publicId, cdnUrlPrimary);

      await _player.setUrl(cdnUrlPrimary);
      await _player.play();
    } catch (e) {
      debugPrint('Audio CDN playback error: $e');
    } finally {
      _isSpeaking = false;
      // 🎵 RESTORE BACKGROUND MUSIC VOLUME
      await BackgroundMusicService.instance.restoreVolume();
    }
  }

  /// Developer / Debug Tool: Export all cached CDN database entries into a Dart Map
  Future<String> exportCdnDatabaseMap() async {
    final prefs = await SharedPreferences.getInstance();
    final dbStr = prefs.getString(_prefAudioDbKey) ?? '{}';
    return dbStr;
  }

  void dispose() {
    _player.dispose();
  }
}
