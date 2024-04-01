// To parse this JSON data, do
//
//     final userImageModel = userImageModelFromJson(jsonString);

import 'dart:convert';

UserImageModel userImageModelFromJson(String str) => UserImageModel.fromJson(json.decode(str));

String userImageModelToJson(UserImageModel data) => json.encode(data.toJson());

class UserImageModel {
  UserImageModel({
    required this.id,
    required this.profileImage,
    required this.compressedProfileImage,
  });

  String id;
  String profileImage;
  String compressedProfileImage;

  factory UserImageModel.fromJson(Map<String, dynamic> json) => UserImageModel(
    id: json["_id"],
    profileImage: json["profile_image"],
    compressedProfileImage: json["compressed_profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "profile_image": profileImage,
    "compressed_profile_image": compressedProfileImage,
  };
}
