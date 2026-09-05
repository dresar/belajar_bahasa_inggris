import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CloudinaryStorageService {
  static final CloudinaryStorageService instance = CloudinaryStorageService._internal();
  CloudinaryStorageService._internal();

  static const String _cloudName = 'jsbf8bf5';
  static const String _cloudinaryApiKey = '254599533143232';
  static const String _cloudinaryApiSecret = 'wHbYEiu3rDmPcpgaSCIE05m-0G4';
  static const String _cloudinaryFolder = 'user_profiles';

  static const String _prefUsernameKey = 'user_pref_username';
  static const String _prefPhotoUrlKey = 'user_pref_photo_url';
  static const String _prefPublicIdKey = 'user_pref_public_id';
  static const String _prefAvatarEmojiKey = 'user_pref_avatar_emoji';
  static const String _prefIsAnonymousKey = 'user_pref_is_anonymous';

  final Dio _dio = Dio();

  /// Delete old photo from Cloudinary CDN quietly
  Future<void> deleteFromCloudinaryCdn(String publicId) async {
    try {
      final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      final toSign = 'public_id=$publicId&timestamp=$timestamp$_cloudinaryApiSecret';
      final signature = sha1.convert(utf8.encode(toSign)).toString();

      final formData = FormData.fromMap({
        'public_id': publicId,
        'api_key': _cloudinaryApiKey,
        'timestamp': timestamp,
        'signature': signature,
      });

      await _dio.post(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/destroy',
        data: formData,
      );
      debugPrint('Successfully deleted old profile photo from Cloudinary CDN: $publicId');
    } catch (e) {
      debugPrint('Cloudinary photo delete warning (ignored): $e');
    }
  }

  /// Upload new photo to Cloudinary CDN and delete previous photo
  Future<String?> uploadProfilePhoto(List<int> imageBytes, String filename) async {
    final prefs = await SharedPreferences.getInstance();
    final oldPublicId = prefs.getString(_prefPublicIdKey);

    // Delete old image silently first
    if (oldPublicId != null && oldPublicId.isNotEmpty) {
      await deleteFromCloudinaryCdn(oldPublicId);
    }

    try {
      final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
      final publicId = 'profile_${DateTime.now().millisecondsSinceEpoch}';
      final toSign = 'folder=$_cloudinaryFolder&public_id=$publicId&timestamp=$timestamp$_cloudinaryApiSecret';
      final signature = sha1.convert(utf8.encode(toSign)).toString();

      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(imageBytes, filename: filename),
        'api_key': _cloudinaryApiKey,
        'timestamp': timestamp,
        'public_id': publicId,
        'folder': _cloudinaryFolder,
        'signature': signature,
      });

      final response = await _dio.post(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
        data: formData,
      );

      if (response.statusCode == 200 && response.data != null) {
        final secureUrl = response.data['secure_url'] as String?;
        final returnedPublicId = response.data['public_id'] as String?;

        if (secureUrl != null && returnedPublicId != null) {
          await prefs.setString(_prefPhotoUrlKey, secureUrl);
          await prefs.setString(_prefPublicIdKey, returnedPublicId);
          debugPrint('Profile photo updated seamlessly to CDN.');
          return secureUrl;
        }
      }
    } catch (e) {
      debugPrint('Cloudinary profile photo upload error: $e');
    }
    return null;
  }

  Future<void> saveUserProfile({
    required String username,
    required String avatarEmoji,
    required bool isAnonymous,
    String? photoUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefUsernameKey, username);
    await prefs.setString(_prefAvatarEmojiKey, avatarEmoji);
    await prefs.setBool(_prefIsAnonymousKey, isAnonymous);
    if (photoUrl != null) {
      await prefs.setString(_prefPhotoUrlKey, photoUrl);
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString(_prefUsernameKey) ?? 'Siswa Pintar SD 🌟',
      'photoUrl': prefs.getString(_prefPhotoUrlKey),
      'publicId': prefs.getString(_prefPublicIdKey),
      'avatarEmoji': prefs.getString(_prefAvatarEmojiKey) ?? '🦸‍♂️',
      'isAnonymous': prefs.getBool(_prefIsAnonymousKey) ?? false,
    };
  }
}
