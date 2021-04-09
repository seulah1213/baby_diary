import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

import 'bannerAd.dart';

class AddCube extends StatefulWidget {
  final Function(String, String, String, int) addCubeCallback;

  AddCube(this.addCubeCallback);

  @override
  _AddCubeState createState() => _AddCubeState();
}

class _AddCubeState extends State<AddCube> {
  String _cubeName;
  String _cubeMadeDate;
  String _cubeEndDate;
  int _cubeCount;

  @override
  void initState() {
    _cubeName = '';
    _cubeMadeDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _cubeEndDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _cubeCount = 0;
    addCubeBanner.load();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    addCubeBanner.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('큐브추가'),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              widget.addCubeCallback(
                  _cubeName, _cubeMadeDate, _cubeEndDate, _cubeCount);
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        child: AdWidget(ad: addCubeBanner),
        width: addCubeBanner.size.width.toDouble(),
        height: addCubeBanner.size.height.toDouble(),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              leading: Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: Text('이름')),
              title: TextField(
                controller: TextEditingController(text: _cubeName),
                onChanged: (String value) {
                  _cubeName = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              leading: Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: Text('수량')),
              title: TextField(
                controller: TextEditingController(text: _cubeCount.toString()),
                textAlign: TextAlign.left,
                onChanged: (String value) {
                  _cubeCount = num.tryParse(value);
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: Text('만든날짜')),
              title: TextField(
                controller: TextEditingController(text: _cubeMadeDate),
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
                      _cubeMadeDate = date.toString().substring(0, 10);
                    });
                  });
                },
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Container(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: Text('사용기한')),
              title: TextField(
                controller: TextEditingController(text: _cubeEndDate),
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
                      _cubeEndDate = date.toString().substring(0, 10);
                    });
                  });
                },
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}
