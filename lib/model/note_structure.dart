
class Note {
  int _id;
  String _title;
  String _description;

  Note(this._title,this._description);
  Note.withId(this._id,this._title,this._description);

  int get id => _id;

  String get description => _description;

  String get title => _title;

  set description(String value) {
    _description = value;
  }

  set title(String value) {
    _title = value;
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
    map['title'] = _title;
    map['description'] = _description;
    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
  }

}