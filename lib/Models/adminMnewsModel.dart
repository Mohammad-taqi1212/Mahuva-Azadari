/// status : true
/// result : "found"
/// data : [{"ref_id":"9","id":"106764933065187174744","name":"vvg","city":"ff","date":"25-12-2022","mayyatTime":"Will update","image_path":"Posts_Images/POST-IMG1352517586.jpg","namazTime":"Will update","Address":"cfg","postTime":"25-12-2022 09:09 PM","username":"Taki Rajani"}]

class AdminMnewsModel {
  AdminMnewsModel({
      bool? status, 
      String? result, 
      List<Data>? data,}){
    _status = status;
    _result = result;
    _data = data;
}

  AdminMnewsModel.fromJson(dynamic json) {
    _status = json['status'];
    _result = json['result'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _result;
  List<Data>? _data;
AdminMnewsModel copyWith({  bool? status,
  String? result,
  List<Data>? data,
}) => AdminMnewsModel(  status: status ?? _status,
  result: result ?? _result,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get result => _result;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['result'] = _result;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// ref_id : "9"
/// id : "106764933065187174744"
/// name : "vvg"
/// city : "ff"
/// date : "25-12-2022"
/// mayyatTime : "Will update"
/// image_path : "Posts_Images/POST-IMG1352517586.jpg"
/// namazTime : "Will update"
/// Address : "cfg"
/// postTime : "25-12-2022 09:09 PM"
/// username : "Taki Rajani"

class Data {
  Data({
      String? refId, 
      String? id, 
      String? name, 
      String? city, 
      String? date, 
      String? mayyatTime, 
      String? imagePath, 
      String? namazTime, 
      String? address, 
      String? postTime, 
      String? username,}){
    _refId = refId;
    _id = id;
    _name = name;
    _city = city;
    _date = date;
    _mayyatTime = mayyatTime;
    _imagePath = imagePath;
    _namazTime = namazTime;
    _address = address;
    _postTime = postTime;
    _username = username;
}

  Data.fromJson(dynamic json) {
    _refId = json['ref_id'];
    _id = json['id'];
    _name = json['name'];
    _city = json['city'];
    _date = json['date'];
    _mayyatTime = json['mayyatTime'];
    _imagePath = json['image_path'];
    _namazTime = json['namazTime'];
    _address = json['Address'];
    _postTime = json['postTime'];
    _username = json['username'];
  }
  String? _refId;
  String? _id;
  String? _name;
  String? _city;
  String? _date;
  String? _mayyatTime;
  String? _imagePath;
  String? _namazTime;
  String? _address;
  String? _postTime;
  String? _username;
Data copyWith({  String? refId,
  String? id,
  String? name,
  String? city,
  String? date,
  String? mayyatTime,
  String? imagePath,
  String? namazTime,
  String? address,
  String? postTime,
  String? username,
}) => Data(  refId: refId ?? _refId,
  id: id ?? _id,
  name: name ?? _name,
  city: city ?? _city,
  date: date ?? _date,
  mayyatTime: mayyatTime ?? _mayyatTime,
  imagePath: imagePath ?? _imagePath,
  namazTime: namazTime ?? _namazTime,
  address: address ?? _address,
  postTime: postTime ?? _postTime,
  username: username ?? _username,
);
  String? get refId => _refId;
  String? get id => _id;
  String? get name => _name;
  String? get city => _city;
  String? get date => _date;
  String? get mayyatTime => _mayyatTime;
  String? get imagePath => _imagePath;
  String? get namazTime => _namazTime;
  String? get address => _address;
  String? get postTime => _postTime;
  String? get username => _username;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ref_id'] = _refId;
    map['id'] = _id;
    map['name'] = _name;
    map['city'] = _city;
    map['date'] = _date;
    map['mayyatTime'] = _mayyatTime;
    map['image_path'] = _imagePath;
    map['namazTime'] = _namazTime;
    map['Address'] = _address;
    map['postTime'] = _postTime;
    map['username'] = _username;
    return map;
  }

}