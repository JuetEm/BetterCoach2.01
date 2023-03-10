import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_project/app/ui/page/actionSelector.dart';
import 'package:web_project/app/data/provider/lesson_service.dart';
import 'package:web_project/app/ui/widget/centerConstraintBody.dart';
import 'package:web_project/app/data/model/userInfo.dart'
    as CustomUserInfo; // 다른 페키지와 클래스 명이 겹치는 경우 alias 선언해서 사용

import '../../data/model/actionInfo.dart';
import '../../data/provider/auth_service.dart';
import '../widget/baseTableCalendar.dart';
import '../../data/model/color.dart';
import '../../function/globalFunction.dart';
import '../widget/globalWidget.dart';
import 'memberInfo.dart';
import '../../data/model/lessonInfo.dart';

String now = DateFormat("yyyy-MM-dd").format(DateTime.now());

TextEditingController nameController = TextEditingController();
TextEditingController apratusNameController = TextEditingController();
TextEditingController actionNameController = TextEditingController();
TextEditingController lessonDateController = TextEditingController(text: now);
TextEditingController gradeController = TextEditingController(text: "50");
TextEditingController todayNoteController = TextEditingController();
TextEditingController totalNoteController = TextEditingController();

FocusNode lessonDateFocusNode = FocusNode();
FocusNode totalNoteFocusNode = FocusNode();

// 가변적으로 만들어지는 TextFields
var totalNoteControllers = [];

final lessonInfos = [];

List<String> deleteDocId = new List.empty(growable: true);

GlobalFunction globalFunction = GlobalFunction();

String selectedDropdown = '기구';
List<String> dropdownList = [
  'REFORMER',
  'CADILLAC',
  'CHAIR',
  'LADDER BARREL',
  'SPRING BOARD',
  'SPINE CORRECTOR',
  'MAT',
  'OTHERS',
];

double sliderValue = 50;

String editDocId = "";
String editApparatusName = "";
String editLessonDate = "";
String editGrade = "";
String editTotalNote = "";

bool initState = true;

List<TmpLessonInfo> tmpLessonInfoList = [];

class LessonUpdate extends StatefulWidget {
  const LessonUpdate({super.key});

  @override
  State<LessonUpdate> createState() => _LessonUpdateState();
}

class _LessonUpdateState extends State<LessonUpdate> {
  @override
  Widget build(BuildContext context) {
    // 이전 화면에서 보낸 변수 받기
    final argsList =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    CustomUserInfo.UserInfo customUserInfo = argsList[0];
    String lessonDate = argsList[1];
    List<DateTime> eventList = argsList[2];
    tmpLessonInfoList = argsList[3];

    if (initState) {
      print("INIT!!! : ${initState}");
      //now = DateFormat("yyyy-MM-dd").format(DateTime.now());

      gradeController = TextEditingController(text: "50");
      initState = !initState;
    }
    // if (initState) {
    //   print("INIT!!! : ${initState}");
    //   now = DateFormat("yyyy-MM-dd").format(DateTime.now());
    //   lessonDateController = TextEditingController(text: now);
    //   gradeController = TextEditingController(text: "50");
    //   initState = !initState;
    // }

    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;

    // // 이전 화면에서 보낸 변수 받기
    // final userInfo =
    //     ModalRoute.of(context)!.settings.arguments as CustomUserInfo.UserInfo;

    // nameController = TextEditingController(text: userInfo.name);
    // //lessonDateController = TextEditingController(text: now);
    // //gradeController = TextEditingController(text: "50");

    //초기값 넣어주기
    lessonDateController = TextEditingController(text: lessonDate);

    String todayNotedocId = "";
    bool ActionNullCheck = true;

    return Consumer<LessonService>(
      builder: (context, lessonService, child) {
        return Scaffold(
          backgroundColor: Palette.secondaryBackground,
          appBar: BaseAppBarMethod(context, "노트 보기", () {
            // 뒤로가기 선택시 MemberInfo로 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MemberInfo(),
                // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                settings: RouteSettings(
                  arguments: customUserInfo,
                ),
              ),
            );
            // 페이지 초기화
            initInpuWidget();
            initState = !initState;
          }, null, null),
          body: CenterConstrainedBody(
            child: SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    /// 입력창
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // // 기구 입력창
                          // BaseModalBottomSheetButton(
                          //   bottomModalController: apratusNameController,
                          //   hint: "기구",
                          //   showButton: true,
                          //   optionList: dropdownList,
                          //   customFunction: () {},
                          // ),

                          /// 수업일 입력창
                          BaseTextField(
                            customController: lessonDateController,
                            customFocusNode: lessonDateFocusNode,
                            hint: "수업일",
                            showArrow: true,
                            customFunction: () {
                              globalFunction.getDateFromCalendar(
                                  context,
                                  lessonDateController,
                                  "수업일",
                                  lessonDateController.text);
                            },
                          ),

                          /// 메모 입력창
                          FutureBuilder<QuerySnapshot>(
                            future: lessonService.readTodayNoteOflessonDate(
                              user.uid,
                              customUserInfo.docId,
                              lessonDateController.text,
                            ),
                            builder: (context, snapshot) {
                              final docsTodayNote =
                                  snapshot.data?.docs ?? []; // 문서들 가져오기

                              if (docsTodayNote.isEmpty) {
                                todayNoteController.text = "";
                                todayNotedocId = "";

                                return BaseTextField(
                                  customController: todayNoteController,
                                  customFocusNode: totalNoteFocusNode,
                                  hint: "일별 메모",
                                  showArrow: false,
                                  customFunction: () {},
                                );
                              } else {
                                todayNoteController.text =
                                    docsTodayNote[0].get('todayNote');
                                todayNotedocId = docsTodayNote[0].id;
                                return BaseTextField(
                                  customController: todayNoteController,
                                  customFocusNode: totalNoteFocusNode,
                                  hint: "일별 메모",
                                  showArrow: false,
                                  customFunction: () {},
                                );
                              }
                            },
                          ),

                          // 동작입력 버튼
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              color: Palette.buttonOrange,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 30.0,
                                right: 16.0,
                              ),
                              child: InkWell(
                                onTap: () async {
                                  String currentAppratus =
                                      apratusNameController.text;
                                  String lessonDate = lessonDateController.text;
                                  String totalNote = todayNoteController.text;

                                  bool initState = true;

                                  final ActionInfo? result =
                                      await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ActionSelector(),
                                      fullscreenDialog: true,
                                      // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                      settings: RouteSettings(arguments: [
                                        customUserInfo,
                                        currentAppratus,
                                        lessonDate,
                                        initState,
                                        totalNote,
                                        tmpLessonInfoList,
                                      ]),
                                    ),
                                  );

                                  if (!(result == null)) {
                                    print(
                                        "result.apparatus-result.position-result.actionName : ${result.apparatus}-${result.position}-${result.actionName}");

                                    setState(() {
                                      actionNameController.text =
                                          result.actionName;
                                      switch (result.apparatus) {
                                        case "RE":
                                          apratusNameController.text =
                                              "REFORMER";
                                          break;
                                        case "CA":
                                          apratusNameController.text =
                                              "CADILLAC";
                                          break;
                                        case "CH":
                                          apratusNameController.text = "CHAIR";
                                          break;
                                        case "LA":
                                          apratusNameController.text =
                                              "LADDER BARREL";
                                          break;
                                        case "SB":
                                          apratusNameController.text =
                                              "SPRING BOARD";
                                          break;
                                        case "SC":
                                          apratusNameController.text =
                                              "SPINE CORRECTOR";
                                          break;
                                        case "MAT":
                                          apratusNameController.text = "MAT";
                                          break;
                                        case "OT":
                                          apratusNameController.text = "OTHERS";
                                          break;
                                      }
                                    });
                                  }
                                },
                                child: SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '동작선택',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Palette.grayFA),
                                      ),
                                      Spacer(flex: 1),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Palette.grayFA,
                                        size: 12.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 5),

                          FutureBuilder<QuerySnapshot>(
                            future: lessonService.readNotesOflessonDate(
                              user.uid,
                              customUserInfo.docId,
                              lessonDateController.text,
                            ),
                            builder: (context, snapshot) {
                              final docs =
                                  snapshot.data?.docs ?? []; // 문서들 가져오기
                              if (docs.isEmpty) {
                                return Center(child: Text("동작을 추가해 주세요."));
                              }

                              //로딩바 활
                              if (snapshot.hasData) {
                                //Textfield 생성
                                createControllers(docs.length);

                                //reorderable 드래그시 그림자/디자인 조정
                                Widget proxyDecorator(Widget child, int index,
                                    Animation<double> animation) {
                                  return AnimatedBuilder(
                                    animation: animation,
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Material(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: child,
                                      );
                                    },
                                    child: child,
                                  );
                                }

                                deleteDocId = List<String>.filled(
                                    docs.length, "",
                                    growable: true);

                                return Container(
                                  //height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),

                                  child: Theme(
                                    data: ThemeData(
                                      canvasColor:
                                          Colors.transparent, //드래그시 투명하게 만들기 적용
                                    ),
                                    child: ReorderableListView.builder(
                                      proxyDecorator: proxyDecorator,
                                      itemCount: docs.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      //buildDefaultDragHandles: false,
                                      onReorder: ((oldIndex, newIndex) {
                                        if (newIndex > docs.length)
                                          newIndex = docs.length;
                                        if (oldIndex < newIndex) newIndex -= 1;
                                        docs.insert(
                                            newIndex, docs.removeAt(oldIndex));
                                        for (int pos = 0;
                                            pos < docs.length;
                                            pos++) {
                                          lessonService.updatePos(
                                              docs[pos].id, pos);
                                        }
                                        //setState(() {});
                                      }),

                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final doc = docs[index];
                                        //print(doc.id);

                                        deleteDocId[index] = doc.id;
                                        String uid = doc.get('uid'); // 강사 고유번호
                                        String name = doc.get('name'); //회원이름
                                        String phoneNumber = doc.get(
                                            'phoneNumber'); // 회원 고유번호 (전화번호로 회원 식별)
                                        String apratusName =
                                            doc.get('apratusName'); //기구이름
                                        String actionName =
                                            doc.get('actionName'); //동작이름
                                        String lessonDate =
                                            doc.get('lessonDate'); //수업날짜
                                        String grade = doc.get('grade'); //수행도
                                        String totalNote =
                                            doc.get('totalNote'); //수업총메모
                                        String lessonDateTrim = " ";
                                        String apratusNameTrim = " ";
                                        int pos = doc.get('pos'); //순서
                                        // 날짜 글자 자르기
                                        if (lessonDate.length > 0) {
                                          lessonDateTrim =
                                              lessonDate.substring(2, 10);
                                        }
                                        // 기구 첫두글자 자르기
                                        if (apratusName.length > 0) {
                                          apratusNameTrim =
                                              apratusName.substring(0, 2);
                                        }
                                        totalNoteControllers[index].text =
                                            totalNote; //동작별 노트 가져오기

                                        return Column(
                                          key: ValueKey(doc),

                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  //color: Colors.red.withOpacity(0),
                                                  margin: const EdgeInsets.only(
                                                    top: 5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10.0),
                                                    ),
                                                    color: Palette.grayEE,
                                                    //color: Colors.red.withOpacity(0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      //top: 5,
                                                      //bottom: 5,
                                                      left: 5.0,
                                                      right: 16.0,
                                                    ),
                                                    child: SizedBox(
                                                      height: 60,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .drag_indicator,
                                                            color:
                                                                Palette.gray33,
                                                            size: 20.0,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            apratusNameTrim,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1!
                                                                .copyWith(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            actionName,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1!
                                                                .copyWith(
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                          ),
                                                          Spacer(flex: 1),
                                                          IconButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    true,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        '삭제'),
                                                                    content: Text(
                                                                        '동작노트를 삭제하시겠습니까?'),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          lessonService
                                                                              .deleteSinglelesson(
                                                                            uid:
                                                                                uid,
                                                                            memberId:
                                                                                customUserInfo.docId,
                                                                            docId:
                                                                                doc.id,
                                                                            lessonDate:
                                                                                lessonDate,
                                                                            onSuccess:
                                                                                () {},
                                                                            onError:
                                                                                () {},
                                                                          );
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            '삭제'),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            '취소'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .remove_circle,
                                                              color: Palette
                                                                  .statusRed,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  //color: Colors.red.withOpacity(0),
                                                  margin: const EdgeInsets.only(
                                                    bottom: 5,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10.0),
                                                    ),
                                                    color: Colors.transparent,
                                                    //color: Colors.red.withOpacity(0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      //top: 5,
                                                      //bottom: 5,
                                                      left: 5.0,
                                                      right: 16.0,
                                                    ),
                                                    child: SizedBox(
                                                      height: 60,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          // Expanded(
                                                          //   child: TextField(
                                                          //     controller:
                                                          //         totalNoteControllers[
                                                          //             index],
                                                          //   ),
                                                          // ),

                                                          /// 메모 입력창
                                                          Expanded(
                                                            child:
                                                                DynamicSaveTextField(
                                                              customController:
                                                                  totalNoteControllers[
                                                                      index],
                                                              hint: "메모",
                                                              showArrow: false,
                                                              customFunction:
                                                                  () async {
                                                                await lessonService
                                                                    .update(
                                                                  doc.id,
                                                                  apratusName,
                                                                  actionName,
                                                                  lessonDate,
                                                                  "50",
                                                                  totalNoteControllers[
                                                                          index]
                                                                      .text,
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          //Spacer(flex: 1),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],

                                          // return ListTile(
                                          //   key: ValueKey(doc),
                                          //   title: Text(actionName),
                                          // leading: Icon(
                                          //   Icons.arrow_forward_ios,
                                          //   color: Palette.gray99,
                                          //   size: 12.0,
                                          // ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),

                          // /// 동작이름 입력창
                          // BaseTextField(
                          //   customController: actionNameController,
                          //   hint: "동작선택",
                          //   showArrow: true,
                          //   customFunction: () async {
                          //     String currentAppratus = apratusNameController.text;
                          //     bool initState = true;

                          //     final ActionInfo? result = await Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => ActionSelector(),
                          //         fullscreenDialog: true,
                          //         // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                          //         settings: RouteSettings(arguments: [
                          //           userInfo,
                          //           currentAppratus,
                          //           initState
                          //         ]),
                          //       ),
                          //     );

                          //     if (!(result == null)) {
                          //       print(
                          //           "result.apparatus-result.position-result.actionName : ${result.apparatus}-${result.position}-${result.actionName}");

                          //       setState(() {
                          //         actionNameController.text = result.actionName;
                          //         switch (result.apparatus) {
                          //           case "RE":
                          //             apratusNameController.text = "REFORMER";
                          //             break;
                          //           case "CA":
                          //             apratusNameController.text = "CADILLAC";
                          //             break;
                          //           case "CH":
                          //             apratusNameController.text = "CHAIR";
                          //             break;
                          //           case "LA":
                          //             apratusNameController.text =
                          //                 "LADDER BARREL";
                          //             break;
                          //           case "SB":
                          //             apratusNameController.text = "SPRING BOARD";
                          //             break;
                          //           case "SC":
                          //             apratusNameController.text =
                          //                 "SPINE CORRECTOR";
                          //             break;
                          //           case "MAT":
                          //             apratusNameController.text = "MAT";
                          //             break;
                          //         }
                          //       });
                          //     }
                          //   },
                          // ),

                          // /// 수행도 입력창
                          // BaseTextField(
                          //   customController: gradeController,
                          //   hint: "수행도",
                          //   showArrow: true,
                          //   customFunction: () {},
                          // ),

                          // Container(
                          //   // color: Colors.red,
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     children: [
                          //       Slider(
                          //           value: sliderValue,
                          //           min: 0,
                          //           max: 100,
                          //           divisions: 10,
                          //           onChanged: (value) {
                          //             setState(() {
                          //               sliderValue = value;
                          //               gradeController.text =
                          //                   sliderValue.clamp(0, 100).toString();
                          //               print(sliderValue.toString());
                          //             });
                          //           }),
                          //     ],
                          //   ),
                          // ),

                          // /// 메모 입력창
                          // BaseTextField(
                          //   customController: totalNoteController,
                          //   hint: "메모",
                          //   showArrow: false,
                          //   customFunction: () {},
                          // ),

                          const SizedBox(height: 15),

                          /// 추가 버튼
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Palette.buttonOrange,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child:
                                  Text("저장하기", style: TextStyle(fontSize: 18)),
                            ),
                            onPressed: () {
                              print("저장하기 버튼");

                              // create bucket
                              if (globalFunction.textNullCheck(
                                      context, lessonDateController, "수업일") &&
                                  ActionNullCheck == false) {
                                print(
                                    "userInfo.docId : ${customUserInfo.docId}");

                                if (todayNotedocId == "") {
                                  lessonService.createTodaynote(
                                      docId: customUserInfo.docId,
                                      uid: user.uid,
                                      name: customUserInfo.name,
                                      lessonDate: lessonDateController.text,
                                      todayNote: todayNoteController.text,
                                      isRefresh: true,
                                      onSuccess: () {
                                        // 저장하기 성공
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("저장하기 성공"),
                                        ));
                                        // 저장하기 성공시 MemberInfo로 이동
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MemberInfo(),
                                            // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                            settings: RouteSettings(
                                              arguments: customUserInfo,
                                            ),
                                          ),
                                        );

                                        // 화면 초기화
                                        initInpuWidget();
                                        initState = !initState;
                                      },
                                      onError: () {
                                        print("저장하기 ERROR");
                                      });
                                } else {
                                  lessonService.updateTodayNote(
                                      docId: todayNotedocId,
                                      todayNote: todayNoteController.text,
                                      onSuccess: () {
                                        // 저장하기 성공
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("저장하기 성공"),
                                        ));
                                        // 저장하기 성공시 MemberInfo로 이동
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MemberInfo(),
                                            // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                            settings: RouteSettings(
                                              arguments: customUserInfo,
                                            ),
                                          ),
                                        );

                                        // 화면 초기화
                                        initInpuWidget();
                                        initState = !initState;
                                      },
                                      onError: () {
                                        print("저장하기 ERROR");
                                      });
                                }

                                // // 오늘 날짜 가져오기
                                // lessonService.create(
                                //     docId: userInfo
                                //         .docId, // 회권 고유번호 => 회원번호(문서고유번호)로 회원 식별
                                //     uid: user.uid,
                                //     name: nameController.text,
                                //     phoneNumber: userInfo
                                //         .phoneNumber, // 회권 고유번호 => 전화번호로 회원 식별 방식 제거
                                //     apratusName:
                                //         apratusNameController.text, //기구이름
                                //     actionName: actionNameController.text, //동작이름
                                //     lessonDate: lessonDateController.text, //수업날짜
                                //     grade: gradeController.text, //수행도
                                //     totalNote: totalNoteController.text, //수업총메모
                                //     onSuccess: () {
                                //       // 저장하기 성공
                                //       ScaffoldMessenger.of(context)
                                //           .showSnackBar(SnackBar(
                                //         content: Text("저장하기 성공"),
                                //       ));
                                //       // 저장하기 성공시 MemberInfo로 이동
                                //       Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //           builder: (context) => MemberInfo(),
                                //           // setting에서 arguments로 다음 화면에 회원 정보 넘기기
                                //           settings: RouteSettings(
                                //             arguments: userInfo,
                                //           ),
                                //         ),
                                //       );

                                //       // 화면 초기화
                                //       initInpuWidget();
                                //       initState = !initState;
                                //     },
                                //     onError: () {
                                //       print("저장하기 ERROR");
                                //     });
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("항목을 모두 입력해주세요."),
                                ));
                              }
                            },
                          ),

                          SizedBox(height: 20),

                          DeleteButton(
                              customUserInfo: customUserInfo,
                              lessonService: lessonService),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //bottomNavigationBar: BaseBottomAppBar(),
        );
      },
    );
  }

  void initInpuWidget() {
    globalFunction.clearTextEditController([
      nameController,
      apratusNameController,
      actionNameController,
      lessonDateController,
      gradeController,
      totalNoteController
    ]);
    lessonDateController.text = now;
    setState(() {
      sliderValue = 50;
    });
  }

  //Textfield 생성
  void createControllers(length) {
    totalNoteControllers = [];
    for (var i = 0; i < length; i++) {
      totalNoteControllers.add(TextEditingController());
    }
  }
}

// 삭제버튼

class DeleteButton extends StatefulWidget {
  const DeleteButton({
    Key? key,
    required this.customUserInfo,
    required this.lessonService,
  }) : super(key: key);

  final CustomUserInfo.UserInfo customUserInfo;
  final LessonService lessonService;

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Palette.mainBackground,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("삭제하기",
            style: TextStyle(fontSize: 18, color: Palette.textRed)),
      ),
      onPressed: () async {
        // create bucket
        final retvaldelte =
            await showAlertDialog(context, '정말로 삭제하시겠습니까?', '레슨노트를 삭제합니다.');
        if (retvaldelte == "OK") {
          widget.lessonService.deleteTodayNote(
            docId: widget.customUserInfo.docId,
            onSuccess: () {},
            onError: () {},
          );
          for (int idx = 0; idx < deleteDocId.length; idx++) {
            //print(deleteDocId[idx]);
            widget.lessonService.deleteMultilesson(
              docId: deleteDocId[idx],
              onSuccess: () {},
              onError: () {},
            );
          }

          // 삭제하기 성공시 MemberList로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemberInfo(),
              // setting에서 arguments로 다음 화면에 회원 정보 넘기기
              settings: RouteSettings(
                arguments: widget.customUserInfo,
              ),
            ),
          );
        }

        //if (showAlertDialog(context) == "OK"){
        //
      },
    );
  }
}
