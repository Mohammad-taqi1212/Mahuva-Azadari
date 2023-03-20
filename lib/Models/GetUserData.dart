class GetUserData {
  String? name;
  String? email;
  String? isAdmin;

  GetUserData({this.name, this.email, this.isAdmin});

  GetUserData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    isAdmin = json['isAdmin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['isAdmin'] = this.isAdmin;
    return data;
  }
}