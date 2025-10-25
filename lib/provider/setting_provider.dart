import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class SettingProvider extends ChangeNotifier {
  bool _isSoundOn = true;
  bool _isVibrationOn = true;
  final List<AudioPlayer> _audioPlayers = [];
  int _currentPlayerIndex = 0;

  /// Getter
  bool get isSoundOn => _isSoundOn;
  bool get isVibrationOn => _isVibrationOn;

  SettingProvider() {
    _loadSoundSetting();
    _loadVibrationSetting();
    _initializeAudioPlayers();
  }

  /// Initialize multiple audio players for overlapping sounds
  void _initializeAudioPlayers() {
    // Create 3 audio players for rapid sound playback
    for (int i = 0; i < 3; i++) {
      _audioPlayers.add(AudioPlayer());
    }
  }

  /// Load sound setting from SharedPreferences
  Future<void> _loadSoundSetting() async {
    final prefs = await SharedPreferences.getInstance();
    _isSoundOn = prefs.getBool('sound') ?? true;
    notifyListeners();
  }

  Future<void> _loadVibrationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    _isVibrationOn = prefs.getBool('vibration') ?? true;
    notifyListeners();
  }

  /// Toggle Sound Setting
  Future<void> toggleSound() async {
    _isSoundOn = !_isSoundOn;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound', _isSoundOn);
    notifyListeners();
  }

  /// Toggle Vibration Setting
  Future<void> toggleVibration() async {
    _isVibrationOn = !_isVibrationOn;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vibration', _isVibrationOn);
    notifyListeners();
  }

  /// Play tap sound only if sound is ON - WITHOUT AWAIT
  void playSound({required String soundPath}) {
    if (!_isSoundOn) return;

    try {
      final player = _audioPlayers[_currentPlayerIndex];

      // Stop any currently playing sound on this player
      player.stop();

      // Play the new sound
      player.play(AssetSource(soundPath));

      // Move to next player for next sound
      _currentPlayerIndex = (_currentPlayerIndex + 1) % _audioPlayers.length;
    } catch (e) {
      if (kDebugMode) {
        print('Error playing sound: $e');
      }
    }
  }

  Future<void> playVibration() async {
    if (_isVibrationOn && (await Vibration.hasVibrator() ?? false)) {
      Vibration.vibrate(duration: 100);
    }
  }

  @override
  void dispose() {
    // Dispose all audio players
    for (var player in _audioPlayers) {
      player.dispose();
    }
    super.dispose();
  }
}
