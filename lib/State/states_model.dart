class StateModel {
  int? id;
  String? name;
  String? iso2;
  StateModel({this.id, this.name, this.iso2});
  StateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    iso2 = json['iso2'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['iso2'] = iso2;
    return data;
  }
}