import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_project/app/data/model/action.dart';
import 'package:web_project/app/data/provider/action_service.dart';

import '../../data/provider/auth_service.dart';
import '../../data/model/color.dart';
import '../../function/globalFunction.dart';
import '../widget/globalWidget.dart';
import '../../data/model/action.dart' as tmpActionClass;

GlobalFunction globalFunction = GlobalFunction();

List resultActionList = [];

late FocusNode apparatusFocusNode;
late FocusNode positionFocusNode;
late FocusNode actionNameFocusNode;

class ActionAdd extends StatefulWidget {
  List tmpActionList = [];
  ActionAdd({super.key});
  ActionAdd.manageList(this.tmpActionList, {super.key});

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

    resultActionList = widget.tmpActionList;

    apparatusFocusNode = FocusNode();
    positionFocusNode = FocusNode();
    actionNameFocusNode = FocusNode();
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

    apparatusFocusNode.dispose();
    positionFocusNode.dispose();
    actionNameFocusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  final apparatuses = [
    DropDownValueModel(
        name: 'OTHERS', value: 'OT', toolTipMsg: "??????????????? ????????? ?????? ?????? ??????????????????."),
    DropDownValueModel(name: 'CADILLAC', value: 'CA', toolTipMsg: "?????????"),
    DropDownValueModel(name: 'REFORMER', value: 'RE', toolTipMsg: "?????????"),
    DropDownValueModel(name: 'CHAIR', value: 'CH', toolTipMsg: "??????"),
    DropDownValueModel(name: 'LADDER BARREL', value: 'LA', toolTipMsg: "?????? ??????"),
    DropDownValueModel(name: 'SPRING BOARD', value: 'SB', toolTipMsg: "????????? ??????"),
    DropDownValueModel(
        name: 'SPINE CORRECTOR', value: 'SC', toolTipMsg: "????????? ?????????"),
    DropDownValueModel(name: 'MAT', value: 'MAT', toolTipMsg: "??????"),
  ];

  final positions = [
    DropDownValueModel(
        name: "OTHERS", value: 'others', toolTipMsg: "??????????????? ????????? ?????? ?????? ??????????????????."),
    DropDownValueModel(name: "SUPINE", value: 'supine', toolTipMsg: "?????????"),
    DropDownValueModel(name: "SITTING", value: 'sitting', toolTipMsg: "?????????"),
    DropDownValueModel(name: "PRONE", value: 'prone', toolTipMsg: "????????????"),
    DropDownValueModel(
        name: "KNEELING", value: 'kneeling', toolTipMsg: "?????? ?????? ??????"),
    DropDownValueModel(
        name: "SIDE LYING", value: 'side lying', toolTipMsg: "????????? ?????????"),
    DropDownValueModel(
        name: "STANDING", value: 'standing', toolTipMsg: "??? ??????  ??????"),
    DropDownValueModel(
        name: "PLANK", value: 'plank', toolTipMsg: "?????? ?????? ????????? ????????? ??????"),
    DropDownValueModel(
        name: "QUADRUPED", value: 'quadruped', toolTipMsg: "?????? ?????? ????????????"),
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
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '????????? ?????? ??????',
                    style: TextStyle(
                        color: Palette.gray00,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),

                /// ?????? ??????
                DropDownTextField(
                  listTextStyle: TextStyle(fontSize: 14),
                  controller: apparatusController,
                  isEnabled: true,
                  clearOption: false,
                  enableSearch: true,
                  // textFieldFocusNode: textFieldFocusNode,
                  // searchFocusNode: searchFocusNode,
                  clearIconProperty: IconProperty(color: Palette.buttonOrange),
                  textFieldDecoration: InputDecoration(
                    hintText: "????????? ???????????????.",
                    hintStyle: TextStyle(fontSize: 14),
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
                    hintText: "???????????? ?????? ????????? ???????????????",
                    hintStyle: TextStyle(fontSize: 14),
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
                      if (apparatusController.dropDownValue!.name == "OTHERS") {
                        apparatusOffstage = false;
                        apparatusFocusNode.requestFocus();
                      } else {
                        apparatusOffstage = true;
                      }
                    });
                  },
                ),
                SizedBox(height: 10),

                /// ?????? OTHERS ?????????
                Offstage(
                  offstage: apparatusOffstage,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Palette.grayFF,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: BaseTextField(
                      customController: otherApparatusController,
                      customFocusNode: apparatusFocusNode,
                      hint: "????????? ????????? ??????????????????.",
                      showArrow: false,
                      customFunction: () {},
                    ),
                  ),
                ),

                /// ?????? ??????
                DropDownTextField(
                  listTextStyle: TextStyle(fontSize: 14),
                  controller: positionController,
                  isEnabled: true,
                  clearOption: false,
                  enableSearch: true,
                  // textFieldFocusNode: textFieldFocusNode,
                  // searchFocusNode: searchFocusNode,
                  clearIconProperty: IconProperty(color: Palette.buttonOrange),
                  textFieldDecoration: InputDecoration(
                    hintText: "????????? ???????????????.",
                    hintStyle: TextStyle(fontSize: 14),
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
                    hintText: "???????????? ?????? ????????? ???????????????",
                    hintStyle: TextStyle(fontSize: 14),
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
                      if (positionController.dropDownValue!.name == "OTHERS") {
                        positionOffstage = false;
                        positionFocusNode.requestFocus();
                      } else {
                        positionOffstage = true;
                      }
                    });
                  },
                ),
                SizedBox(height: 10),

                /// ?????? OTHERS ?????????
                Offstage(
                  offstage: positionOffstage,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Palette.grayFF,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: BaseTextField(
                      customController: otherPositionController,
                      customFocusNode: positionFocusNode,
                      hint: "????????? ????????? ??????????????????.",
                      showArrow: false,
                      customFunction: () {},
                    ),
                  ),
                ),

                /// ?????? ?????? ?????????
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Palette.grayFF,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: BaseTextField(
                    customController: nameController,
                    customFocusNode: actionNameFocusNode,
                    hint: "????????? ???????????? ??????????????????.",
                    showArrow: false,
                    customFunction: () {},
                  ),
                ),

                SizedBox(height: 10),

                //// ??????????????? ??????
                ElevatedButton(
                  onPressed: () async {
                    print("?????? ??????");
                    // create action
                    if (apparatusOffstage) {
                      if (globalFunction.selectNullCheck(
                          context, apparatusController, "?????? ??????")) {
                        selectedApparatus =
                            apparatusController.dropDownValue!.value;
                        otherApparatusName =
                            apparatusController.dropDownValue!.name;
                      }
                    } else {
                      if (globalFunction.textNullCheck(
                          context, otherApparatusController, "????????? ?????? ??????")) {
                        selectedApparatus =
                            apparatusController.dropDownValue!.value;
                        otherApparatusName = otherApparatusController.text;
                      }
                    }
                    if (positionOffstage) {
                      if (globalFunction.selectNullCheck(
                          context, positionController, "?????? ??????")) {
                        selectecPosition =
                            positionController.dropDownValue!.value;
                        otherPositionName =
                            positionController.dropDownValue!.name;
                      }
                    } else {
                      if (globalFunction.textNullCheck(
                          context, otherPositionController, "????????? ?????? ??????")) {
                        selectecPosition =
                            positionController.dropDownValue!.value;
                        otherPositionName = otherPositionController.text;
                      }
                    }
                    if (globalFunction.textNullCheck(
                        context, nameController, "????????? ?????? ??????")) {
                      actionName = nameController.text;
                    }
                    if (selectedApparatus.isNotEmpty &&
                        selectecPosition.isNotEmpty &&
                        actionName.isNotEmpty) {
                      String id = await actionService.create(
                        selectedApparatus,
                        otherApparatusName,
                        selectecPosition,
                        otherPositionName,
                        actionName,
                        user.uid,
                        actionName.toUpperCase(),
                        actionName.toLowerCase(),
                      );

                      List tmpResultList = [];
                      //tmpActionClass.Action tmpAction = tmpActionClass.Action(selectedApparatus, otherApparatusName, selectecPosition, otherPositionName, actionName, id, actionName.toUpperCase(), actionName.toLowerCase(), actionName.toLowerCase().split(" "), user.uid);
                      // {name: ?????? ???????????? ???????????? Hugging, upperCaseName: ?????? ???????????? ???????????? HUGGING, otherApparatusName: SPRING BOARD, nGramizedLowerCaseName: [??????, ????????????, ????????????, hugging], position: standing, otherPositionName: STANDING, apparatus: SB, author: p0gKIY1vArckS6JTZQdYG4RymEk2, lowerCaseName: ?????? ???????????? ???????????? hugging, id: 2RqZOEQK09sRx7bcqQ6n}
                      resultActionList.add({});
                      resultActionList[resultActionList.length - 1]['name'] =
                          actionName;
                      resultActionList[resultActionList.length - 1]
                          ['upperCaseName'] = actionName.toUpperCase();
                      resultActionList[resultActionList.length - 1]
                          ['otherApparatusName'] = otherApparatusName;
                      resultActionList[resultActionList.length - 1]
                              ['nGramizedLowerCaseName'] =
                          actionName.toLowerCase().split(" ");
                      resultActionList[resultActionList.length - 1]
                          ['position'] = selectecPosition;
                      resultActionList[resultActionList.length - 1]
                          ['otherPositionName'] = otherPositionName;
                      resultActionList[resultActionList.length - 1]
                          ['apparatus'] = selectedApparatus;
                      resultActionList[resultActionList.length - 1]['author'] =
                          user.uid;
                      resultActionList[resultActionList.length - 1]
                          ['lowerCaseName'] = actionName.toLowerCase();
                      resultActionList[resultActionList.length - 1]['id'] = id;
                      // resultActionList.add(tmpAction);
                      print(resultActionList);
                      resultActionList
                          .sort(((a, b) => a['name'].compareTo(b['name'])));

                      tmpResultList.add(actionName);
                      tmpResultList.add(resultActionList);
                      // ????????? ?????? ?????? ????????? actionSelector??? ??????
                      Navigator.pop(context, tmpResultList);
                    } else {
                      // ??? ??? ?????? ???
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("?????? ????????? ?????? ????????????."),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 0,
                    backgroundColor: Palette.buttonOrange,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 90),
                    child: Text("????????????", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
