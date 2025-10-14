import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class SettingProvider extends ChangeNotifier {
  bool _isSoundOn = true;
  bool _isVibrationOn = true;
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Getter
  bool get isSoundOn => _isSoundOn;
  bool get isVibrationOn => _isVibrationOn;

  SettingProvider() {
    _loadSoundSetting();
    _loadVibrationSetting();
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

  /// Play tap sound only if sound is ON
  Future<void> playSound({required String soundPath}) async {
    if (_isSoundOn) {
      await _audioPlayer.play(AssetSource(soundPath));
    }
  }

  Future<void> playVibration() async {
    if (_isVibrationOn && (await Vibration.hasVibrator())) {
      Vibration.vibrate(duration: 100);
    }
  }
}
