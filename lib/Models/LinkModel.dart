/// status : true
/// result : "found"
/// data : [{"ref_id":"6","userid":"106764933065187174744","username":"Taki Rajani","link":"https://youtu.be/3xDYa6zf0vs","postDateTime":"01-12-2022 10:26 AM","city":"Nadeem","channelName":"taki rajani channel"},{"ref_id":"5","userid":"106764933065187174744","username":"Taki Rajani","link":"https://youtu.be/MJ_vmdIJIRw","postDateTime":"29-11-2022 10:14 PM","city":"tt","channelName":"masoomeen channel"},{"ref_id":"1","userid":"taki","username":"Taki Rajani","link":"https://youtu.be/wf9oETBOxPY","postDateTime":"20-11-22 11:30 PM","city":"Mahuva","channelName":"admin channel"},{"ref_id":"2","userid":"taki1212","username":"Taki Rajani","link":"https://youtu.be/K-MYE2DyS-I","postDateTime":"20-11-22 12:52 PM","city":"Bhavnagar","channelName":"alamdar grp mahuva"},{"ref_id":"4","userid":"1","username":"Taqi","link":"testUrl","postDateTime":"TIme Date","city":"City","channelName":"alvi channel"}]
/// totalPosts : "5"
/// totalPages : 1
/// perPageLimit : 5
/// currentPage : 1
/// hasNextPage : 0

class LinkModel {
  LinkModel({
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

  LinkModel.fromJson(dynamic json) {
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
LinkModel copyWith({  bool? status,
  String? result,
  List<Data>? data,
  String? totalPosts,
  num? totalPages,
  num? perPageLimit,
  num? currentPage,
  num? hasNextPage,
}) => LinkModel(  status: status ?? _status,
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

/// ref_id : "6"
/// userid : "106764933065187174744"
/// username : "Taki Rajani"
/// link : "https://youtu.be/3xDYa6zf0vs"
/// postDateTime : "01-12-2022 10:26 AM"
/// city : "Nadeem"
/// channelName : "taki rajani channel"

class Data {
  Data({
      String? refId, 
      String? userid, 
      String? username, 
      String? link, 
      String? postDateTime, 
      String? city, 
      String? channelName,}){
    _refId = refId;
    _userid = userid;
    _username = username;
    _link = link;
    _postDateTime = postDateTime;
    _city = city;
    _channelName = channelName;
}

  Data.fromJson(dynamic json) {
    _refId = json['ref_id'];
    _userid = json['userid'];
    _username = json['username'];
    _link = json['link'];
    _postDateTime = json['postDateTime'];
    _city = json['city'];
    _channelName = json['channelName'];
  }
  String? _refId;
  String? _userid;
  String? _username;
  String? _link;
  String? _postDateTime;
  String? _city;
  String? _channelName;
Data copyWith({  String? refId,
  String? userid,
  String? username,
  String? link,
  String? postDateTime,
  String? city,
  String? channelName,
}) => Data(  refId: refId ?? _refId,
  userid: userid ?? _userid,
  username: username ?? _username,
  link: link ?? _link,
  postDateTime: postDateTime ?? _postDateTime,
  city: city ?? _city,
  channelName: channelName ?? _channelName,
);
  String? get refId => _refId;
  String? get userid => _userid;
  String? get username => _username;
  String? get link => _link;
  String? get postDateTime => _postDateTime;
  String? get city => _city;
  String? get channelName => _channelName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ref_id'] = _refId;
    map['userid'] = _userid;
    map['username'] = _username;
    map['link'] = _link;
    map['postDateTime'] = _postDateTime;
    map['city'] = _city;
    map['channelName'] = _channelName;
    return map;
  }

}