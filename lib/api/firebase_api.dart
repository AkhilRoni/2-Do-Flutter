import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tudo/model/todo.dart';

class FirebaseService {
//  final FirebaseFirestore _firestore = FirebaseFirestore.instance; (use only if necessary)
  static Future<void> addtask(ToDo toDo) async {
    final doctodo = FirebaseFirestore.instance.collection('tasks').doc();
    toDo.id = doctodo.id;
    final todomap = toDo.toMap();
    await doctodo.set(todomap);
  }

  static Future<void> updateisDone(String? id, bool isDone) async {
    final taskReference =
        FirebaseFirestore.instance.collection('tasks').doc(id);

    await taskReference.update({'isDone': isDone});
  }

  static Future<List<ToDo>> fetchTasksFromFirebase() async {
    final takeSnapshot =
        await FirebaseFirestore.instance.collection('tasks').get();
    final tasksList = takeSnapshot.docs.map((doc) {
      final data = doc.data();
      return ToDo(
        id: doc.id,
        todoText: data['todoText'],
        isDone: data['isDone'] ?? false,
      );
    }).toList();
    return tasksList;
  }

  static Future<void> deletefromFirebase(String? id) async {
    final taskReference =
        FirebaseFirestore.instance.collection('tasks').doc(id);
    await taskReference.delete();
  }
}
