import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:web_project/app/binding/ticketLibrary_service.dart';
import 'package:web_project/app/ui/ticketLibraryMake.dart';
import 'package:web_project/color.dart';
import 'package:web_project/globalWidget.dart';
import 'package:web_project/main.dart';
import 'package:web_project/ticketWidget.dart';
import 'package:web_project/userInfo.dart';

class TicketLibraryManage extends StatefulWidget {
  const TicketLibraryManage({this.TicketLibraryManageList, super.key});

  final List? TicketLibraryManageList;

  @override
  State<TicketLibraryManage> createState() => _TicketLibraryManageState();
}

class _TicketLibraryManageState extends State<TicketLibraryManage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TicketLibraryService>(
        builder: (context, TicketLibraryService, child) {
      return Scaffold(
        appBar: BaseAppBarMethod(context, "수강권 라이브러리", () {
          Navigator.pop(context);
        }, null, null),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              // 수강권 추가 버튼
              AddTicketWidget(customFunctionOnTap: () async {
                var result = await // 저장하기 성공시 Home로 이동
                    Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TicketLibraryMake(() {}, null)),
                ).then((value) {
                  print("수강권 추가 result");
                  setState(() {});
                });
              }),

              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 30),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.TicketLibraryManageList!.length,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    child: TicketWidget(
                      customFunctionOnTap: () async {
                        var result = await // 저장하기 성공시 Home로 이동
                            Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TicketLibraryMake(
                                  () {},
                                  widget.TicketLibraryManageList![index]
                                      ['ticketTitle'])),
                        ).then((value) {
                          print("수강권 추가 result");
                          setState(() {});
                        });
                      },
                      ticketCountLeft: globalVariables.ticketList[index]
                          ['ticketCountAll'],
                      ticketCountAll: globalVariables.ticketList[index]
                          ['ticketCountAll'],
                      ticketTitle: globalVariables.ticketList[index]
                          ['ticketTitle'],
                      ticketDescription: globalVariables.ticketList[index]
                          ['ticketDescription'],
                      ticketStartDate: globalVariables.ticketList[index]
                              ['ticketStartDate'] ??
                          "0000-00-00",
                      ticketEndDate: globalVariables.ticketList[index]
                              ['ticketEndDate'] ??
                          "0000-00-00",
                      ticketDateLeft: globalVariables.ticketList[index]
                          ['ticketDateLeft'],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}