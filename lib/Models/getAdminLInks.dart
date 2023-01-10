/// status : true
/// result : "found"
/// data : [{"ref_id":"6","userid":"106764933065187174744","username":"Taki Rajani","link":"https://youtu.be/3xDYa6zf0vs","postDateTime":"01-12-2022 10:26 AM","city":"Nadeem","channelName":"taki rajani channel"},{"ref_id":"5","userid":"106764933065187174744","username":"Taki Rajani","link":"https://youtu.be/MJ_vmdIJIRw","postDateTime":"29-11-2022 10:14 PM","city":"tt","channelName":"masoomeen channel"}]

class GetAdminLInks {
  GetAdminLInks({
      bool? status, 
      String? result, 
      List<Data>? data,}){
    _status = status;
    _result = result;
    _data = data;
}

  GetAdminLInks.fromJson(dynamic json) {
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
GetAdminLInks copyWith({  bool? status,
  String? result,
  List<Data>? data,
}) => GetAdminLInks(  status: status ?? _status,
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