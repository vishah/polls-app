class User {
  int _expires_in;
  String _access_token;
  String _refresh_token;

  User(this._expires_in, this._access_token, this._refresh_token);

  User.map(dynamic obj) {
    this._expires_in = obj["expires_in"];
    this._access_token = obj["access_token"];
    this._refresh_token = obj["refresh_token"];
  }

  int get expires_in => _expires_in;
  String get access_token => _access_token;
  String get refresh_token => _refresh_token;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["expires_in"] = _expires_in;
    map["access_token"] = _access_token;
    map["refresh_token"] = _refresh_token;

    return map;
  }
}
