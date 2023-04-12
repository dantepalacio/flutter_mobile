import 'dart:convert';

class Profile {
  final int id;
  final String bio;
  final String city;
  final String profilePic;
  final String instagram;
  final String facebook;
  final String twitter;
  Profile({
    required this.id,
    required this.bio,
    required this.city,
    required this.profilePic,
    required this.instagram,
    required this.facebook,
    required this.twitter,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      bio: json['bio'],
      city: json['city'],
      profilePic: json['profile_pic'],
      instagram: json['instagram'],
      facebook: json['facebook'],
      twitter: json['twitter'],
    );
  }
}