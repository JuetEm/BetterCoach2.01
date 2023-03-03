import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:web_project/app/data/model/color.dart';
import 'package:web_project/app/data/model/lessonNoteInfo.dart';
import 'package:web_project/app/data/model/userInfo.dart';
import 'package:web_project/app/ui/page/lessonUpdate.dart';
import 'package:web_project/app/ui/page/memberInfo.dart';

class LessonCardWidget extends StatefulWidget {
  LessonCardWidget({
    Key? key,
    required this.userInfo,
    required this.memberId,
    required this.lessonDate,
    required this.todayNote,
    required this.lessonActionList,
    this.isExpanded = false,
  }) : super(key: key);

  final UserInfo userInfo;
  final String memberId;
  final String lessonDate;
  final String todayNote;
  final List lessonActionList;
  bool isExpanded;

  @override
  State<LessonCardWidget> createState() => _LessonCardWidgetState();
}

class _LessonCardWidgetState extends State<LessonCardWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    return Container(
      color: Palette.mainBackground,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Column(
          children: [
            /// 수업일 입력창
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Palette.gray99,
                ),
                SizedBox(width: 10),

                /// 새로 도전하는 수업일 입력창
                SizedBox(
                  width: 140,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(6, 0, 10, 0),
                    child: Text(
                      '${widget.lessonDate}',
                      style: TextStyle(
                          color: Palette.gray00, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 0),

            /// 일별 메모 입력창
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Icon(
                    Icons.text_snippet_outlined,
                    color: Palette.gray99,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 366),
                  width: MediaQuery.of(context).size.width - 114,
                  child: widget.todayNote == ""
                      ? Text(
                          '-',
                          style: TextStyle(color: Palette.gray99, fontSize: 14),
                        )
                      : Text(
                          '${widget.todayNote}',
                          style: TextStyle(color: Palette.gray00, fontSize: 14),
                        ),
                ),
              )
            ]),

            const SizedBox(height: 0),

            /// 동작별 메모 (New)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.accessibility_new_rounded,
                      color: Palette.gray99,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('동작별 메모'),
                  ],
                ),
                SizedBox(height: 10),
                
                /// 동작별 메모 한 묶음.
                ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true, 
                    itemCount: widget.lessonActionList.length,
                    itemBuilder: (context, index) {
                      print('###빌드는 하긴 하니?');
                      
                      final doc;
                      // 사용한 모델 객체를 선언해 리스트[index] 로 받음
                      print("vieojfvbhiasdfiodsafiu - id : ${widget.lessonActionList[index]['id']}, uid : ${widget.lessonActionList[index]['uid']}, docId : ${widget.lessonActionList[index]['docId']}, name : ${widget.lessonActionList[index]['name']}, lessonDate : ${widget.lessonActionList[index]['lessonDate']}");
                          doc = widget.lessonActionList[index];
                      Key? valueKey;
                      // 클래스에서 객체 꺼내 쓰는 방식
                      doc['pos'] = index;
                      valueKey = ValueKey(doc['pos']);

                      String uid = doc['uid']; // lessonNoteInfo.uid; // doc['uid']; // 강사 고유번호

                      String name = doc['name']; // lessonNoteInfo.name; //회원이름
                      String phoneNumber = userInfo.phoneNumber; // lessonNoteInfo.phoneNumber
                          // .toString(); // 회원 고유번호 (전화번호로 회원 식별)
                      String? apratusName = doc['apratusName']; //  lessonNoteInfo.apratusName; //기구이름
                      String? actionName = doc['actionName']; //  lessonNoteInfo.actionName; //동작이름
                      String lessonDate = doc['lessonDate']; //  lessonNoteInfo.lessonDate; //수업날짜
                      String? grade = doc['grade']; //  lessonNoteInfo.grade; //수행도
                      String? totalNote = doc['totalNote']; //  lessonNoteInfo.totalNote; //수업총메모
                      int? pos = doc['pos']; //  lessonNoteInfo.pos; //수업총메모
                      bool? isSelected = doc['noteSelected']; //  lessonNoteInfo.noteSelected;

                      print('### $index & $isSelected');

                      return Offstage(
                        key: valueKey,
                        offstage: widget.isExpanded ? false : !isSelected!,
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  width: 220,
                                  child: Chip(
                                    backgroundColor: totalNote == ""
                                        ? Palette.grayEE
                                        : Palette.titleOrange,
                                    label: Text("${actionName} - ${lessonDate}",
                                        style: TextStyle(
                                            color: Palette.gray00,
                                            fontSize: 12)),
                                  )),
                              SizedBox(width: 6),
                              Container(
                                constraints: BoxConstraints(maxWidth: 214),
                                width: MediaQuery.of(context).size.width - 265,
                                padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    totalNote!,
                                    style: TextStyle(
                                        color: Palette.gray00, fontSize: 12),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    })
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            SizedBox(
              child: Center(
                child: IconButton(
                  icon: Icon(widget.isExpanded
                      ? Icons.expand_less_outlined
                      : Icons.expand_more_outlined),
                  onPressed: () {
                    widget.isExpanded = !widget.isExpanded;
                    setState(() {});
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
