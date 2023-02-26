import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_project/app/data/provider/member_service.dart';
import 'package:web_project/app/ui/memberInfo.dart';
import 'package:web_project/color.dart';
import 'package:web_project/userInfo.dart';

import 'auth_service.dart'; // Firebase Auth
import 'centerConstraintBody.dart'; // 가운데로 제한시켜주는 클래스
import 'globalWidget.dart'; // 글로벌하게 쓰이는 위젯들
import 'main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[
    900,
    800,
    700,
    600,
    500,
    400,
    300,
    200,
    100
  ];

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    return Consumer<MemberService>(
      builder: (context, memberService, child) {
        return SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text("투데이"),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {},
                icon: Icon(Icons.calendar_month),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    print('profile');
                    // 로그인 페이지로 이동
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(
                                analytics: MyApp.analytics,
                              )),
                    );
                  },
                  icon: Icon(Icons.account_circle),
                ),
                IconButton(
                  onPressed: () {
                    _openEndDrawer();
                  },
                  icon: Icon(Icons.menu),
                ),
              ],
            ),
            endDrawer: Container(
              child: Drawer(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('This is the Drawer'),
                      ElevatedButton(
                        onPressed: () {
                          _closeEndDrawer();
                        },
                        child: const Text('Close Drawer'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // 로그아웃
                          context.read<AuthService>().signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => LoginPage(
                                      analytics: MyApp.analytics,
                                    )),
                          );
                        },
                        child: const Text('Log Out'),
                      )
                    ],
                  ),
                ),
              ),
            ),
            body: CenterConstrainedBody(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: FutureBuilder<QuerySnapshot>(
                      future: memberService.read(user.uid, 'name'),
                      builder: (context, snapshot) {
                        final docs = snapshot.data?.docs ?? []; // 문서들 가져오기
                        if (docs.isEmpty) {
                          return Center(child: Text("수업을 준비 중입니다."));
                        } else if (docs.isNotEmpty) {
                          return ListView.separated(
                            itemCount: docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              final doc = docs[index];
                              String name = doc.get('name');
                              String registerDate = doc.get('registerDate');
                              String phoneNumber = doc.get('phoneNumber');
                              String registerType = doc.get('registerType');
                              String goal = doc.get('goal');
                              String info = doc.get('info');
                              String note = doc.get('note');
                              bool isActive = doc.get('isActive');
                              bool isFavorite = doc.get('isFavorite') ?? false;
                              int memberDayLessonCount =
                                  doc.get('memberDayLessonCount');
                              return InkWell(
                                onTap: () {
                                  //memberService.update(doc.id, !isActive);
                                },
                                child: BaseContainer(
                                  docId: doc.id,
                                  name: name,
                                  registerDate: registerDate,
                                  goal: goal,
                                  info: info,
                                  note: note,
                                  phoneNumber: phoneNumber,
                                  isActive: isActive,
                                  isFavorite: isFavorite,
                                  memberService: memberService,
                                  resultMemberList: globalVariables.resultList,
                                  memberDayLessonCount: memberDayLessonCount,

                                  /// 멤버 카드 버튼 클릭 시 함수
                                  customFunctionOnTap: () async {
                                    // 회원 카드 선택시 MemberInfo로 이동

                                    // resultList.add(resultActionList);
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MemberInfo.getUserInfoAndActionList(
                                                userInfo,
                                                globalVariables.resultList,
                                                globalVariables.actionList),
                                        // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                        /* settings: RouteSettings(
                                            arguments: userInfo
                                          ), */
                                      ),
                                    ).then((result) {
                                      globalVariables.sortList();
                                      print(
                                          "MemberList : userInfo.bodyAnalyzed : ${userInfo.selectedBodyAnalyzed}");
                                      UserInfo tmpUserInfo = result;
                                      print(
                                          "MemberList : tmpUserInfo.bodyAnalyzed : ${tmpUserInfo.selectedBodyAnalyzed}");
                                      setState(() {
                                        print(
                                            "memberList - memberinfo pop setState!!");
                                      });
                                    });
                                  },

                                  /// 노트 추가 버튼 클릭 시 함수
                                  noteAddFunctionOnTap: () {},
                                ),
                              );
                            },
                            separatorBuilder: ((context, index) => Divider()),
                          );
                        } else {
                          return CircularProgressIndicator(
                            color: Palette.buttonOrange,
                          );
                        }
                      }),
                ),
              ),
            ),
            bottomNavigationBar: BaseBottomAppBar(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                print('floating button');
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}
