import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<String> languages = ['English', 'Español'];
  final List<String> currencies = ['USD', 'NIO', 'EUR', 'CRC', 'GTQ', 'HNL'];
  final List<String> countries = [
    'Nicaragua',
    'Costa Rica',
    'Panama',
    'Honduras',
    'Guatemala'
  ];

  void _showPicker(
      List<String> items, String selectedItem, Function(String) onSelect) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          title: const Text(
            'Select Option',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: items.map((String value) {
            return CupertinoActionSheetAction(
              onPressed: () {
                onSelect(value);
                Navigator.pop(context);
              },
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            middle: Text(
              'Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Theme Toggle
                  CupertinoListSection.insetGrouped(
                    header: const Text(
                      'Appearance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      CupertinoListTile(
                        title: const Text(
                          'Dark Mode',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: CupertinoSwitch(
                          value: settings.isDarkMode,
                          onChanged: (value) => settings.setDarkMode(value),
                        ),
                      ),
                    ],
                  ),

                  // Language Selection
                  CupertinoListSection.insetGrouped(
                    header: const Text(
                      'Language',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      CupertinoListTile(
                        title: const Text(
                          'Language',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              settings.language,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(CupertinoIcons.right_chevron),
                          ],
                        ),
                        onTap: () => _showPicker(
                          languages,
                          settings.language,
                          settings.setLanguage,
                        ),
                      ),
                    ],
                  ),

                  // Currency Selection
                  CupertinoListSection.insetGrouped(
                    header: const Text(
                      'Currency',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      CupertinoListTile(
                        title: const Text(
                          'Currency',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              settings.currency,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(CupertinoIcons.right_chevron),
                          ],
                        ),
                        onTap: () => _showPicker(
                          currencies,
                          settings.currency,
                          settings.setCurrency,
                        ),
                      ),
                    ],
                  ),

                  // Country Selection
                  CupertinoListSection.insetGrouped(
                    header: const Text(
                      'Country',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      CupertinoListTile(
                        title: const Text(
                          'Country',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              settings.country,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(CupertinoIcons.right_chevron),
                          ],
                        ),
                        onTap: () => _showPicker(
                          countries,
                          settings.country,
                          settings.setCountry,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
