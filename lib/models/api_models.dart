import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:last/dao/dao.dart';


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
