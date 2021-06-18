import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/firebase_bloc.dart';
import 'package:todo/components.dart';
import 'package:todo/main.dart';

class NewNote extends StatefulWidget {
  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  String? title;
  String? description;
  String? videoLink;
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FirebaseBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('New Note'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
                      child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  onChanged: (value) {
                    title = value;
                  },
                  autofocus: true,
                  maxLength: 30,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: (value) {
                    description = value;
                  },
                  minLines: 1,
                  maxLines: 2,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Checkbox(
                            value: checked,
                            onChanged: (val) {
                              setState(() {
                                checked = val!;
                              });
                            }),
                        Text(
                          'Video',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: checked,
                                        child: Flexible(
                        child: TextFormField(
                          onChanged: (value) {
                            videoLink = value;
                          },
                          readOnly: !checked,
                          minLines: 1,
                          maxLines: 2,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: 'Video Link',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // if(!MyApp.isOnline)
                        // {
                        //   ScaffoldMessenger.of(context).showSnackBar(snackBar('No Internet'));
                        //   return;
                        // }
                        if (title != '' && title != null) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar('Saved!'));
                          bloc.add(CreateNewNotesEvent(
                              hasVideo: checked,
                              videoLink: checked?videoLink.toString():'null',
                              title: title!, des: description!));
                          bloc.add(NewNoteDB(title: title!, des: description!));
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar('Title cannot be null'));
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
