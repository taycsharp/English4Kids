import 'package:flutter/material.dart';

import '../app.dart';
import '../models/child_profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final nameController = TextEditingController();
  int age = 6;
  String level = 'Beginner';
  String languageSupport = 'English + Vietnamese';
  String speechSpeed = 'Slow';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    final profile = await AppScope.of(context).progressService.loadProfile();
    if (!mounted) return;
    setState(() {
      nameController.text = profile.name;
      age = profile.age;
      level = profile.level;
      languageSupport = profile.languageSupport;
      speechSpeed = profile.speechSpeed;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final profile = ChildProfile(
      name: nameController.text.trim().isEmpty ? 'Kid' : nameController.text.trim(),
      age: age,
      level: level,
      languageSupport: languageSupport,
      speechSpeed: speechSpeed,
    );
    final scope = AppScope.of(context);
    await scope.progressService.saveProfile(profile);
    await scope.ttsService.setSlow(speechSpeed == 'Slow');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved!')));
  }

  Future<void> _reset() async {
    await AppScope.of(context).progressService.reset();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Progress reset.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Child name', border: OutlineInputBorder())),
          const SizedBox(height: 14),
          DropdownButtonFormField<int>(initialValue: age, decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()), items: List.generate(6, (i) => i + 5).map((v) => DropdownMenuItem(value: v, child: Text('$v'))).toList(), onChanged: (v) => setState(() => age = v ?? age)),
          const SizedBox(height: 14),
          _dropdown('English level', level, ['Beginner', 'Easy', 'Medium'], (v) => setState(() => level = v)),
          const SizedBox(height: 14),
          _dropdown('Language support', languageSupport, ['English only', 'English + Vietnamese'], (v) => setState(() => languageSupport = v)),
          const SizedBox(height: 14),
          _dropdown('Speech speed', speechSpeed, ['Slow', 'Normal'], (v) => setState(() => speechSpeed = v)),
          const SizedBox(height: 22),
          FilledButton.icon(onPressed: _save, icon: const Icon(Icons.save_rounded), label: const Text('Save Settings')),
          const SizedBox(height: 14),
          OutlinedButton.icon(onPressed: _reset, icon: const Icon(Icons.refresh_rounded), label: const Text('Reset progress')),
        ],
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items, ValueChanged<String> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: (v) => onChanged(v ?? value),
    );
  }
}
