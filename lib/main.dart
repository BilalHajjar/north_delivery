class SettingsProvider extends ChangeNotifier {
  Map<String, bool> _settings = {
    'notifications': true,
    'darkMode': false
  };

  void updateSetting(String key, bool value) {
    _settings[key] = value;
  }
}

class SettingsSwitch extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Column(
      children: [
        Switch(
          value: settings._settings['notifications'],
          onChanged: (value) => settings.updateSetting('notifications', value),
        ),
        Switch(
          value: settings._settings['darkMode'],
          onChanged: (value) => settings.updateSetting('darkMode', value),
        ),
      ],
    );
  }
}
