class NoteClass {
  String title;
  String description;
  bool? isTrash;

  NoteClass({required this.title, required this.description, this.isTrash});
}

List<NoteClass> notes = [];
List<NoteClass> trashNotes = [];