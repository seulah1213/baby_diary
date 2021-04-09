import 'package:baby_diary/model/cube_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'bannerAd.dart';

class EditCube extends StatefulWidget {
  EditCube(this.cubeName, this.cubeMadeDate, this.cubeEndDate, this.cubeCount);

  final String cubeName;
  final String cubeMadeDate;
  final String cubeEndDate;
  final int cubeCount;

  @override
  _EditCubeState createState() => _EditCubeState();
}

class _EditCubeState extends State<EditCube> {
  String _cubeName;
  String _cubeMadeDate;
  String _cubeEndDate;
  int _cubeCount;

  @override
  void initState() {
    _cubeName = widget.cubeName;
    _cubeMadeDate = widget.cubeMadeDate;
    _cubeEndDate = widget.cubeEndDate;
    _cubeCount = widget.cubeCount;
    editCubeBanner.load();
    super.initState();
  }

  @override
  void dispose() {
    editCubeBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('큐브편집'),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Cube returnCube = Cube(
                cubeName: widget.cubeName,
                cubeMadeDate: widget.cubeMadeDate,
                cubeEndDate: widget.cubeEndDate,
                cubeCount: widget.cubeCount);
            Navigator.pop(context, returnCube);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Cube returnCube = Cube(
                  cubeName: _cubeName,
                  cubeMadeDate: _cubeMadeDate,
                  cubeEndDate: _cubeEndDate,
                  cubeCount: _cubeCount);
              Navigator.pop(context, returnCube);
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        child: AdWidget(ad: editCubeBanner),
        width: editCubeBanner.size.width.toDouble(),
        height: editCubeBanner.size.height.toDouble(),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Container(
          color: Colors.white,
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
                  controller:
                      TextEditingController(text: _cubeCount.toString()),
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
      ),
    );
  }
}
