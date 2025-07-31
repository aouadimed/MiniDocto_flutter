import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

class UserModel {
    UserModel({
        required this.token,
        required this.refreshToken,
        required this.role,
        required this.email,
        required this.message,
    });

    final String? token;
    final String? refreshToken;
    final String? role;
    final String? email;
    final String? message;

    factory UserModel.fromJson(Map<String, dynamic> json){ 
        return UserModel(
            token: json["token"],
            refreshToken: json["refreshToken"],
            role: json["role"],
            email: json["email"],
            message: json["message"],
        );
    }

    Map<String, dynamic> toJson() => {
        "token": token,
        "refreshToken": refreshToken,
        "role": role,
        "email": email,
        "message": message,
    };

}
