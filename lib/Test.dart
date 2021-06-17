import 'package:flutter/material.dart';
import 'package:todo/dataBase/databaseHelper.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ElevatedButton(onPressed: ()async{
              int i = await DatabaseHelper.instance.insertNote({
                DatabaseHelper.title : 'note2',
                DatabaseHelper.description : 'offline',
              });
              print(i);
            }, child: Text('Add Note')),


            ElevatedButton(onPressed: ()async{
              List<Map<String, dynamic>> queryRow = await DatabaseHelper.instance.queryAllNotes();
              print(queryRow);
            }, child: Text('Print Note')),


            ElevatedButton(onPressed: ()async{
              List<Map<String, dynamic>> queryRow = await DatabaseHelper.instance.queryAllTrash();
              print(queryRow);
            }, child: Text('Print Trash')),


            ElevatedButton(onPressed: ()async{
              int i = await DatabaseHelper.instance.moveToTrash('note2');
              print(i);
            }, child: Text('moveTo Trash')),


            ElevatedButton(onPressed: ()async{
              int i = await DatabaseHelper.instance.moveToNotes('note2');
              print(i);
            }, child: Text('MoveTo Notes')),
          ],
        ),
      ),
    );
  }
}