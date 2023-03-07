import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_project/app/function/globalFunction.dart';

class SequenceRecentService extends ChangeNotifier {
  CollectionReference<Map<String, dynamic>> sequenceRecentCollection =
      FirebaseFirestore.instance.collection('sequenceRecent');

  GlobalFunction globalFunction = GlobalFunction();

// 읽어오는 함수
  Future<List> read(String uid, String memberId) async {
    // .orderBy("name") // orderBy 기능을 사용하기 위해서는 console.cloud.google.com
    var result = await sequenceRecentCollection
        .where('uid', isEqualTo: uid)
        // .where('memberId',isEqualTo: memberId)
        // .orderBy('sequenceTitle', descending: false)
        .orderBy('timeStamp',descending: true)
        .get();

    List resultList = [];

    var docsLength = result.docs.length;
    var rstObj = {};

    for (int i = 0; i < docsLength; i++) {
      // print("result.docs[i].data() : ${result.docs[i].data()}");
      rstObj = result.docs[i].data();
      // 문서 id는 없으므로 붙여줌
      rstObj['id'] = result.docs[i].id;
      print("fdsabmioenroifaenf rstObj : ${rstObj}");
      resultList.add(rstObj);
    }
    notifyListeners();
    return resultList;
  }

  Future<List> readWithMemberId(String uid, String memberId) async {
    // .orderBy("name") // orderBy 기능을 사용하기 위해서는 console.cloud.google.com
    var result = await sequenceRecentCollection
        .where('uid', isEqualTo: uid)
        .where('memberId',isEqualTo: memberId)
        // .orderBy('sequenceTitle', descending: false)
        .orderBy('timeStamp',descending: true)
        .get();

    List resultList = [];

    var docsLength = result.docs.length;
    var rstObj = {};

    for (int i = 0; i < docsLength; i++) {
      // print("result.docs[i].data() : ${result.docs[i].data()}");
      rstObj = result.docs[i].data();
      // 문서 id는 없으므로 붙여줌
      rstObj['id'] = result.docs[i].id;
      print("fdsabmioenroifaenf rstObj : ${rstObj}");
      resultList.add(rstObj);
    }
    notifyListeners();
    return resultList;
  }

  ///Create하기 Delete 기능 없음
  Future<String> create(
    final String uid,
    final String memberId,
    final String todayNote, // 일별 레슨 노트
    final List actionList, // List -> Json
    final bool isfavorite, // 즐겨찾는 시퀀스 (추후 추가 가능성)
    final int like, // 좋아요 수 (추후 추가 가능성)
    final Timestamp timeStamp, // 꺼내 쓸 때 변환해서 씀
    final String sequenceTitle, // ###님 YYYY-DD-MM HH:MM
  ) async {
    String id = "";

    //
    await sequenceRecentCollection.add({
      'uid': uid, // 작성자 uid
      'memberId': memberId, // 회원 docId
      'actionList': actionList, // 동작 리스트 (순서 포함)
      'isfavorite': isfavorite,
      'like': like,
      'timeStamp': timeStamp,
      'sequenceTitle': sequenceTitle,
    }).then((value) {
      id = value.id;
      print("Successfully completed");
    }, onError: (e) {
      print("Error completing: ${e}");
    });
    notifyListeners(); // 화면 갱신

    return id;
  }

  Future<String> update(
    final String uid,
    final String id,
    final String memberId,
    final String actionList, // List -> Json
    final bool isfavorite, // 즐겨찾는 시퀀스 (추후 추가 가능성)
    final int like, // 좋아요 수 (추후 추가 가능성)
    final Timestamp timeStamp, // 꺼내 쓸 때 변환해서 씀
    final String sequenceTitle, // ###님 YYYY-DD-MM HH:MM,
  ) async {
    /// 이게 뭐지
    // print("id : $id"); // id는 고유값

    String id = "";
    await sequenceRecentCollection.doc(id).update({
      'uid': uid,
      'memberId': memberId,
      'actionList': actionList,
      'isfavorite': isfavorite,
      'like': like,
      'timeStamp': timeStamp,
      'sequenceTitle': sequenceTitle,
    }).then((value) {
      print("Successfully completed");
    }, onError: (e) {
      print("Error completing: ${e}");
    });
    notifyListeners(); // 화면 갱신

    return id;
  }

  void delete({
    String? id,
    Function? onSuccess,
    Function? onError,
  }) async {
    // bucket 삭제
    await sequenceRecentCollection.doc(id).delete();
    notifyListeners();
    // 화면 갱신
    onSuccess!(); // 성공시

    onError!(); // 에러시
  }
}
