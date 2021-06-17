import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:todo/Screens/EditNote.dart';
import 'package:todo/bloc/firebase_bloc.dart';
import 'package:todo/main.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    required this.bloc,
    required this.temp,
    required this.addEvent,
    required this.deleteEvent,
    required this.snackbarMessage,
    required this.actionIcon,
    required this.isTrash,
  }) : super(key: key);

  final FirebaseBloc bloc;
  final QueryDocumentSnapshot<Object?> temp;
  final addEvent;
  final deleteEvent;
  final String snackbarMessage;
  final Icon actionIcon;
  final bool isTrash;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: Duration(seconds: 1),
      openBuilder: (context, _) =>
          EditNote(title: temp['Title'], des: temp['Description'], id: temp.id, isTrash: isTrash,
          hasVideo: temp['HasVideo'], videoLink: temp['HasVideo']?temp['VideoLink']:null 
          ,),
      closedBuilder: (context, VoidCallback openContainer) => Card(
        elevation: 2,
        child: ListTile(
          onTap: openContainer,
          title: Text(temp['Title']),
          subtitle: Text(
            temp['Description'],
            overflow: TextOverflow.ellipsis,
          ),
          trailing:
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Visibility(
              visible: temp['HasVideo'],
              child: Icon(Icons.play_arrow)),
            GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(snackBar(snackbarMessage));
              bloc.add(addEvent);

              bloc.add(deleteEvent);
            },
            child: actionIcon,
          ),
          ],)
           
        ),
      ),
    );
  }
}

SnackBar snackBar(String message) {
  return SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
    ),
  );
}

Future<void> getConnectionStatus() async{
    var connectionStatus = await Connectivity().checkConnectivity();
    print(connectionStatus.toString());
    // MyApp.isOnline = false;
    if(connectionStatus.toString() == 'ConnectivityResult.none')
    MyApp.isOnline = false;
    else
    MyApp.isOnline = true;
  }