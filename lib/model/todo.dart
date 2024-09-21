import 'package:cloud_firestore/cloud_firestore.dart';

class ToDo {
  String? id;
  String? todoText;
  bool isDone;
  Timestamp? createdAt;

  ToDo(
      {required this.id,
      required this.todoText,
      this.isDone = false,
      this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todoText': todoText,
      'isDone': isDone,
    };
  }

  // // static Future<List<ToDo>> fetchTasksFromFirebase() async {
  //   // final takeSnapshot =
  //   //     await FirebaseFirestore.instance.collection('tasks').get();
  //   // final tasksList = takeSnapshot.docs.map((doc) {
  //   //   final data = doc.data() as Map<String, dynamic>;
  //   //   return ToDo(
  //   //       id: doc.id,
  //   //       todoText: data['toDotext'],
  //   //       isDone: data['isDone'] ?? false);
  //   // }).toList();

  //   return tasksList;
  // }
}
