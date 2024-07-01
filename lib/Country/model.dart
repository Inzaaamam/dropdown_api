class CountryModel {
  int? id;
  String? name;
  String? iso2;
  String? iso3;
  String? phonecode;
  String? capital;
  String? currency;
  String? native;
  String? emoji;
  CountryModel(
      {this.id,
      this.name,
      this.iso2,
      this.iso3,
      this.phonecode,
      this.capital,
      this.currency,
      this.native,
      this.emoji});

  CountryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    iso2 = json['iso2'];
    iso3 = json['iso3'];
    phonecode = json['phonecode'];
    capital = json['capital'];
    currency = json['currency'];
    native = json['native'];
    emoji = json['emoji'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['iso2'] = iso2;
    data['iso3'] = iso3;
    data['phonecode'] = phonecode;
    data['capital'] = capital;
    data['currency'] = currency;
    data['native'] = native;
    data['emoji'] = emoji;
    return data;
  }
}