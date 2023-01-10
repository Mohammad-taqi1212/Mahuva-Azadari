/// name : "Taki Rajani"
/// email : "mohammadtaki.rajani@gmail.com"
/// isAdmin : "no"
/// description : "test "

class GetUserData {
  GetUserData({
      String? name,
      String? email,
      String? isAdmin,
      String? description,}){
    _name = name;
    _email = email;
    _isAdmin = isAdmin;
    _description = description;
}

  GetUserData.fromJson(dynamic json) {
    _name = json["name"];
    _email = json["email"];
    _isAdmin = json["isAdmin"];
    _description = json["description"];
  }
  String? _name;
  String? _email;
  String? _isAdmin;
  String? _description;
GetUserData copyWith({  String? name,
  String? email,
  String? isAdmin,
  String? description,
}) => GetUserData(  name: name ?? _name,
  email: email ?? _email,
  isAdmin: isAdmin ?? _isAdmin,
  description: description ?? _description,
);
  String? get name => _name;
  String? get email => _email;
  String? get isAdmin => _isAdmin;
  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['email'] = _email;
    map['isAdmin'] = _isAdmin;
    map['description'] = _description;
    return map;
  }

}