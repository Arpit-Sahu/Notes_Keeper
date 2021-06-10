import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/firebase_bloc.dart';

class Trash extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FirebaseBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Trash'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('TrashDatabase').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (!streamSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        onTap: () {
                          final snackBar = SnackBar(
                          content: Text('Cannot edit while on Trash!', textAlign: TextAlign.center,),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        title: Text(streamSnapshot.data!.docs[
                                streamSnapshot.data!.docs.length - index - 1]
                            ['Title']),
                        subtitle: Text(streamSnapshot.data!.docs[
                                streamSnapshot.data!.docs.length - index - 1]
                            ['Description']),
                        trailing: GestureDetector(
                          onTap: () {
                            final snackBar = SnackBar(
                              content: Text(
                                'Restored!',
                                textAlign: TextAlign.center,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            var temp = streamSnapshot.data!.docs[
                                streamSnapshot.data!.docs.length - index - 1];

                            bloc.add(AddNoteEvent(temp: temp));
                            String id = streamSnapshot
                                .data!
                                .docs[streamSnapshot.data!.docs.length -
                                    index -
                                    1]
                                .id;

                            bloc.add(DeleteTrashEvent(id: id));
                          },
                          child: Icon(
                            Icons.restore,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
