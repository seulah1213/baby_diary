import 'dart:convert';
import 'dart:io';

import 'package:baby_diary/model/profile_list.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BabyProfile extends StatefulWidget {
  BabyProfile(this.babyName, this.babyBirth, this.base64Image);

  final String babyName;
  final String babyBirth;
  final String base64Image;
  @override
  _BabyProfileState createState() => _BabyProfileState();
}

class _BabyProfileState extends State<BabyProfile> {
  File _imagePath;
  String _base64Image;
  String _babyName;
  String _babyBirth;
  List<Profile> profileList = <Profile>[];

  @override
  void initState() {
    _base64Image = widget.base64Image;
    _babyName = widget.babyName;
    _babyBirth = widget.babyBirth;
    super.initState();
  }

// TODO : 오류3. 아기 프로필 입력시 갤러리 선택 창 뜨지 않음 & 아기 이름, 생일 입력 시 반영 안됨
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('아기 프로필 입력'),
          centerTitle: true,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Profile returnProfile = Profile(
                  babyImage: widget.base64Image,
                  babyName: widget.babyName,
                  babyBirth: widget.babyBirth);
              Navigator.pop(context, returnProfile);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Profile returnProfile = Profile(
                    babyImage: _base64Image,
                    babyName: _babyName,
                    babyBirth: _babyBirth);
                Navigator.pop(context, returnProfile);
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  getImage();
                },
                child: CircleAvatar(
                  backgroundImage: _base64Image != null
                      ? MemoryImage(base64.decode(_base64Image))
                      : AssetImage('images/photo_12345.png'),
                  backgroundColor: Colors.white,
                  radius: 60.0,
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                leading: Text('아기 이름'),
                title: TextField(
                  controller: TextEditingController(text: _babyName),
                  onChanged: (String value) {
                    _babyName = value;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Divider(
                height: 1.0,
                thickness: 1,
              ),
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: Text('아기 생일'),
                title: TextField(
                  controller: TextEditingController(text: _babyBirth),
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(border: InputBorder.none),
                  onTap: () async {
                    await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100))
                        .then((date) {
                      setState(() {
                        _babyBirth = date.toString().substring(0, 10);
                      });
                    });
                  },
                ),
              ),
              Divider(
                height: 1.0,
                thickness: 1,
              ),
            ],
          ),
        ));
  }

  void getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imagePath = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
      _base64Image = base64Encode(_imagePath.readAsBytesSync());
      print(_base64Image);
    });
  }
}
