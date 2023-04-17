import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:last/dao/dao.dart';

import 'package:last/models/profile_model.dart';

import '../api_connection/api_connection.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  ProfilePage({required this.userId});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Profile> _futureProfile;

  @override
  void initState() {
    super.initState();
    _futureProfile = fetchProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<Profile>(
        future: _futureProfile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.0),
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(
                      'http://192.168.0.8:8000' + snapshot.data!.profilePic),
                ),
                SizedBox(height: 20.0),
                Text(snapshot.data!.bio),
                SizedBox(height: 20.0),
                Text('City: ${snapshot.data!.city}'),
                SizedBox(height: 20.0),
                Text('Instagram: ${snapshot.data!.instagram}'),
                SizedBox(height: 20.0),
                Text('Facebook: ${snapshot.data!.facebook}'),
                SizedBox(height: 20.0),
                Text('Twitter: ${snapshot.data!.twitter}'),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}
