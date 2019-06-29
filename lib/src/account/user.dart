import 'package:vsartist/src/global/uidata.dart';

class UserLogin {
  String _username;
  String _password;
  UserLogin(this._username, this._password);

  UserLogin.map(dynamic obj) {
    this._username = obj["username"];
    this._password = obj["password"];
  }

  String get username => _username;
  String get password => _password;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["password"] = _password;

    return map;
  }
}



class SignupForm {
  String stage_name;
  String username;
  String email;
  String phone;
  String state;
  String city;
  String password;
  String password_confirmation;

  SignupForm(
      {this.username,
      this.stage_name,
      this.email,
      this.phone,
      this.state,
      this.city,
      this.password,
      this.password_confirmation
      });

  factory SignupForm.fromJson(Map<String, dynamic> json) {
    return SignupForm(
      stage_name: json['stage_name'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      state: json['state'],
      city: json['city'],
      password: json['password'],
      password_confirmation: json['password_confirmation']
    );
  }
}

class User {
  String username;
  String name;
  String email;
  String phone;
  String token;
  String avatar;
  String wallet;
  String stage_name;
  User(
      {this.name,
      this.email,
      this.phone,
      this.token,
      this.avatar,
      this.wallet,
      this.stage_name
      });

  factory User.map(Map<dynamic, dynamic> obj) {
    return User(
      name: obj['name'] as String,
      email: obj['email'],
      phone: obj['phone'],
      token: obj['token'],
      avatar: obj['avatar']??UiData.userPlaceholder,
      wallet: obj['wallet'],
      stage_name: obj['stage_name'],
    );
  }

  static final Columns = [
    "username",
    "name",
    "email",
    "phone",
    "token",
    "avatar",
    "wallet",
    "stage_name"
  ];

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["name"] = name;
    map["email"] = email;
    map["phone"] = phone;
    map["token"] = token;
    map["avatar"] = avatar;
    map["wallet"] = wallet;
    map["stage_name"] = stage_name;
    return map;
  }
}

class UserLive {
  String id;
  String username;
  String surname;
  String firstname;
  String othernames;
  String token;
  String email;
  String user_type;
  String phone;
  String image;
  String wallet;
  String previous_wallet;
  String unique_id;
  UserLive(
      {this.id,
      this.username,
      this.surname,
      this.firstname,
      this.othernames,
      this.token,
      this.email,
      this.user_type,
      this.phone,
      this.image,
      this.wallet,
      this.previous_wallet,
      this.unique_id});

  factory UserLive.fromJson(Map<dynamic, dynamic> obj) {
    return UserLive(
      id: obj['id'] as String,
      username: obj['username'] as String,
      surname: obj['surname'] as String,
      firstname: obj['firstname'] as String,
      othernames: obj['othernames'] as String,
      token: obj['token'] as String,
      email: obj['email'] as String,
      user_type: obj['user_type'] as String,
      phone: obj['phone'] as String,
      image: obj['image'] as String,
      wallet: obj['wallet'] as String,
      previous_wallet: obj['previous_wallet'] as String,
      unique_id: obj['unique_id'] as String,
    );
  }

  static final Columns = [
    "username",
    "token",
    "email",
    "user_type",
    "phone",
    "image",
    "wallet",
    "unique_id"
  ];

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["token"] = token;
    map["email"] = email;
    map["user_type"] = user_type;
    map["phone"] = phone;
    map["image"] = image;
    map["wallet"] = wallet;
    map["unique_id"] = unique_id;

    return map;
  }
}
