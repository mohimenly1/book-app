import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/theme_provider.dart';
import '../../hotel_booking/playground_app_theme.dart';

class SettingsScreen extends StatelessWidget {
  static String routeName = "/settings";

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الإعدادت',
          style: TextStyle(fontFamily: 'HacenSamra'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        children: [
          _buildThemeSwitch(context),
          _buildLanguageSwitch(),
          _buildNotificationSwitch(),
        ],
      ),
    );
  }

  Widget _buildThemeSwitch(BuildContext context) {
    return ListTile(
      title: const Text(
        'Dark Mode',
        style: TextStyle(fontFamily: 'HacenSamra'),
      ),
      trailing: Switch(
        value: Provider.of<ThemeProvider>(context).themeData ==
            HotelAppTheme.buildDarkTheme(),
        onChanged: (value) {
          Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
        },
      ),
    );
  }

  Widget _buildLanguageSwitch() {
    return ListTile(
      title: const Text('Language'),
      trailing: const Icon(Icons.language),
      onTap: () {
        // Implement language switch functionality
      },
    );
  }

  Widget _buildNotificationSwitch() {
    return ListTile(
      title: const Text('Notifications'),
      trailing: const Icon(Icons.notifications),
      onTap: () {
        // Implement notification switch functionality
      },
    );
  }
}
