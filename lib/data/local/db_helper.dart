import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{

  //private Constructor
  DbHelper._();

  //singleton function
  static final DbHelper getInstances = DbHelper._();
  static final String tableNote = "NoteApp";
  static final String tableNoteColSNo = "s_no";
  static final String tableNoteColTitle = "title";
  static final String tableNoteColDesc = "desc";

  Database? myDb;
  Future<Database> getDb()async{
    myDb ??=  await openDb();
    return myDb!;
  }

  Future<Database> openDb()async{
    Directory myDirectory = await getApplicationDocumentsDirectory();

    String rootPath =  myDirectory.path;

    String myPath = join(rootPath,"notes.db");

   return await openDatabase(myPath,version: 1,onCreate: (db,version){
      db.rawQuery("create table $tableNote ( $tableNoteColSNo integer primary key autoincrement ,$tableNoteColTitle text , $tableNoteColDesc text )");
    });
  }

  //insert
   Future<bool> addNote({required String title,required String desc})async{
    var db = await getDb();
    int rowCount = await db.insert(tableNote, {
      tableNoteColTitle: title,
      tableNoteColDesc: desc
    }
    );
    return rowCount>0;
   }

   //get All Note
    Future<List<Map<String,dynamic>>> getNote()async{
    var db = await getDb();
    var allNotes = await db.query(tableNote);
    return allNotes;
    }

    //delete
    Future<bool> removeNote({required int s_no})async{
    var db = await getDb();
    int count = await db.delete(tableNote,
    where: '$tableNoteColSNo = $s_no'
    );
    return count<0;
    }

    //update
    Future<bool> updateNote({required int s_no,required String title,required String desc})async{
    var db = await getDb();
    int count = await db.update(tableNote, {
      tableNoteColTitle : title,
      tableNoteColDesc : desc
    },where: '$tableNoteColSNo = ?',
      whereArgs: ['$s_no']
    );
    return count > 0;
    }
}