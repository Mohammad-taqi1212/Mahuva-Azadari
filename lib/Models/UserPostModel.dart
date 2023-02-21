/// status : true
/// result : "found"
/// data : [{"ref_id":"37","postId":"106764933065187174744","azakhana_name":"Sakina hall","city_name":"Mahuva","description":"no detail","end_date":"14-01-2023","image_path":"Posts_Images/POST-IMG1423956606.jpg","name_of_schollar":"Molana sahab","postDateTime":"05-01-2023 11:49 AM","program_list":"Majlis","special_notes":"no notes","start_date":"07-01-2023","time":"10:00 AM","user_name":"Taki Rajani","status":"Ongoing"},{"ref_id":"39","postId":"106764933065187174744","azakhana_name":"aaa","city_name":"sss","description":"ssss","end_date":"05-01-2023","image_path":"Posts_Images/POST-IMG869535151.jpg","name_of_schollar":"ssss","postDateTime":"05-01-2023 12:07 PM","program_list":"Majlis","special_notes":"ss","start_date":"05-01-2023","time":"12:07 PM","user_name":"Taki Rajani","status":"Past"},{"ref_id":"38","postId":"106764933065187174744","azakhana_name":"Najaf Hall","city_name":"Mahuva","description":"no detail","end_date":"10-01-2023","image_path":"Posts_Images/POST-IMG1677242263.jpg","name_of_schollar":"Molana ghareem abbas","postDateTime":"05-01-2023 11:51 AM","program_list":"Majlis","special_notes":"no notes","start_date":"04-01-2023","time":"11:00 AM","user_name":"Taki Rajani","status":"Past"}]
/// totalPosts : "5"
/// totalPages : 2
/// perPageLimit : 3
/// currentPage : 1
/// hasNextPage : 1

class UserPostModel {
  UserPostModel({
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

  UserPostModel.fromJson(dynamic json) {
    _status = json['status'] == "true";
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
UserPostModel copyWith({  bool? status,
  String? result,
  List<Data>? data,
  String? totalPosts,
  num? totalPages,
  num? perPageLimit,
  num? currentPage,
  num? hasNextPage,
}) => UserPostModel(  status: status ?? _status,
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
  set data(List<Data>? data) => _data = data;
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

/// ref_id : "37"
/// postId : "106764933065187174744"
/// azakhana_name : "Sakina hall"
/// city_name : "Mahuva"
/// description : "no detail"
/// end_date : "14-01-2023"
/// image_path : "Posts_Images/POST-IMG1423956606.jpg"
/// name_of_schollar : "Molana sahab"
/// postDateTime : "05-01-2023 11:49 AM"
/// program_list : "Majlis"
/// special_notes : "no notes"
/// start_date : "07-01-2023"
/// time : "10:00 AM"
/// user_name : "Taki Rajani"
/// status : "Ongoing"

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
      String? userName, 
      String? status,}){
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
    _status = status;
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
    _status = json['status'];
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
  String? _status;
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
  String? status,
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
  status: status ?? _status,
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
  String? get status => _status;

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
    map['status'] = _status;
    return map;
  }

}