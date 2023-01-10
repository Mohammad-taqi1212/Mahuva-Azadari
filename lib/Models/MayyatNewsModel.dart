/// status : true
/// result : "found"
/// data : [{"ref_id":"5","id":"106764933065187174744","name":"sarafarz lakhani","city":"mahuva","date":"24-12-2022","mayyatTime":"9:00 PM","image_path":"Posts_Images/POST-IMG917731332.jpg","namazTime":"10:00 PM","Address":"hhh","postTime":"24-12-2022 05:05 PM","username":"Taki Rajani"},{"ref_id":"4","id":"demo123","name":"test demo","city":"test demo","date":"21-12-2022","mayyatTime":"10:00","image_path":"Posts_Images/POST-IMG1987695949.png","namazTime":"9:00","Address":"ssss","postTime":"21-12-22 6:00 PM","username":"admin"},{"ref_id":"1","id":"1","name":"Fajal Abbas Mohammad Bhai","city":"Mahuva","date":"23-11-2022","mayyatTime":"10:30","image_path":null,"namazTime":"12:30","Address":"Shanti baug, near jafari school , mahuva, ","postTime":"4:03 3/11/22","username":"Taki Rajani"}]
/// totalPosts : "4"
/// totalPages : 2
/// perPageLimit : 3
/// currentPage : 1
/// hasNextPage : 1

class AdminMnewsModel {
  AdminMnewsModel({
      bool? status, 
      String? result, 
      List<Data>? data, 
      String? totalPosts, 
      num? totalPages, 
      num? perPageLimit, 
      num? currentPage, 
      num? hasNextPage,}){
    _status = status;
    _result = result;
    _data = data;
    _totalPosts = totalPosts;
    _totalPages = totalPages;
    _perPageLimit = perPageLimit;
    _currentPage = currentPage;
    _hasNextPage = hasNextPage;
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
    _totalPosts = json['totalPosts'];
    _totalPages = json['totalPages'];
    _perPageLimit = json['perPageLimit'];
    _currentPage = json['currentPage'];
    _hasNextPage = json['hasNextPage'];
  }
  bool? _status;
  String? _result;
  List<Data>? _data;
  String? _totalPosts;
  num? _totalPages;
  num? _perPageLimit;
  num? _currentPage;
  num? _hasNextPage;
AdminMnewsModel copyWith({  bool? status,
  String? result,
  List<Data>? data,
  String? totalPosts,
  num? totalPages,
  num? perPageLimit,
  num? currentPage,
  num? hasNextPage,
}) => AdminMnewsModel(  status: status ?? _status,
  result: result ?? _result,
  data: data ?? _data,
  totalPosts: totalPosts ?? _totalPosts,
  totalPages: totalPages ?? _totalPages,
  perPageLimit: perPageLimit ?? _perPageLimit,
  currentPage: currentPage ?? _currentPage,
  hasNextPage: hasNextPage ?? _hasNextPage,
);
  bool? get status => _status;
  String? get result => _result;
  List<Data>? get data => _data;
  String? get totalPosts => _totalPosts;
  num? get totalPages => _totalPages;
  num? get perPageLimit => _perPageLimit;
  num? get currentPage => _currentPage;
  num? get hasNextPage => _hasNextPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['result'] = _result;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['totalPosts'] = _totalPosts;
    map['totalPages'] = _totalPages;
    map['perPageLimit'] = _perPageLimit;
    map['currentPage'] = _currentPage;
    map['hasNextPage'] = _hasNextPage;
    return map;
  }

}

/// ref_id : "5"
/// id : "106764933065187174744"
/// name : "sarafarz lakhani"
/// city : "mahuva"
/// date : "24-12-2022"
/// mayyatTime : "9:00 PM"
/// image_path : "Posts_Images/POST-IMG917731332.jpg"
/// namazTime : "10:00 PM"
/// Address : "hhh"
/// postTime : "24-12-2022 05:05 PM"
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