
class Cardone {
  int _id;
  String _name;
  String _company_name;
  String _mobile;
  String _emailid;
  String _website;

  Cardone(this._name,this._company_name,this._mobile,this._emailid,this._website);
  Cardone.withId(this._id,this._name,this._company_name,this._mobile,this._emailid,this._website);

  String get website => _website;

  String get emailid => _emailid;

  String get mobile => _mobile;

  String get company_name => _company_name;

  String get name => _name;

  int get id => _id;

  set website(String value) {
    _website = value;
  }

  set emailid(String value) {
    _emailid = value;
  }

  set mobile(String value) {
    _mobile = value;
  }

  set company_name(String value) {
    _company_name = value;
  }

  set name(String value) {
    _name = value;
  }

  set id(int value) {
    _id = value;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['company_name'] = _company_name;
    map['mobile'] = _mobile;
    map['emailid'] = _emailid;
    map['website'] = _website;

    return map;
  }

  // Extract a Note object from a Map object
  Cardone.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._company_name = map['company_name'];
    this._mobile = map['mobile'];
    this._emailid = map['emailid'];
    this._website = map['website'];
  }

}