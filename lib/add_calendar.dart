import 'package:baby_diary/bannerAd.dart';
import 'package:baby_diary/widget/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AddCalendar extends StatefulWidget {
  final Function(String, String, String, int, String, int, String)
      addCalendarCallback;

  AddCalendar(this.addCalendarCallback);

  @override
  _AddCalendarState createState() => _AddCalendarState();
}

class _AddCalendarState extends State<AddCalendar> {
  String _subject;
  String _startDate;
  String _endDate;
  int _mainColor;
  String _dropDownValue = '초기';
  int _subjectCount;
  String _memo;

  @override
  void initState() {
    _subject = '';
    _startDate = DateTime.now().toString().substring(0, 10);
    _endDate = DateTime.now().toString().substring(0, 10);
    _subjectCount = 0;
    _mainColor = 1;
    _memo = '';
    addCalendarBanner.load();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    addCalendarBanner.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이유식 추가'),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              widget.addCalendarCallback(_subject, _startDate, _endDate,
                  _mainColor, _dropDownValue, _subjectCount, _memo);
            },
          )
        ],
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        child: AdWidget(ad: addCalendarBanner),
        width: addCalendarBanner.size.width.toDouble(),
        height: addCalendarBanner.size.height.toDouble(),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            ColorPicker(
              selectedIndex: _mainColor,
              onTap: (index) {
                setState(() {
                  _mainColor = index;
                });
                _mainColor = index;
              },
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                    leading: Icon(Icons.create),
                    title: TextField(
                      controller: TextEditingController(text: _subject),
                      onChanged: (String value) {
                        _subject = value;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '이유식 이름',
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                    title: TextField(
                      controller:
                          TextEditingController(text: _subjectCount.toString()),
                      textAlign: TextAlign.right,
                      onChanged: (String value) {
                        _subjectCount = num.tryParse(value);
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
                    trailing: Text(
                      'g',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(Icons.calendar_today_rounded),
              title: TextField(
                controller: TextEditingController(text: _startDate),
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
                      _startDate = date.toString().substring(0, 10);
                    });
                  });
                },
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(Icons.trending_flat),
              title: TextField(
                controller: TextEditingController(text: _endDate),
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
                      _endDate = date.toString().substring(0, 10);
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
              leading: Icon(Icons.clear_all),
              title: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: _dropDownValue,
                  icon: Icon(Icons.keyboard_arrow_down),
                  onChanged: (String newValue) {
                    setState(() {
                      _dropDownValue = newValue;
                    });
                  },
                  items: ['초기', '중기', '후기', '미설정']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(Icons.error_outline),
              title: TextField(
                controller: TextEditingController(text: _memo),
                onChanged: (String value) {
                  _memo = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '메모',
                ),
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
