/// status : true
/// result : "found"
/// data : [{"ref_id":"27","postId":"106764933065187174744","azakhana_name":"g","city_name":"gg","description":"g","end_date":"29-11-2022","image_path":"Posts_Images/POST-IMG77030444.jpg","name_of_schollar":"g","postDateTime":"29-11-2022 03:49 PM","program_list":"Majlis","special_notes":"g","start_date":"29-11-2022","time":"3:45 PM","user_name":"Taki Rajani"},{"ref_id":"2","postId":"106764933065187174744","azakhana_name":"Abutalib hall","city_name":"Mahuva","description":"Why do we use it?\r\nIt is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).","end_date":"10-11-2022","image_path":null,"name_of_schollar":"Molana sadikhasan Najfi sahab","postDateTime":"06-11-2022 10:00 AM","program_list":"Majlis","special_notes":"nop","start_date":"10-11-2022","time":"8:45 PM","user_name":"Taki Rajani"},{"ref_id":"1","postId":"106764933065187174744","azakhana_name":"Shanti buagh hall","city_name":"Mahuva","description":"What is Lorem Ipsum?\r\nLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum","end_date":"30-11-2022","image_path":null,"name_of_schollar":"Molana Aliabbas Khan","postDateTime":"07-11-22 12:57 PM","program_list":"Majlis","special_notes":"Nayyaze hussain as rakhel che","start_date":"07-11-2022","time":"9:00 PM","user_name":"Taki Rajani "}]

class GetAdminPost {
  GetAdminPost({
      bool? status, 
      String? result, 
      List<Data>? data,}){
    _status = status;
    _result = result;
    _data = data;
}

  GetAdminPost.fromJson(dynamic json) {
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
GetAdminPost copyWith({  bool? status,
  String? result,
  List<Data>? data,
}) => GetAdminPost(  status: status ?? _status,
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

/// ref_id : "27"
/// postId : "106764933065187174744"
/// azakhana_name : "g"
/// city_name : "gg"
/// description : "g"
/// end_date : "29-11-2022"
/// image_path : "Posts_Images/POST-IMG77030444.jpg"
/// name_of_schollar : "g"
/// postDateTime : "29-11-2022 03:49 PM"
/// program_list : "Majlis"
/// special_notes : "g"
/// start_date : "29-11-2022"
/// time : "3:45 PM"
/// user_name : "Taki Rajani"

class Data {
  Data({
      String? refId, 
      String? postId, 
      String? azakhanaName, 
      String? cityName, 
      String? description, 
      String? endDate, 
      String? imagePath, 
      String? nameOfSchollar, 
      String? postDateTime, 
      String? programList, 
      String? specialNotes, 
      String? startDate, 
      String? time, 
      String? userName,}){
    _refId = refId;
    _postId = postId;
    _azakhanaName = azakhanaName;
    _cityName = cityName;
    _description = description;
    _endDate = endDate;
    _imagePath = imagePath;
    _nameOfSchollar = nameOfSchollar;
    _postDateTime = postDateTime;
    _programList = programList;
    _specialNotes = specialNotes;
    _startDate = startDate;
    _time = time;
    _userName = userName;
}

  Data.fromJson(dynamic json) {
    _refId = json['ref_id'];
    _postId = json['postId'];
    _azakhanaName = json['azakhana_name'];
    _cityName = json['city_name'];
    _description = json['description'];
    _endDate = json['end_date'];
    _imagePath = json['image_path'];
    _nameOfSchollar = json['name_of_schollar'];
    _postDateTime = json['postDateTime'];
    _programList = json['program_list'];
    _specialNotes = json['special_notes'];
    _startDate = json['start_date'];
    _time = json['time'];
    _userName = json['user_name'];
  }
  String? _refId;
  String? _postId;
  String? _azakhanaName;
  String? _cityName;
  String? _description;
  String? _endDate;
  String? _imagePath;
  String? _nameOfSchollar;
  String? _postDateTime;
  String? _programList;
  String? _specialNotes;
  String? _startDate;
  String? _time;
  String? _userName;
Data copyWith({  String? refId,
  String? postId,
  String? azakhanaName,
  String? cityName,
  String? description,
  String? endDate,
  String? imagePath,
  String? nameOfSchollar,
  String? postDateTime,
  String? programList,
  String? specialNotes,
  String? startDate,
  String? time,
  String? userName,
}) => Data(  refId: refId ?? _refId,
  postId: postId ?? _postId,
  azakhanaName: azakhanaName ?? _azakhanaName,
  cityName: cityName ?? _cityName,
  description: description ?? _description,
  endDate: endDate ?? _endDate,
  imagePath: imagePath ?? _imagePath,
  nameOfSchollar: nameOfSchollar ?? _nameOfSchollar,
  postDateTime: postDateTime ?? _postDateTime,
  programList: programList ?? _programList,
  specialNotes: specialNotes ?? _specialNotes,
  startDate: startDate ?? _startDate,
  time: time ?? _time,
  userName: userName ?? _userName,
);
  String? get refId => _refId;
  String? get postId => _postId;
  String? get azakhanaName => _azakhanaName;
  String? get cityName => _cityName;
  String? get description => _description;
  String? get endDate => _endDate;
  String? get imagePath => _imagePath;
  String? get nameOfSchollar => _nameOfSchollar;
  String? get postDateTime => _postDateTime;
  String? get programList => _programList;
  String? get specialNotes => _specialNotes;
  String? get startDate => _startDate;
  String? get time => _time;
  String? get userName => _userName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ref_id'] = _refId;
    map['postId'] = _postId;
    map['azakhana_name'] = _azakhanaName;
    map['city_name'] = _cityName;
    map['description'] = _description;
    map['end_date'] = _endDate;
    map['image_path'] = _imagePath;
    map['name_of_schollar'] = _nameOfSchollar;
    map['postDateTime'] = _postDateTime;
    map['program_list'] = _programList;
    map['special_notes'] = _specialNotes;
    map['start_date'] = _startDate;
    map['time'] = _time;
    map['user_name'] = _userName;
    return map;
  }

}