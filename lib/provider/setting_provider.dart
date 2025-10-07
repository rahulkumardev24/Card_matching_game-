import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider extends ChangeNotifier {
  bool _isSoundOn = true;
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Getter
  bool get isSoundOn => _isSoundOn;

  SettingProvider() {
    _loadSoundSetting();
  }

  /// Load sound setting from SharedPreferences
  Future<void> _loadSoundSetting() async {
    final prefs = await SharedPreferences.getInstance();
    _isSoundOn = prefs.getBool('sound') ?? true;
    notifyListeners();
  }

  /// Toggle Sound Setting
  Future<void> toggleSound() async {
    _isSoundOn = !_isSoundOn;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound', _isSoundOn);
    notifyListeners();
  }

  /// Play tap sound only if sound is ON
  Future<void> playTapSound() async {
    if (_isSoundOn) {
      await _audioPlayer.play(AssetSource('audio/flip.mp3'));
    }
  }
}
