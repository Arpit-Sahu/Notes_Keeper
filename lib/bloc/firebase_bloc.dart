import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:todo/dataBase/databaseHelper.dart';

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
      await update(event.id, event.title, event.des, event.hasVideo, event.videoLink);
    } else if (event is CreateNewNotesEvent) {
      await createNewNote(event.title, event.des, event.hasVideo, event.videoLink);
    }
    else if(event is NotesDB){
      await allNotesDB();
    }
    else if(event is TrashDB){
      await allTrashDB();
    }
    else if(event is NewNoteDB)
    {
      await newNoteDB(event.title, event.des);
    }
    else if(event is MoveToNotesDB)
    {
      await moveToNotesDB(event.title);
    }
    else if(event is MoveToTrashDB)
    {
      await moveToTrashDB(event.title);
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
        'HasVideo': temp['HasVideo'],
        'VideoLink': temp['HasVideo']?temp['VideoLink']:null,
      },
    );
    moveToTrashDB(temp['Title']);
  }

  Future<void> addNote(var temp) async {
    _firestore.collection('notesDatabase').add(
      {
        'Title': temp['Title'],
        'Description': temp['Description'],
        'HasVideo': temp['HasVideo'],
        'VideoLink': temp['HasVideo']?temp['VideoLink']:null,
      },
    );
    moveToNotesDB(temp['Title']);
  }

  Future<void> createNewNote(String title, String des, bool hasVideo, String videoLink) async{
    await _firestore.collection('notesDatabase').add({
                      'Title': title,
                      'Description': des,
                      'HasVideo': hasVideo,
                      'VideoLink': hasVideo?videoLink:null,
                    });
  }

  Future<void> update(String id, String title, String des, bool hasVideo, String videoLink ) async {
    await _firestore.collection('notesDatabase').doc(id).update({
      'Title': title,
      'Description': des,
      'HasVideo': hasVideo,
      'VideoLink': hasVideo?videoLink:null,
    });
  }


  Stream<QuerySnapshot<Map<String, dynamic>>> getNotesStream() {
    return _firestore.collection('notesDatabase').snapshots();
  }

    Stream<QuerySnapshot<Map<String, dynamic>>> getTrashStream() {
    return _firestore.collection('TrashDatabase').snapshots();
  }

  Future<List<Map<String, dynamic>>> allNotesDB() async {
    List<Map<String, dynamic>> queryRow = await DatabaseHelper.instance.queryAllNotes();
    return queryRow;
  }

  Future<List<Map<String, dynamic>>> allTrashDB() async {
    List<Map<String, dynamic>> queryRow = await DatabaseHelper.instance.queryAllTrash();
    return queryRow;
  }

  Future<void> newNoteDB(String title, String des) async {

    await DatabaseHelper.instance.insertNote({
      DatabaseHelper.title : title,
      DatabaseHelper.description : des,
    });
  }

  Future<void> moveToTrashDB(String title) async {
      await DatabaseHelper.instance.moveToTrash(title);
    }

  Future<void> moveToNotesDB(String title) async {
      await DatabaseHelper.instance.moveToNotes(title);
  }

  // Future<void> updateNoteDB(String title, String des) async {
  //     // await DatabaseHelper.instance;
  // }

  }


