import 'package:jwt_decoder/jwt_decoder.dart';

class UserLogin {
  String username;
  String password;

  UserLogin({required this.username, required this.password});

  Map<String, dynamic> toDatabaseJson() =>
      {"username": this.username, "password": this.password};
}

class UserRegister {
  String email;
  String username;
  String password;

  UserRegister(
      {required this.email, required this.username, required this.password});

  Map<String, dynamic> toDatabaseJson() => {
        "email": this.email,
        "username": this.username,
        "password": this.password
      };
}

// class Address {
//   String streetAddress;
//   String locality;
//   String city;
//   String state;
//   int pinCode;

//   Address(
//       {this.streetAddress, this.locality, this.city, this.state, this.pinCode});

//   Map<String, dynamic> toDatabaseJson() => {
//         "street_address": this.streetAddress,
//         "locality": this.locality,
//         "city": this.city,
//         "state": this.state,
//         "pin_code": this.pinCode
//       };
// }

// class UserDetails {
//   String username;
//   String firstName;
//   String lastName;
//   String email;
//   String password;

//   UserDetails(
//       {this.username,
//       this.firstName,
//       this.lastName,
//       this.email,
//       this.password});

//   Map<String, dynamic> toDatabaseJson() => {
//         "username": this.username,
//         "first_name": this.firstName,
//         "last_name": this.lastName,
//         "email": this.email,
//         "password": this.password
//       };
// }

// class UserSignup {
//   UserDetails user;
//   Address address;

//   UserSignup({this.user, this.address});

//   Map<String, dynamic> toDatabaseJson() => {
//         "user": this.user.toDatabaseJson(),
//         "address": this.address.toDatabaseJson(),
//         "profile_type": "user"
//       };
// }

// class User {
//   int userId;
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(userId: json[])
//   }
// }

class Token {
  String token;
  String refreshToken;

  Token({required this.token, required this.refreshToken});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
        token: json['access'].toString(),
        refreshToken: json['refresh'].toString());
  }

  Map<String, dynamic> fetchUser(String token) {
    Map<String, dynamic> userCreds = JwtDecoder.decode(token);
    print('APIMODELSSSSS ${userCreds}');
    return userCreds;
  }
}




// class Option {
//   String label;
//   String value;

//   Option({this.label, this.value});

//   factory Option.fromJson(Map<String, dynamic> json) {
//     return Option(label: json["label"], value: json["value"]["input"]["text"]);
//   }
// }

// class Response {
//   String responseText;
//   List<Option> options;

//   Response({this.responseText, this.options});
// }

// class Message {
//   String message;
//   String sessionId;

//   Message({this.message, this.sessionId});

//   Map<String, dynamic> toDatabaseJson() =>
//       {"message": this.message, "session_id": this.sessionId};
// }

// class GraphParams {
//   String date;
//   int deaths;

//   GraphParams({this.date, this.deaths});
// }
