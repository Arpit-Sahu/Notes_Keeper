import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/Screens/EditNote.dart';
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
                      bloc: bloc,
                      temp: temp,
                    );
                  });
            }),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    required this.bloc,
    required this.temp,
  }) : super(key: key);

  final FirebaseBloc bloc;
  final QueryDocumentSnapshot<Object?> temp;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EditNote(
                title: temp['Title'], des: temp['Description'], id: temp.id);
          }));
        },
        title: Text(temp['Title']),
        subtitle: Text(
          temp['Description'],
          overflow: TextOverflow.ellipsis,
        ),
        trailing: GestureDetector(
          onTap: () {
            final snackBar = SnackBar(
              content: Text(
                'Moved to Trash',
                textAlign: TextAlign.center,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            bloc.add(AddTrashEvent(temp: temp));

            String id = temp.id;

            bloc.add(DeleteNoteEvent(id: id));
          },
          child: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
