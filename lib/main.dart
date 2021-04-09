import 'dart:convert';

import 'package:baby_diary/add_calendar.dart';
import 'package:baby_diary/baby_profile.dart';
import 'package:baby_diary/bannerAd.dart';
import 'package:baby_diary/cube_check.dart';
import 'package:baby_diary/edit_calendar.dart';
import 'package:baby_diary/model/food_db_helper.dart';
import 'package:baby_diary/model/profile_db_helper.dart';
import 'package:baby_diary/model/profile_list.dart';
import 'package:baby_diary/widget/color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xFFFFFFFF),
          scaffoldBackgroundColor: Color(0xFFFFFFFF),
          fontFamily: 'NotoSansKR',
          textTheme: TextTheme(
              bodyText2: TextStyle(color: Colors.black87, fontSize: 15.0))),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        // if it's a RTL language
      ],
      supportedLocales: [
        const Locale('ko', 'KR'),
        // include country code too
      ],
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Food> foodList = <Food>[];
  List<Profile> profileList = <Profile>[];
  String _babyNameUpdate;
  String _babyBirthUpdate;
  String _babyImageUpdate;

  @override
  void initState() {
    FoodDBHelper().getAllFoods().then((value) {
      setState(() {
        foodList = value;
      });
    });
    ProfileDBHelper().getAllProfiles().then((value) {
      setState(() {
        profileList = value;
      });
    });
    mainBanner.load();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    mainBanner.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (profileList.isEmpty == false) {
      _babyNameUpdate = profileList[0].babyName;
      _babyImageUpdate = profileList[0].babyImage;
      _babyBirthUpdate = profileList[0].babyBirth;
    } else {
      _babyNameUpdate = '아기이름';
      _babyImageUpdate = null;
      _babyBirthUpdate = DateTime.now().toString().substring(0, 10);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('식단표'),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddCalendar((_subject,
                              _startDate,
                              _endDate,
                              _mainColor,
                              _dropDownValue,
                              _subjectCount,
                              _memo) {
                            setState(() {
                              Food food = Food(
                                  eventName: _subject,
                                  fromDate: _startDate,
                                  toDate: _endDate,
                                  background: _mainColor,
                                  note: _dropDownValue,
                                  eventCount: _subjectCount,
                                  memo: _memo);
                              FoodDBHelper().createFoodData(food);
                              FoodDBHelper()
                                  .getAllFoods()
                                  .then((value) => setState(() {
                                        foodList = value;
                                      }));
                              MeetingDataSource(foodList)
                                  .appointments
                                  .add(food);
                              MeetingDataSource(foodList).notifyListeners(
                                  CalendarDataSourceAction.add, foodList);
                            });
                            MeetingDataSource(foodList).appointments.isEmpty
                                ? print('empty')
                                : Navigator.pop(context);
                          })));
            },
          ),
        ],
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: Drawer(
            child: ListView(
          children: [
            DrawerHeader(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 5.0),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BabyProfile(
                                    _babyNameUpdate,
                                    _babyBirthUpdate,
                                    _babyImageUpdate)));
                        setState(() {
                          ProfileDBHelper().deleteAllProfile();
                          ProfileDBHelper().createProfileData(result);
                          ProfileDBHelper()
                              .getAllProfiles()
                              .then((value) => setState(() {
                                    profileList = value;
                                  }));
                          _babyNameUpdate = profileList[0].babyName;
                          _babyImageUpdate = profileList[0].babyImage;
                          _babyBirthUpdate = profileList[0].babyBirth;
                          mainBanner.dispose();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainPage()));
                        });
                      },
                      child: CircleAvatar(
                        backgroundImage: _babyImageUpdate != null
                            ? MemoryImage(base64.decode(_babyImageUpdate))
                            : AssetImage('images/photo_12345.png'),
                        backgroundColor: Colors.white,
                        radius: 40.0,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(_babyNameUpdate,
                        style: TextStyle(color: Colors.grey.shade600)),
                    Text(
                        'D+${DateTime.now().difference(DateTime.parse(_babyBirthUpdate)).inDays + 1}',
                        style: TextStyle(color: Colors.grey.shade600))
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.calendar_today_rounded,
                color: Colors.grey.shade800,
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFFFE8189)),
              title: Text(
                '식단표',
                style: TextStyle(fontSize: 15.0),
              ),
              onTap: () {
                mainBanner.dispose();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainPage()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.border_all,
                color: Colors.grey.shade800,
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFFFE8189)),
              title: Text(
                '큐브관리',
                style: TextStyle(fontSize: 15.0),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CubeCheck()));
              },
            ),
          ],
        )),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        todayHighlightColor: Color(0xFFFE8189),
        headerHeight: 50,
        headerStyle: CalendarHeaderStyle(textAlign: TextAlign.center),
        appointmentTextStyle: TextStyle(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
        dataSource: getMeetingDetails(),
        onTap: calendarTapped,
        monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          numberOfWeeksInView: 4,
        ),
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        child: AdWidget(ad: mainBanner),
        width: mainBanner.size.width.toDouble(),
        height: mainBanner.size.height.toDouble(),
      ),
    );
  }

  MeetingDataSource getMeetingDetails() {
    return MeetingDataSource(foodList);
  }

  // TODO : 오류1. onTap 하면 EditCalendar 로 이동되어야 하나 이동이 잘 안됨
  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      setState(() {
        List<Food> tappedFoodList = calendarTapDetails.appointments.cast();
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                color: Color(0xff757575),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.all(2),
                    itemCount: tappedFoodList?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          padding: EdgeInsets.all(2),
                          height: 50,
                          child: ListTile(
                            leading: Icon(Icons.label,
                                color:
                                    colors[tappedFoodList[index].background]),
                            title: Text('${tappedFoodList[index].eventName}'),
                            subtitle: Text('${tappedFoodList[index].fromDate} '
                                '~ ${tappedFoodList[index].toDate}'),
                            trailing: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text('삭제하시겠습니까?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                FoodDBHelper().deleteFood(
                                                    tappedFoodList[index].id);
                                                FoodDBHelper()
                                                    .getAllFoods()
                                                    .then(
                                                        (value) => setState(() {
                                                              foodList = value;
                                                            }));
                                                MeetingDataSource(foodList)
                                                    .notifyListeners(
                                                        CalendarDataSourceAction
                                                            .remove,
                                                        foodList);
                                                mainBanner.dispose();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MainPage()));
                                              });
                                            },
                                            child: Text('네')),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('아니오'),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            onTap: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditCalendar(
                                          tappedFoodList[index].id,
                                          tappedFoodList[index].eventName,
                                          tappedFoodList[index].fromDate,
                                          tappedFoodList[index].toDate,
                                          tappedFoodList[index].background,
                                          tappedFoodList[index].note,
                                          tappedFoodList[index].eventCount,
                                          tappedFoodList[index].memo)));
                              setState(() {
                                FoodDBHelper().updateFood(result);
                                MeetingDataSource(foodList).notifyListeners(
                                    CalendarDataSourceAction.remove, foodList);
                                MeetingDataSource(foodList).notifyListeners(
                                    CalendarDataSourceAction.add, foodList);
                                FoodDBHelper()
                                    .getAllFoods()
                                    .then((value) => setState(() {
                                          foodList = value;
                                        }));
                                mainBanner.dispose();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainPage()));
                              });
                            },
                          ));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(height: 5, color: Colors.white),
                  ),
                ),
              );
            });
      });
    }
  }
}

class Food {
  final int id;
  final String eventName;
  final String fromDate;
  final String toDate;
  final int background;
  final String note;
  final int eventCount;
  final String memo;

  Food(
      {this.id,
      this.eventName,
      this.fromDate,
      this.toDate,
      this.background,
      this.note,
      this.eventCount,
      this.memo});

  factory Food.fromJson(Map<String, dynamic> json) => Food(
      id: json['id'],
      eventName: json['eventName'],
      fromDate: json['fromDate'],
      toDate: json['toDate'],
      background: json['background'],
      note: json['note'] == null ? null : json['note'] as String,
      eventCount: json['eventCount'],
      memo: json['memo'] == null ? null : json['memo'] as String);

  Map<String, dynamic> toJson() => {
        "id": id,
        "eventName": eventName,
        "fromDate": fromDate,
        "toDate": toDate,
        "background": background,
        "note": note == null ? null : note,
        "eventCount": eventCount,
        "memo": memo == null ? null : memo
      };
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Food> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return DateTime.parse(appointments[index].fromDate);
  }

  @override
  DateTime getEndTime(int index) {
    return DateTime.parse(appointments[index].toDate);
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return colors[appointments[index].background];
  }

  @override
  String getNotes(int index) {
    return appointments[index].note;
  }

  @override
  int getCounts(int index) {
    return appointments[index].eventCount;
  }

  @override
  String getMemos(int index) {
    return appointments[index].memo;
  }
}
