import 'package:flutter/material.dart';
import 'dart:async';
import 'package:text_recognition_ocr/model/note_structure.dart';
import 'package:text_recognition_ocr/utils/database_helper_note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:text_recognition_ocr/screens/note_detector.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  DatabaseHelperNote databaseHelperNote=DatabaseHelperNote();
  List<Note>noteList;
  int count=0;

  @override
  Widget build(BuildContext context) {
    if(noteList==null)
    {
      noteList=List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        leading: IconButton(icon: Icon(
            Icons.arrow_back),
            onPressed: () {
              // Write some code to control things, when user press back button in AppBar
              Navigator.pop(context);
            }
        ),
      ),

      body: getNoteListView(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          //navigateToDetail(Note('', '', 2), 'Add Note');
          navigateToDetail(Note('',''));
        },

        tooltip: 'Add Card',

        child: Icon(Icons.add),

      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme
        .of(context)
        .textTheme
        .title;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {

        return Card(
          color: Colors.white,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(15.0),
            leading: CircleAvatar(
              child: Icon(Icons.description),
            ),

            title: Text(this.noteList[position].title, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),),

            //subtitle: Text(this.noteList[position].description),

            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.red,size: 35.0,),
              onTap: () {
                _delete(context, noteList[position]);
              },
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.noteList[position]);
            },
          ),
        );

      },
    );
  }
  void navigateToDetail(Note note) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) {
      return MyNotePage(note);
    }));
    if (result == true) {
      updateListView();
    }
  }

  void _delete(BuildContext context, Note card) async {

    int result = await databaseHelperNote.deleteCard(card.id);
    if (result != 0) {
      _showSnackBar(context, 'Card Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {

    final Future<Database> dbFuture = databaseHelperNote.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Note>> cardListFuture = databaseHelperNote.getCardList();
      cardListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

}

