import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/firebase_bloc.dart';
import '../components.dart';

class EditNote extends StatelessWidget {
  String? title;
  String? des;
  String? id;
  final bool isTrash;
  EditNote({required this.title, required this.des, required this.id, required this.isTrash});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FirebaseBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                readOnly: isTrash,
                onTap: ()
                {
                  if(isTrash)
                    ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar('Cannot edit trash note'));
                },
                initialValue: title,
                onChanged: (value) {
                  title = value;
                },
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
                readOnly: isTrash,
                onTap: ()
                {
                  if(isTrash)
                    ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar('Cannot edit trash note'));
                },
                initialValue: des,
                onChanged: (value) {
                  des = value;
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
                height: 20,
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
                    onPressed: () {
                      print(title);
                      if (title != '' && title != null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar('Saved!'));
                        bloc.add(
                            UpdateNoteEvent(id: id!, title: title!, des: des!));
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar('Title cannot be null'));
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
    );
  }
}
