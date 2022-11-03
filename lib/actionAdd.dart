import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'action_service.dart';
import 'auth_service.dart';
import 'color.dart';
import 'globalFunction.dart';
import 'globalWidget.dart';

GlobalFunction globalFunction = GlobalFunction();

class ActionAdd extends StatefulWidget {
  const ActionAdd({super.key});

  @override
  State<ActionAdd> createState() => _ActionAddState();
}

class _ActionAddState extends State<ActionAdd> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController apparatusController;
  late SingleValueDropDownController positionController;
  late TextEditingController otherApparatusController;
  late TextEditingController otherPositionController;
  late TextEditingController nameController;

  String selectedApparatus = "";
  String otherApparatusName = "";
  String selectecPosition = "";
  String otherPositionName = "";
  String actionName = "";

  @override
  void initState() {
    apparatusController = SingleValueDropDownController();
    positionController = SingleValueDropDownController();
    otherApparatusController = TextEditingController();
    otherPositionController = TextEditingController();
    nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    apparatusController.dispose();
    positionController.dispose();
    otherApparatusController.dispose();
    otherPositionController.dispose();
    nameController.dispose();
    selectedApparatus = "";
    selectecPosition = "";
    actionName = "";
    // TODO: implement dispose
    super.dispose();
  }

  final apparatuses = [
    DropDownValueModel(
        name: 'OTHERS', value: 'OT', toolTipMsg: "등록하려는 도구가 없는 경우 선택해주세요."),
    DropDownValueModel(name: 'CADILLAC', value: 'CA', toolTipMsg: "캐딜락"),
    DropDownValueModel(name: 'REFORMER', value: 'RE', toolTipMsg: "리포머"),
    DropDownValueModel(name: 'CHAIR', value: 'CH', toolTipMsg: "체어"),
    DropDownValueModel(name: 'LADDER BARREL', value: 'LA', toolTipMsg: "래더 바렐"),
    DropDownValueModel(name: 'SPRING BOARD', value: 'SB', toolTipMsg: "스프링 보드"),
    DropDownValueModel(
        name: 'SPINE CORRECTOR', value: 'SC', toolTipMsg: "스파인 코렉터"),
    DropDownValueModel(name: 'MAT', value: 'MAT', toolTipMsg: "매트"),
  ];

  final positions = [
    DropDownValueModel(
        name: "OTHERS", value: 'others', toolTipMsg: "등록하려는 자세가 없는 경우 선택해주세요."),
    DropDownValueModel(name: "SUPINE", value: 'supine', toolTipMsg: "누워서"),
    DropDownValueModel(name: "SITTING", value: 'sitting', toolTipMsg: "앉아서"),
    DropDownValueModel(name: "PRONE", value: 'prone', toolTipMsg: "엎드려서"),
    DropDownValueModel(
        name: "KNEELING", value: 'kneeling', toolTipMsg: "무릎 꿇고 서서"),
    DropDownValueModel(
        name: "SIDE LYING", value: 'side lying', toolTipMsg: "옆으로 누워서"),
    DropDownValueModel(
        name: "STANDING", value: 'standing', toolTipMsg: "양 발로  서서"),
    DropDownValueModel(
        name: "PLANK", value: 'plank', toolTipMsg: "다리 뻗고 엎드려 상하체 지지"),
    DropDownValueModel(
        name: "QUADRUPED", value: 'quadruped', toolTipMsg: "무릎 꿇고 엎드려서"),
  ];

  bool apparatusOffstage = true;
  bool positionOffstage = true;

  String currentSeletecValue = "SUPINE";

  @override
  Widget build(BuildContext context) {
    // final actionService = context.read<ActionService>();
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    return Consumer<ActionService>(builder: (context, actionService, child) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        backgroundColor: Palette.secondaryBackground,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: DropDownTextField(
                        controller: apparatusController,
                        isEnabled: true,
                        clearOption: false,
                        enableSearch: true,
                        // textFieldFocusNode: textFieldFocusNode,
                        // searchFocusNode: searchFocusNode,
                        clearIconProperty:
                            IconProperty(color: Palette.buttonOrange),
                        textFieldDecoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 14),
                          labelText: "기구를 선택해주세요.",
                          hintText: "기구를 선택하세요.",
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
                        searchDecoration: InputDecoration(
                          labelText: "기구 검색",
                          hintText: "검색하고 싶은 기구를 입력하세요",
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
                          print("apparatus validator value : ${value}");
                          if (value == null) {
                            return "required field";
                          } else {
                            return null;
                          }
                        },
                        dropDownItemCount: apparatuses.length,
                        dropDownList: apparatuses,
                        onChanged: (val) {
                          print("apparatus onChange val : ${val}");
                          print(
                              "apparatusController.dropDownValue : ${apparatusController.dropDownValue!.value}");
                          setState(() {
                            if (apparatusController.dropDownValue!.name ==
                                "OTHERS") {
                              apparatusOffstage = false;
                            } else {
                              apparatusOffstage = true;
                            }
                          });
                        },
                      ),
                    ),

                    /// 기구 OTHERS 입력창
                    Offstage(
                      offstage: apparatusOffstage,
                      child: BaseTextField(
                        customController: otherApparatusController,
                        hint: "새로운 기구를 입력해주세요.",
                        showArrow: false,
                        customFunction: () {},
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: DropDownTextField(
                        controller: positionController,
                        isEnabled: true,
                        clearOption: false,
                        enableSearch: true,
                        // textFieldFocusNode: textFieldFocusNode,
                        // searchFocusNode: searchFocusNode,
                        clearIconProperty:
                            IconProperty(color: Palette.buttonOrange),
                        textFieldDecoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 14),
                          labelText: "자세를 선택해주세요.",
                          hintText: "자세를 선택하세요.",
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
                        searchDecoration: InputDecoration(
                          labelText: "자세 검색",
                          hintText: "검색하고 싶은 자세를 입력하세요",
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
                        dropDownItemCount: positions.length,
                        dropDownList: positions,
                        onChanged: (val) {
                          print("position onChange val : ${val}");
                          print(
                              "positionController.dropDownValue : ${positionController.dropDownValue!.value}");
                          setState(() {
                            if (positionController.dropDownValue!.name ==
                                "OTHERS") {
                              positionOffstage = false;
                            } else {
                              positionOffstage = true;
                            }
                          });
                        },
                      ),
                    ),

                    /// 자세 OTHERS 입력창
                    Offstage(
                      offstage: positionOffstage,
                      child: BaseTextField(
                        customController: otherPositionController,
                        hint: "새로운 자세를 입력해주세요.",
                        showArrow: false,
                        customFunction: () {},
                      ),
                    ),

                    /// 동작 이름 입력창
                    BaseTextField(
                      customController: nameController,
                      hint: "새로운 동작명을 입력해주세요.",
                      showArrow: false,
                      customFunction: () {},
                    ),
                    Divider(height: 1),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 11, 0, 22),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(48.0),
                              ),
                              color: Palette.buttonOrange,
                            ),
                            height: 48,
                            width: 238,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "동작생성",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () {
                            print("추가 버튼");
                            // create action
                            if (apparatusOffstage) {
                              if (globalFunction.selectNullCheck(
                                  context, apparatusController, "기구 선택")) {
                                selectedApparatus =
                                    apparatusController.dropDownValue!.value;
                                otherApparatusName =
                                    apparatusController.dropDownValue!.name;
                              }
                            } else {
                              if (globalFunction.textNullCheck(context,
                                  otherApparatusController, "새로운 기구 이름")) {
                                selectedApparatus =
                                    apparatusController.dropDownValue!.value;
                                otherApparatusName =
                                    otherApparatusController.text;
                              }
                            }
                            if (positionOffstage) {
                              if (globalFunction.selectNullCheck(
                                  context, positionController, "자세 선택")) {
                                selectecPosition =
                                    positionController.dropDownValue!.value;
                                otherPositionName =
                                    positionController.dropDownValue!.name;
                              }
                            } else {
                              if (globalFunction.textNullCheck(context,
                                  otherPositionController, "새로운 자세 이름")) {
                                selectecPosition =
                                    positionController.dropDownValue!.value;
                                otherPositionName =
                                    otherPositionController.text;
                              }
                            }
                            if (globalFunction.textNullCheck(
                                context, nameController, "새로운 동작 이름")) {
                              actionName = nameController.text;
                            }
                            if (selectedApparatus.isNotEmpty &&
                                selectecPosition.isNotEmpty &&
                                actionName.isNotEmpty) {
                              actionService.create(
                                selectedApparatus,
                                otherApparatusName,
                                selectecPosition,
                                otherPositionName,
                                actionName,
                                user.uid,
                                actionName.toUpperCase(),
                                actionName.toLowerCase(),
                              );
                              // 신규 동작 추가 성공시 actionSelect로 이동
                              Navigator.pop(context, actionName);
                            } else {
                              // 빈 값 있을 때
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("모든 항목을 입력 해주세요."),
                              ));
                            }
                          }),
                    )

                    /// 추가 버튼
                  ],
                ),
              ),
            ),

            // FormField<String>(
            //   builder: (FormFieldState<String> state) {
            //     return InputDecorator(
            //       decoration: InputDecoration(
            //         labelText: "자세를 입력하세요.",
            //         hintText: "자세를 입력하세요.",
            //         errorStyle: TextStyle(
            //           color: Colors.redAccent,
            //           fontSize: 16,
            //         ),
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(8),
            //           borderSide: BorderSide(
            //             width: 0,
            //             style: BorderStyle.none,
            //           ),
            //         ),
            //         filled: true,
            //         contentPadding: EdgeInsets.all(16),
            //         fillColor: Colors.white,
            //       ),
            //       isEmpty: currentSeletecValue == '',
            //       child: DropdownButtonHideUnderline(
            //         child: DropdownButton<String>(
            //           value: currentSeletecValue,
            //           isDense: true,
            //           items: positions.map(
            //             (String value) {
            //               return DropdownMenuItem<String>(
            //                 value: value,
            //                 child: Text(value),
            //               );
            //             },
            //           ).toList(),
            //           onChanged: (newValue) {
            //             currentSeletecValue = newValue!;
            //             print("value : ${newValue}");
            //             setState(() {
            //               state.didChange(newValue);
            //             });
            //           },
            //         ),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      );
    });
  }
}
