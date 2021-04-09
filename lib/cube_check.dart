import 'package:baby_diary/add_cube.dart';
import 'package:baby_diary/bannerAd.dart';
import 'package:baby_diary/edit_cube.dart';
import 'package:baby_diary/model/cube_db_helper.dart';
import 'package:baby_diary/model/cube_list.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CubeCheck extends StatefulWidget {
  @override
  _CubeCheckState createState() => _CubeCheckState();
}

class _CubeCheckState extends State<CubeCheck> {
  List<Cube> cubeDetails = <Cube>[];
  TextEditingController searchController = TextEditingController();
  String searchString = "";

  @override
  void initState() {
    super.initState();

    CubeDBHelper().getAllCubes();
    cubeCheckBanner.load();
  }

  @override
  void dispose() {
    cubeCheckBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('큐브관리'),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddCube((_cubeName, _cubeMadeDate,
                              _cubeEndDate, _cubeCount) {
                            setState(() {
                              Cube cube = Cube(
                                  cubeName: _cubeName,
                                  cubeMadeDate: _cubeMadeDate,
                                  cubeEndDate: _cubeEndDate,
                                  cubeCount: _cubeCount);
                              CubeDBHelper().createData(cube);
                              CubeDBHelper().getAllCubes();
                            });
                            Navigator.pop(context);
                          })));
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        child: AdWidget(ad: cubeCheckBanner),
        width: cubeCheckBanner.size.width.toDouble(),
        height: cubeCheckBanner.size.height.toDouble(),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: FutureBuilder(
            future: CubeDBHelper().getAllCubes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchString = value;
                            });
                          },
                          controller: searchController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFFFE8189),
                            ),
                            hintText: '큐브 이름 검색',
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                borderSide: BorderSide(width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                borderSide: BorderSide(width: 1.0)),
                          ),
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              var item = snapshot.data[index];
                              return item.cubeName.contains(searchString)
                                  ? _cubeListItem(item)
                                  : Container();
                            }),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  //ToDO : 오류4. 큐브관리 화면에 저장된 리스트가 뜨지 않음
  Widget _cubeListItem(Cube cube) {
    return Container(
        child: ListTile(
      leading: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        child: Text(
          '${cube.cubeName}',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
        ),
      ),
      title: Text('사용기한: ${cube.cubeEndDate}',
          style: TextStyle(fontSize: 15, color: Colors.grey.shade800)),
      subtitle: Text(
        '수량: ${cube.cubeCount}개',
        style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
      ),
      onTap: () async {
        final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditCube(cube.cubeName, cube.cubeMadeDate,
                    cube.cubeEndDate, cube.cubeCount)));
        setState(() {
          CubeDBHelper().deleteCube(cube.id);
          // MeetingDataSource(foodList).appointments.removeAt(index);
          CubeDBHelper().createData(result);
        });
      },
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
                        CubeDBHelper().deleteCube(cube.id);
                        setState(() {});
                        Navigator.pop(context);
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
    ));
  }
}
