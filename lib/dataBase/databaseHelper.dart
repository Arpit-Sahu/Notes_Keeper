import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper{

  static final _dbName = 'myDatabase.db';
  static final _dbVersion = 1;
  static final _notesTableName = 'notesDatabase';
  static final _trashTableName = 'TrashDatabase';

  static final title = 'Title';
  static final description  = 'Description';
  static final hasVideo = 'HasVideo';
  static final videoLink = 'VideoLink';

  DatabaseHelper._privateContructor();
  static final DatabaseHelper instance = DatabaseHelper._privateContructor();

  static Database? _database;
  Future<Database> get database async{
    if(_database!=null) return _database!;

    _database = await _initiateDatabas();
    return _database!;
  }

  _initiateDatabas () async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);

  }

  Future<void> _onCreate(Database db, int version) async
  {
    await db.execute(
      '''
      CREATE TABLE $_notesTableName ($title, $description, $hasVideo, $videoLink)
      '''
    );
    db.execute(
      '''
      CREATE TABLE $_trashTableName ( $title, $description, $hasVideo, $videoLink )
      '''
    );
  }

  Future<int> insertNote(Map<String,dynamic> row) async{
    Database db = await instance.database;
    return await db.insert(_notesTableName, row);
  }

  // Future<int> insertTrash(Map<String,dynamic> row) async{
  //   Database db = await instance.database;
  //   return await db.insert(_trashTableName, row);
  // }

  Future<List<Map<String, dynamic>>> queryAllNotes() async {
    Database db = await instance.database;
    return await db.query(_notesTableName);
  }

  Future<List<Map<String, dynamic>>> queryAllTrash() async {
    Database db = await instance.database;
    return await db.query(_trashTableName);
  }

  // Future<int> deleteNote(String id) async{
  //   Database db = await instance.database;
  //   return await db.delete(_notesTableName,where: '$title', whereArgs: [id]);
  // }

   Future<int> moveToTrash(String id) async{
    Database db = await instance.database;
    var item = await db.query(_notesTableName,where: '$title = ?', whereArgs: [id]);
    await db.delete(_notesTableName,where: '$title = ?', whereArgs: [id]);
    return await db.insert(_trashTableName, item[0]);
  }

  Future<int> moveToNotes(String id) async{
    Database db = await instance.database;
    var item = await db.query(_trashTableName,where: '$title = ?', whereArgs: [id]);
    await db.delete(_trashTableName,where: '$title = ?', whereArgs: [id]);
    return await db.insert(_notesTableName, item[0]);
  }

}