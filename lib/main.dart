import 'package:flutter/material.dart';
import 'screens/card_list.dart';
import 'screens/note_list.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Builder(
        builder:(context)=> Scaffold(
          appBar: AppBar(title:Text('Capture : Notes and Cards Scanner')),
          backgroundColor: Colors.blueAccent,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[

                  SizedBox(height: 150,),

                  Center(
                    child: ListTile(
                        title: RaisedButton(onPressed:()=> Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>CardList())),
                          elevation: 20,
                          padding: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          color: Colors.greenAccent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height:70),
                              Icon(Icons.card_membership,size: 40,color: Colors.black,),
                              SizedBox(width: 15,),
                              Text("MY CARDS",style: TextStyle(fontSize: 32,color: Colors.black,fontWeight: FontWeight.bold,),)
                            ],
                          ),)
                    ),
                  ),

                  SizedBox(height: 30,),

                  Center(
                    child: ListTile(
                        title: RaisedButton(onPressed:()=> Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>NoteList())),
                          elevation: 20,
                          padding: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          color: Colors.redAccent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height:70),
                              Icon(Icons.event_note,size: 40,color: Colors.black,),
                              SizedBox(width: 15,),
                              Text("MY NOTES",style: TextStyle(fontSize: 32,color: Colors.black,fontWeight: FontWeight.bold,),)
                            ],
                          ),
                        ),
                    ),
                  ),
                  SizedBox(height: 100,),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "This App is made by",
                            style: TextStyle(fontSize: 28.0,fontWeight: FontWeight.bold,color: Colors.black),
                          ),
                          SizedBox(height: 5.0,),
                          Text(
                            "Kunal Raut",
                            style: TextStyle(fontSize: 35.0,fontWeight: FontWeight.bold,color: Colors.black),
                          ),
                          SizedBox(height: 30.0,),
                          Text(
                            "Hope You Like it ",
                            style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.black),
                          ),
                          SizedBox(height: 5.0,),
                          Text(
                            "and find it useful !",
                            style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
