import 'package:flutter/material.dart';
import 'package:text_recognition_ocr/model/note_structure.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:text_recognition_ocr/utils/database_helper_note.dart';

class MyNotePage extends StatefulWidget {
  final Note note;
  MyNotePage(this.note);
  @override
  _MyNotePageState createState() => _MyNotePageState(this.note);
}

class _MyNotePageState extends State<MyNotePage> {

  File pickedImage;

  bool isImageLoaded = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  DatabaseHelperNote databaseHelperNote=DatabaseHelperNote();
  Note note;

  _MyNotePageState(this.note);

  Future pickImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      pickedImage = tempStore;
      isImageLoaded = true;
    });
  }

  Future clickImage() async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      pickedImage = tempStore;
      isImageLoaded = true;
    });
  }

  Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);


//    for (TextBlock block in readText.blocks) {
//      for (TextLine line in block.lines) {
//        for (TextElement word in line.elements) {
//
//        }
//      }
//    }

    setState(() {
      descriptionController.text=readText.text;
      note.description=readText.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = note.title;
    descriptionController.text = note.description;

    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    if(note.id!=null)
      height=2*height;

    return Scaffold(
        appBar: AppBar(
          title: Text('Add Note'),
          leading: IconButton(icon: Icon(
              Icons.arrow_back),
              onPressed: () {
                // Write some code to control things, when user press back button in AppBar
                moveToLastScreen();
              }
          ),
        ),
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(

          child: Column(
            children: <Widget>[

              SizedBox(height: 20.0),

              (note.id==null)?ScanWidget():Container(),

              SizedBox(height: 40.0),

              Padding(
                padding: EdgeInsets.all(15.0),
                child: TextField(
                  controller: titleController,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22.0),
                  onChanged: (value) {
                    debugPrint('Something changed in Title Text Field');
                    updateTitle();
                  },
                  decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                  ),
                ),
              ),

              SizedBox(height: 20.0),

              Padding(
                padding: new EdgeInsets.only(left:15.0,right:15.0,bottom:0.0,top:10.0),
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  color: Colors.black12,
                  child: new ConstrainedBox(
                    constraints: new BoxConstraints(
                      minWidth: width,
                      maxWidth: width,
                      minHeight: 150.0,
                      maxHeight: height/3,
                    ),

                    child: new SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      reverse: true,

                      // here's the actual text box
                      child: new TextField(
                        style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),
                        onChanged: (value) {
                          debugPrint('Something changed in Title Text Field');
                          updateDescription();
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: null, //grow automatically
                        controller: descriptionController,
                        decoration: new InputDecoration.collapsed(
                          hintText: 'Please Pick a Image to show Result',
                        ),
                      ),
                      // ends the actual text box
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.0),

              Center(
                child: ListTile(
                    title: RaisedButton(onPressed:_save,
                      elevation: 10,
                      padding: EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      color: Colors.greenAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height:50),
                          Icon(Icons.done_all,size: 40,color: Colors.black,),
                          SizedBox(width: 15,),
                          Text("SAVE",style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold,),)
                        ],
                      ),)
                ),
              ),

              SizedBox(height: height/3,),

            ],

          ),
        )
    );
  }

  Widget ScanWidget(){
    return Column(
      children: <Widget>[
        Center(
            child: isImageLoaded?Container(
                height: 200.0,
                width: 200.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(pickedImage), fit: BoxFit.cover)))
                :Container()),

        SizedBox(height: 30.0),

        Center(
            child: ListTile(
                title: RaisedButton(onPressed:pickImage,
                  elevation: 10,
                  padding: EdgeInsets.all(5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height:50),
                      Icon(Icons.photo,size: 40,color: Colors.black,),
                      SizedBox(width: 15,),
                      Text("PICK IMAGE FROM GALLERY",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold,),)
                    ],
                  ),)
            ),
          ),

        Center(
          child: ListTile(
              title: RaisedButton(onPressed:clickImage,
                elevation: 10,
                padding: EdgeInsets.all(5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height:50),
                    Icon(Icons.camera_alt,size: 40,color: Colors.black,),
                    SizedBox(width: 15,),
                    Text("CLICK IMAGE FROM CAMERA",style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold,),)
                  ],
                ),)
          ),
        ),

        (isImageLoaded)?Center(
          child: ListTile(
              title: RaisedButton(onPressed:readText,
                elevation: 10,
                padding: EdgeInsets.all(5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                color: Colors.greenAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height:50),
                    Icon(Icons.check_circle,size: 40,color: Colors.black,),
                    SizedBox(width: 15,),
                    Text("READ TEXT",style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold,),)
                  ],
                ),)
          ),
        ):Container(),
      ],
    );
  }
  void moveToLastScreen() {
    Navigator.pop(context,true);
  }

  // Save data to database
  void _save() async {

    updateTitle();
    updateDescription();
    moveToLastScreen();
    int result;

    if(note.id!=null)
      result=await databaseHelperNote.updateCard(note);
    else
      result = await databaseHelperNote.insertCard(note);

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }

  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

  void updateTitle(){
    note.title = titleController.text;
  }
  void updateDescription(){
    note.description=descriptionController.text;
  }
}
