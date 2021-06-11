import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/components.dart';
import 'package:todo/bloc/firebase_bloc.dart';

class Notes extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FirebaseBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('notesDatabase').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (!streamSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var temp = streamSnapshot.data!
                        .docs[streamSnapshot.data!.docs.length - index - 1];
                    return CustomCard(
                      isTrash: false,
                      actionIcon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
                      snackbarMessage: 'Moved to Trash',
                        bloc: bloc,
                        temp: temp,
                        addEvent: AddTrashEvent(temp: temp),
                        deleteEvent: DeleteNoteEvent(id: temp.id));
                  });
            }),
      ),
    );
  }
}
