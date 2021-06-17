import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/firebase_bloc.dart';
import 'package:todo/main.dart';
import '../components.dart';

class Trash extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FirebaseBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Trash'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: MyApp.isOnline?
         StreamBuilder<QuerySnapshot>(
            stream: BlocProvider.of<FirebaseBloc>(context).getTrashStream(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (!streamSnapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (streamSnapshot.hasError)
                return Center(child: Text('An Error has occured!, retry again'));
              return streamSnapshot.data!.docs.length == 0?
                Center(child: Text('Nothing to show, Try Adding notes'),) : 
              ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var temp = streamSnapshot.data!
                        .docs[streamSnapshot.data!.docs.length - index - 1];
                    return CustomCard(bloc: bloc, temp: temp, addEvent: AddNoteEvent(temp: temp), deleteEvent: DeleteTrashEvent(id: temp.id),snackbarMessage: 'Restored!',actionIcon: Icon(
                            Icons.restore,
                            color: Colors.blue,
                          ), isTrash: true, );
                  });
            })
            :
            FutureBuilder<List<Map<String, dynamic>>>(
              future: bloc.allTrashDB(),
              builder: (context, snapshot){
                if(snapshot.hasData)
                {
                  return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var temp = snapshot.data![snapshot.data!.length - index -1];
                    return Card(
                      elevation: 2,
                        child: ListTile(
                        title: Text(temp['Title']),
                        subtitle: Text(temp['Description']),
                        trailing: Icon(Icons.wifi_off),
                      ),
                    );
                  }
                  );
                }
                else if(snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else{
                return Center(child: Text('Error! please try Again'));
              }
              },
            )

      ),
    );
  }
}