import '../core.dart';

///The country Model that has all the country
///information needed from the [country_picker]
class Country {
  static Country worldWide = Country(
    phoneCode: '',
    countryCode: 'WW',
    e164Sc: -1,
    geographic: false,
    level: -1,
    name: 'World Wide',
    example: '',
    displayName: 'World Wide (WW)',
    displayNameNoCountryCode: 'World Wide',
    e164Key: '',
  );
  int id = 0;

  ///The country phone code
  String phoneCode = "";

  ///The country code, ISO (alpha-2)
  String countryCode = "";
  int e164Sc = 0;
  bool geographic = true;
  int level = 0;

  ///The country name in English
  String name = "";

  ///The country name localized
  late String? nameLocalized = "";

  ///An example of a telephone number without the phone code
  String example = "";

  ///Country name (country code) [phone code]
  String displayName = "";

  ///An example of a telephone number with the phone code and plus sign
  String? fullExampleWithPlusSign;

  ///Country name (country code)

  String displayNameNoCountryCode = "";
  String e164Key = "";

  @Deprecated(
    'The modern term is displayNameNoCountryCode. '
    'This feature was deprecated after v1.0.6.',
  )
  String get displayNameNoE164Cc => displayNameNoCountryCode;

  /*String? getTranslatedName(BuildContext context) {
    return CountryLocalizations.of(context)?.countryName(countryCode: countryCode);
  }*/

  Country({
    this.id = 0,
    this.phoneCode = "",
    this.countryCode = "",
    this.e164Sc = 0,
    this.geographic = true,
    this.level = 0,
    this.name = "",
    this.nameLocalized = '',
    this.example = "",
    this.displayName = "",
    this.displayNameNoCountryCode = "",
    this.e164Key = "",
    this.fullExampleWithPlusSign,
  });

  Country.fromJson(Map<String, dynamic> json) {
    // //print("Country.fromJson $json}");
    id = json['id'] ?? 0;
    phoneCode = json['e164_cc'] ?? "";
    countryCode = json['iso2_cc'] ?? "";
    e164Sc = json['e164_sc'] ?? 0;
    geographic = json['geographic'] ?? true;
    level = json['level'] ?? 0;
    name = json['name'] ?? "";
    example = json['example'] ?? "";
    displayName = json['display_name'] ?? "";
    fullExampleWithPlusSign = json['full_example_with_plus_sign'] ?? "";
    displayNameNoCountryCode = json['display_name_no_e164_cc'] ?? "";
    e164Key = json['e164_key'] ?? "";
  }
  /*static Country parse(String country) {
    if (country == worldWide.countryCode) {
      return worldWide;
    } else {
      return CountryParser.parse(country);
    }
  }

  static Country? tryParse(String country) {
    if (country == worldWide.countryCode) {
      return worldWide;
    } else {
      return CountryParser.tryParse(country);
    }
  }*/

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['e164_cc'] = phoneCode;
    data['iso2_cc'] = countryCode;
    data['e164_sc'] = e164Sc;
    data['geographic'] = geographic;
    data['level'] = level;
    data['name'] = name;
    data['example'] = example;
    data['display_name'] = displayName;
    data['full_example_with_plus_sign'] = fullExampleWithPlusSign;
    data['display_name_no_e164_cc'] = displayNameNoCountryCode;
    data['e164_key'] = e164Key;
    return data;
  }

  /*bool startsWith(String query, CountryLocalizations? localizations) {
    String _query = query;
    if (query.startsWith("+")) {
      _query = query.replaceAll("+", "").trim();
    }
    return phoneCode.startsWith(_query.toLowerCase()) ||
        name.toLowerCase().startsWith(_query.toLowerCase()) ||
        countryCode.toLowerCase().startsWith(_query.toLowerCase()) ||
        (localizations
                ?.countryName(countryCode: countryCode)
                ?.toLowerCase()
                .startsWith(_query.toLowerCase()) ??
            false);
  }*/

  bool get iswWorldWide => countryCode == Country.worldWide.countryCode;

  @override
  String toString() => 'Country(countryCode: $countryCode, name: $name)';

  @override
  bool operator ==(Object other) {
    if (other is Country) {
      return other.countryCode == countryCode;
    }

    return super == other;
  }

  @override
  int get hashCode => countryCode.hashCode;

  /// provides country flag as emoji.
  /// Can be displayed using
  ///
  ///```Text(country.flagEmoji)```
  String get flagEmoji => Helper.countryCodeToEmoji(countryCode);
}
