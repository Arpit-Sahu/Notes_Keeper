import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:todo/Screens/EditNote.dart';
import 'package:todo/bloc/firebase_bloc.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    required this.bloc,
    required this.temp,
    required this.addEvent,
    required this.deleteEvent,
    required this.snackbarMessage,
    required this.actionIcon,
  }) : super(key: key);

  final FirebaseBloc bloc;
  final QueryDocumentSnapshot<Object?> temp;
  final addEvent;
  final deleteEvent;
  final String snackbarMessage;
  final Icon actionIcon;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionDuration: Duration(seconds: 1),
      openBuilder: (context, _) =>
          EditNote(title: temp['Title'], des: temp['Description'], id: temp.id),
      closedBuilder: (context, VoidCallback openContainer) => Card(
        elevation: 5,
        child: ListTile(
          onTap: openContainer,
          title: Text(temp['Title']),
          subtitle: Text(
            temp['Description'],
            overflow: TextOverflow.ellipsis,
          ),
          trailing: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(snackBar(snackbarMessage));
              bloc.add(addEvent);

              bloc.add(deleteEvent);
            },
            child: actionIcon,
        ),
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
