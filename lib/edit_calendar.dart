import 'package:baby_diary/bannerAd.dart';
import 'package:baby_diary/main.dart';
import 'package:baby_diary/widget/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class EditCalendar extends StatefulWidget {
  EditCalendar(this.id, this.subject, this.startDate, this.endDate,
      this.mainColor, this.note, this.subjectCount, this.memo);

  final int id;
  final String subject;
  final String startDate;
  final String endDate;
  final int mainColor;
  final String note;
  final int subjectCount;
  final String memo;

  @override
  _EditCalendarState createState() => _EditCalendarState();
}

class _EditCalendarState extends State<EditCalendar> {
  int _id;
  String _subject;
  String _startDate;
  String _endDate;
  int _mainColor;
  String _dropDownValue;
  int _subjectCount;
  String _memo;

  @override
  void initState() {
    _id = widget.id;
    _subject = widget.subject;
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    _mainColor = widget.mainColor;
    _dropDownValue = widget.note;
    _subjectCount = widget.subjectCount;
    _memo = widget.memo;
    editCalendarBanner.load();
    print(_id);
    super.initState();
  }

  @override
  void dispose() {
    editCalendarBanner.dispose();
    super.dispose();
  }

  @override

  // TODO : 오류2. 앱바 아이콘 클릭시 Navigator.pop 으로 메인페이지로 이동되는데, 기존 저장되어있는 식단들이 사라짐
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이유식 편집'),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Food backFood = Food(
                id: widget.id,
                eventName: widget.subject,
                fromDate: widget.startDate,
                toDate: widget.endDate,
                background: widget.mainColor,
                note: widget.note,
                eventCount: widget.subjectCount,
                memo: widget.memo);
            Navigator.pop(context, backFood);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Food returnFood = Food(
                  id: _id,
                  eventName: _subject,
                  fromDate: _startDate,
                  toDate: _endDate,
                  background: _mainColor,
                  note: _dropDownValue,
                  eventCount: _subjectCount,
                  memo: _memo);
              Navigator.pop(context, returnFood);
            },
          )
        ],
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        child: AdWidget(ad: editCalendarBanner),
        width: editCalendarBanner.size.width.toDouble(),
        height: editCalendarBanner.size.height.toDouble(),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Stack(
          children: [getCalendarEditor(context)],
        ),
      ),
    );
  }

  Widget getCalendarEditor(BuildContext context) {
    return Container(
      color: Colors.white,
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
            leading: const Text(''),
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
    );
  }
}
