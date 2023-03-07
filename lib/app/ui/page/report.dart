import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_project/app/data/provider/report_service.dart';
import 'package:web_project/app/data/provider/auth_service.dart';
import 'package:web_project/app/ui/widget/centerConstraintBody.dart';
import 'package:web_project/app/data/model/color.dart';
import 'package:web_project/main.dart';

// BBZKGmz56W-GOXCUlzkRuupvFLEOZcvJpt3NCmst0ZibT8SFS-5Q4X3jxUEac3D726CV_i4mW6kCE0ldyBUykHM

String pageName = "리포트 페이지";

var fcmToken = null;

late FocusNode pageFocusNode;
late SingleValueDropDownController reportPageController;

String selectedPageName = "";
String content = "";

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  bool pageOffstage = true;

  TextEditingController pageName = TextEditingController();
  TextEditingController errorContents = TextEditingController();

  /* 회원목록/회원관리/노트편집/회원정보 수정/
회원등록/노트추가/동작선택/동작추가 */
  final pages = [
    DropDownValueModel(
        name: "OTHERS",
        value: 'others',
        toolTipMsg: "선택하려는 페이지가 없는 경우 선택해주세요."),
    DropDownValueModel(name: "회원목록", value: '회원목록', toolTipMsg: "회원목록"),
    DropDownValueModel(name: "회원관리", value: '회원관리', toolTipMsg: "회원관리"),
    DropDownValueModel(name: "노트편집", value: '노트편집', toolTipMsg: "노트편집"),
    DropDownValueModel(name: "회원정보수정", value: '회원정보수정', toolTipMsg: "회원정보수정"),
    DropDownValueModel(name: "회원등록", value: '회원등록', toolTipMsg: "회원등록"),
    DropDownValueModel(name: "노트추가", value: '노트추가', toolTipMsg: "노트추가"),
    DropDownValueModel(name: "동작선택", value: '동작선택', toolTipMsg: "동작선택"),
    DropDownValueModel(name: "동작추가", value: '동작추가', toolTipMsg: "동작추가"),
    DropDownValueModel(name: "회원등록", value: '회원등록', toolTipMsg: "회원등록"),
    DropDownValueModel(
        name: "시퀀스 라이브러리", value: '시퀀스 라이브러리', toolTipMsg: "시퀀스 라이브러리"),
    DropDownValueModel(
        name: "시퀀스 불러오기", value: '시퀀스 불러오기', toolTipMsg: "시퀀스 불러오기"),
    DropDownValueModel(name: "수강권추가", value: '수강권추가', toolTipMsg: "수강권추가"),
    DropDownValueModel(name: "수강권관리", value: '수강권관리', toolTipMsg: "수강권관리"),
    DropDownValueModel(
        name: "수강권 보관함", value: '수강권 보관함', toolTipMsg: "수강권 보관함"),
    DropDownValueModel(
        name: "로그인/회원가입", value: '로그인/회원가입', toolTipMsg: "로그인/회원가입"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    analyticLog.sendAnalyticsEvent(
        screenName, "리포트_이벤트_init", "init 테스트 스트링", "init 테스트 파라미터");

    reportPageController = SingleValueDropDownController();

    pageFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    reportPageController.dispose();

    pageFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Palette.gray66),
        leading: IconButton(
          onPressed: () {
            print('back');
            // 로그인 페이지로 이동
            Navigator.pop(context);
          },
          color: Palette.gray33,
          // icon: Icon(Icons.account_circle),
          icon: Icon(Icons.arrow_back),
        ),
        elevation: 0,
        backgroundColor: Palette.mainBackground,
        title: Text(
          "오류 및 개선요청",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Palette.gray00,
              ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: errorContents.text == ""
                  ? null
                  : () {
                      content = errorContents.text;
                      AuthService authService = AuthService();
                      var user = authService.currentUser();
                      ReportService reportService = ReportService();
                      reportService
                          .create(
                              user!.uid,
                              user.displayName,
                              user.phoneNumber,
                              user.email,
                              selectedPageName,
                              content,
                              DateTime.now(),
                              'N',
                              null)
                          .then((value) {
                        Navigator.pop(context);
                      });
                    },
              child: Text(
                '보내기',
                style: TextStyle(
                  fontSize: 16,
                  color: errorContents.text == ""
                      ? Palette.gray99
                      : Palette.textBlue,
                ),
              )),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: CenterConstrainedBody(
        child: SafeArea(
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
            color: Palette.secondaryBackground,
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: 10),
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Text('문제 페이지',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Palette.gray00,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: DropDownTextField(
                      controller: reportPageController,
                      isEnabled: true,
                      clearOption: false,
                      enableSearch: true,
                      // textFieldFocusNode: textFieldFocusNode,
                      // searchFocusNode: searchFocusNode,
                      clearIconProperty:
                          IconProperty(color: Palette.buttonOrange),
                      textFieldDecoration: InputDecoration(
                        hintText: "선택하세요.",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.all(20),
                        fillColor: Colors.white,
                      ),
                      searchDecoration: InputDecoration(
                        hintText: "검색하고 싶은 페이지를 입력하세요",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.all(16),
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        print("position validator value : ${value}");
                        if (value == null) {
                          return "required field";
                        } else {
                          return null;
                        }
                      },
                      dropDownItemCount: pages.length,
                      dropDownList: pages,
                      onChanged: (val) {
                        print("position onChange val : ${val}");
                        print(
                            "positionController.dropDownValue : ${reportPageController.dropDownValue!.value}");
                        selectedPageName =
                            reportPageController.dropDownValue!.value;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Text('오류 및 개선요청 내용',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Palette.gray00,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Palette.mainBackground,
                  ),
                  constraints:
                      BoxConstraints(minHeight: 300, minWidth: double.infinity),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    enabled: true,
                    maxLines: null,
                    controller: errorContents,
                    autofocus: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      /* content padding을 20이상 잡아두지 않으면,
                      한글 입력 시 텍스트가 위아래로 움직이는 오류 발생 */
                      contentPadding: EdgeInsets.all(20),
                      hintText: '오류가 발생한 내용 또는 개선이 필요한 부분을 알려주세요.',
                      hintStyle: TextStyle(color: Palette.gray99),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Palette.gray00),
                    /* validator:
                          _model.textControllerValidator.asValidator(context), */
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Align(
                //   alignment: AlignmentDirectional(0, -0.05),
                //   child: Row(
                //     mainAxisSize: MainAxisSize.max,
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       TextButton(
                //           onPressed: () {
                //             // 로그인 페이지로 이동
                //             Navigator.pop(context);
                //           },
                //           child: Container(
                //             alignment: Alignment.center,
                //             width: 80,
                //             height: 50,
                //             child: Text("취소",
                //                 style: TextStyle(
                //                     color: Palette.textRed, fontSize: 16)),
                //           )),
                //       TextButton(
                //           onPressed: () {
                //             content = errorContents.text;
                //             AuthService authService = AuthService();
                //             var user = authService.currentUser();
                //             ReportService reportService = ReportService();
                //             reportService
                //                 .create(
                //                     user!.uid,
                //                     user.displayName,
                //                     user.phoneNumber,
                //                     user.email,
                //                     selectedPageName,
                //                     content,
                //                     DateTime.now(),
                //                     'N',
                //                     null)
                //                 .then((value) {
                //               Navigator.pop(context);
                //             });
                //           },
                //           child: Container(
                //             alignment: Alignment.center,
                //             width: 80,
                //             height: 50,
                //             child: Text("제출",
                //                 style: TextStyle(
                //                     color: Palette.textBlue, fontSize: 16)),
                //           )),
                //     ],
                //   ),
                // ),

                /*##################FontWeight 실험실####################*/
                // Row(
                //   children: [
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text('프리텐다드 normal',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.normal, fontSize: 20)),
                //         Text('프리텐다드 normal',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.normal, fontSize: 20)),
                //         Text('프리텐다드 normal',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.normal, fontSize: 20)),
                //         Text('프리텐다드 normal',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.normal, fontSize: 20)),
                //         Text('프리텐다드 normal',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.normal, fontSize: 20)),
                //         Text('프리텐다드 normal',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.normal, fontSize: 20)),
                //         Text('프리텐다드 bold',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.bold, fontSize: 20)),
                //         Text('프리텐다드 bold',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.bold, fontSize: 20)),
                //         Text('프리텐다드 bold',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.bold, fontSize: 20)),
                //       ],
                //     ),
                //     SizedBox(width: 2),
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text('프리텐다드 100 THin',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.w100, fontSize: 20)),
                //         Text('프리텐다드 200 ExtraLight',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.w200, fontSize: 20)),
                //         Text('프리텐다드 300 Light',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.w300, fontSize: 20)),
                //         Text('프리텐다드 400 Regular',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.w400, fontSize: 20)),
                //         Text('프리텐다드 500 Medium',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.w500, fontSize: 20)),
                //         Text('프리텐다드 600 SemiBold',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.w600, fontSize: 20)),
                //         Text('프리텐다드 700 Bold',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.w700, fontSize: 20)),
                //         Text('프리텐다드 800 ExtraBold',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.w800, fontSize: 20)),
                //         Text('프리텐다드 900 Black',
                //             style: TextStyle(
                //                 fontWeight: FontWeight.w900, fontSize: 20)),
                //       ],
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
