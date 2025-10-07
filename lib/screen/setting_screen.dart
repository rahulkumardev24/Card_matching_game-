import 'package:card_match_memory/provider/setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.volume_up),
              title: const Text('Sound Effects'),
              trailing: Switch(
                value: settingProvider.isSoundOn,
                onChanged: (value) {
                  settingProvider.toggleSound();
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('Background Music'),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.vibration),
              title: const Text('Vibration'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Timer Display'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}