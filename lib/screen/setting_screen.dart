import 'package:card_match_memory/helper/app_color.dart';
import 'package:card_match_memory/helper/app_text_styles.dart';
import 'package:card_match_memory/provider/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.volume_up, color: AppColor.primaryColor),
              title: Text(
                'Sound Effects',
                style: AppTextStyle.subtitleMedium(
                  color: AppColor.darkText,
                  weight: FontWeight.bold,
                ),
              ),
              trailing: Switch(
                value: settingProvider.isSoundOn,
                activeTrackColor: AppColor.primaryColor,

                onChanged: (value) {
                  settingProvider.toggleSound();
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.vibration, color: AppColor.primaryColor),
              title: Text(
                'Vibration',
                style: AppTextStyle.subtitleMedium(
                  color: AppColor.darkText,
                  weight: FontWeight.bold,
                ),
              ),
              trailing: Switch(
                value: settingProvider.isVibrationOn,
                activeTrackColor: AppColor.primaryColor,
                onChanged: (value) {
                  settingProvider.toggleVibration();
                  settingProvider.playVibration();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
