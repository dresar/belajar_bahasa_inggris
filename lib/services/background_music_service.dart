import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundMusicService {
  static final BackgroundMusicService instance = BackgroundMusicService._internal();
  BackgroundMusicService._internal();

  final AudioPlayer _player = AudioPlayer();
  final List<String> _playlist = [
    'assets/audio/bgm1.m4a',
    'assets/audio/bgm2.m4a',
    'assets/audio/bgm3.m4a',
    'assets/audio/bgm4.m4a',
  ];

  int _currentIndex = 0;
  bool _isInitialized = false;
  bool _isMuted = false;

  final ValueNotifier<bool> isMutedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isPlayingNotifier = ValueNotifier<bool>(false);

  bool get isMuted => _isMuted;

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      _isMuted = prefs.getBool('bgm_muted') ?? false;
      isMutedNotifier.value = _isMuted;

      await _player.setVolume(_isMuted ? 0.0 : 0.22); // Soft background music

      _player.playerStateStream.listen((state) {
        isPlayingNotifier.value = state.playing;
        if (state.processingState == ProcessingState.completed) {
          _playNextTrack();
        }
      });

      if (!_isMuted) {
        // Fire & forget async track start so main UI never blocks!
        _playCurrentTrack();
      }
    } catch (e) {
      debugPrint('BackgroundMusicService Init Warning: $e');
    }
  }

  Future<void> _playCurrentTrack() async {
    try {
      final assetPath = _playlist[_currentIndex];
      debugPrint('Playing Background Music Track [${_currentIndex + 1}/4]: $assetPath');
      await _player.setAsset(assetPath);
      if (!_isMuted) {
        await _player.play();
      }
    } catch (e) {
      debugPrint('Error playing background music track: $e');
      _playNextTrack();
    }
  }

  Future<void> _playNextTrack() async {
    _currentIndex = (_currentIndex + 1) % _playlist.length;
    await _playCurrentTrack();
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    isMutedNotifier.value = _isMuted;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('bgm_muted', _isMuted);

      if (_isMuted) {
        await _player.pause();
        await _player.setVolume(0.0);
      } else {
        await _player.setVolume(0.22);
        if (_player.processingState == ProcessingState.idle) {
          await _playCurrentTrack();
        } else {
          await _player.play();
        }
      }
    } catch (e) {
      debugPrint('Error toggling BGM mute: $e');
    }
  }

  Future<void> duckVolume() async {
    if (_isMuted) return;
    try {
      await _player.setVolume(0.04); // Softly duck background music during speech
    } catch (_) {}
  }

  Future<void> restoreVolume() async {
    if (_isMuted) return;
    try {
      await _player.setVolume(0.22); // Restore normal soft BGM volume
    } catch (_) {}
  }

  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (_) {}
  }

  Future<void> resume() async {
    if (!_isMuted) {
      try {
        await _player.play();
      } catch (_) {}
    }
  }

  void dispose() {
    _player.dispose();
  }
}

/// Small, Compact Bottom-Right Floating BGM Toggle Button
class BgmToggleButton extends StatelessWidget {
  const BgmToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: BackgroundMusicService.instance.isMutedNotifier,
      builder: (context, isMuted, _) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => BackgroundMusicService.instance.toggleMute(),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isMuted
                      ? [const Color(0xFF616161), const Color(0xFF424242)]
                      : [const Color(0xFF8E24AA), const Color(0xFFAB47BC)],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: isMuted
                        ? Colors.black.withValues(alpha: 0.15)
                        : Colors.purple.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                isMuted ? Icons.music_off_rounded : Icons.music_note_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        );
      },
    );
  }
}
