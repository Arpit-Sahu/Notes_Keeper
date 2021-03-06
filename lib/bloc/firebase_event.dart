part of 'firebase_bloc.dart';

@immutable
abstract class FirebaseEvent {}

class DeleteNoteEvent extends FirebaseEvent {
  final String id;
  DeleteNoteEvent({required this.id});
}

class DeleteTrashEvent extends FirebaseEvent {
  final String id;
  DeleteTrashEvent({required this.id});
}

class CreateNewNotesEvent extends FirebaseEvent {
  final String title;
  final String des;
  final bool hasVideo;
  final String videoLink;
  CreateNewNotesEvent({required this.title, required this.des, required this.hasVideo, required this.videoLink});
}

class AddTrashEvent extends FirebaseEvent {
  final temp;
  AddTrashEvent({required this.temp});
}

class AddNoteEvent extends FirebaseEvent {
  final temp;
  AddNoteEvent({required this.temp});
}

class UpdateNoteEvent extends FirebaseEvent {
  final String id;
  final String title;
  final String des;
  final bool hasVideo;
  final String videoLink;
  UpdateNoteEvent({
    required this.id,
    required this.title,
    required this.des,
    required this.hasVideo,
    required this.videoLink,
  });
}

class NotesDB extends FirebaseEvent{}

class TrashDB extends FirebaseEvent{}

class NewNoteDB extends FirebaseEvent{
  final String title;
  final String des;
  NewNoteDB({required this.title, required this.des});
}

class MoveToTrashDB extends FirebaseEvent{
  final String title;
  MoveToTrashDB({required this.title});
}

class MoveToNotesDB extends FirebaseEvent{
  final String title;
  MoveToNotesDB({required this.title});
}



