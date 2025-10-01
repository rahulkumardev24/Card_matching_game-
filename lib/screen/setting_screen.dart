import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                value: true,
                onChanged: (value) {},
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