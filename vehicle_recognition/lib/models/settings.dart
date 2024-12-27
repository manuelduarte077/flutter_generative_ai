class Settings {
  final bool isDarkMode;
  final String language;
  final String currency;
  final String country;

  Settings({
    this.isDarkMode = false,
    this.language = 'English',
    this.currency = 'USD',
    this.country = 'Nicaragua',
  });

  Settings copyWith({
    bool? isDarkMode,
    String? language,
    String? currency,
    String? country,
  }) {
    return Settings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      country: country ?? this.country,
    );
  }
}
