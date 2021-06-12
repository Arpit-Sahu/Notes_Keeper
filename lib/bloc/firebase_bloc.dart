import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'firebase_event.dart';
part 'firebase_state.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  FirebaseBloc() : super(FirebaseInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<FirebaseState> mapEventToState(
    FirebaseEvent event,
  ) async* {
    if (event is DeleteNoteEvent) {
      await deleteNotes(event.id);
    } else if (event is DeleteTrashEvent) {
      await deleteTrash(event.id);
    } else if (event is AddTrashEvent) {
      await addTrash(event.temp);
    } else if (event is AddNoteEvent) {
      await addNote(event.temp);
    } else if (event is UpdateNoteEvent) {
      await update(event.id, event.title, event.des);
    } else if (event is CreateNewNotesEvent) {
      await createNewNote(event.title, event.des);
    }
  }

  Future<void> deleteNotes(String id) async {
    await _firestore.collection('notesDatabase').doc(id).delete();
  }

  Future<void> deleteTrash(String id) async {
    await _firestore.collection('TrashDatabase').doc(id).delete();
  }

  Future<void> addTrash(var temp) async {
    _firestore.collection('TrashDatabase').add(
      {
        'Title': temp['Title'],
        'Description': temp['Description'],
      },
    );
  }

  Future<void> addNote(var temp) async {
    _firestore.collection('notesDatabase').add(
      {
        'Title': temp['Title'],
        'Description': temp['Description'],
      },
    );
  }

  Future<void> createNewNote(String title, String des) async{
    await _firestore.collection('notesDatabase').add({
                      'Title': title,
                      'Description': des,
                    });
  }

  Future<void> update(String id, String title, String des) async {
    await _firestore.collection('notesDatabase').doc(id).update({
      'Title': title,
      'Description': des,
    });
  }


  Stream<QuerySnapshot<Map<String, dynamic>>> getNotesStream() {
    return _firestore.collection('notesDatabase').snapshots();
  }

    Stream<QuerySnapshot<Map<String, dynamic>>> getTrashStream() {
    return _firestore.collection('TrashDatabase').snapshots();
  }

}
