import 'package:flutter/material.dart';
import 'dart:async';
import 'package:text_recognition_ocr/model/card_structure.dart';
import 'package:text_recognition_ocr/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:text_recognition_ocr/screens/card_detector.dart';

class CardList extends StatefulWidget {
  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Cardone> cardList;
  int count = 0;


  @override
  Widget build(BuildContext context) {
    if (cardList == null) {
      cardList = List<Cardone>();
      updateListView();
    }

    return Scaffold(

      appBar: AppBar(
        title: Text('Cards'),
      ),
      backgroundColor: Colors.white,
      body: getNoteListView(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          //navigateToDetail(Note('', '', 2), 'Add Note');
          navigateToDetail(Cardone('','','','',''));
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
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: GestureDetector(
            onTap: (){return navigateToDetail(this.cardList[position]);},
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10.0,top:5.0,bottom: 5.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(this.cardList[position].name,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                    trailing: GestureDetector(
                      child: Icon(Icons.delete, color: Colors.red,size: 25.0,),
                      onTap: () {
                      _delete(context, cardList[position]);
                      },
                    ),
                  ),

                  (this.cardList[position].company_name!="")?ListTile(
                    leading: Icon(Icons.business,color: Colors.black,),
                    title: Text(this.cardList[position].company_name,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black,),),
                  ):Container(),

                  (this.cardList[position].mobile!="")?ListTile(
                    leading: Icon(Icons.phone,color: Colors.black,),
                    title: Text(this.cardList[position].mobile,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black,),),
                  ):Container(),

                  (this.cardList[position].emailid!="")?ListTile(
                    leading: Icon(Icons.mail,color: Colors.black,),
                    title: Text(this.cardList[position].emailid,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black,),),
                  ):Container(),

                  (this.cardList[position].website!="")?ListTile(
                    leading: Icon(Icons.near_me,color: Colors.black,),
                    title: Text(this.cardList[position].website,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black,),),
                  ):Container(),

                ],
              ),
            ),
          )
        );

      },
    );
  }

  void navigateToDetail(Cardone note) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) {
      return MyCardPage(note);
    }));
    if (result == true) {
      updateListView();
    }
  }

  void _delete(BuildContext context, Cardone card) async {

    int result = await databaseHelper.deleteCard(card.id);
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

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Cardone>> cardListFuture = databaseHelper.getCardList();
      cardListFuture.then((cardList) {
        setState(() {
          this.cardList = cardList;
          this.count = cardList.length;
        });
      });
    });
  }

}
