import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:text_recognition_ocr/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:text_recognition_ocr/model/card_structure.dart';

class MyCardPage extends StatefulWidget {
  final Cardone card;
  MyCardPage(this.card);
  @override
  State<StatefulWidget> createState() {
    return _MyCardPageState(this.card);
  }
}

class _MyCardPageState extends State<MyCardPage> {

  File pickedImage;

  bool isImageLoaded = false;


  TextEditingController nameController = TextEditingController();
  TextEditingController company_nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailidController = TextEditingController();
  TextEditingController websiteController = TextEditingController();

  DatabaseHelper helper = DatabaseHelper();
  Cardone card;

  _MyCardPageState(this.card);

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

    String mobileno="",emailid="",website="",fullname="",companyname="";
    for (TextBlock block in readText.blocks) {

      for (TextLine line in block.lines) {

        int len=line.elements.length.toInt();

        RegExp name=RegExp(r'^[a-zA-Z\s]+$');
        RegExp company_name=RegExp(r'^[A-Z]([a-zA-Z0-9]|[- @\.#&!])*$');
        if(name.hasMatch(line.text) && fullname=="" && len>=2)
          fullname=line.text;
        else if(company_name.hasMatch(line.text) && companyname=="")
          companyname=line.text;

        for (TextElement word in line.elements) {
          RegExp email = RegExp(r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$');
          RegExp mobile = RegExp(r'^\+?\d[\d -]{8,12}\d$');
          RegExp websiteurl=RegExp(r'^((ftp|http|https):\/\/)?(www.)?(?!.*(ftp|http|https|www.))[a-zA-Z0-9_-]+(\.[a-zA-Z]+)+((\/)[\w#]+)*(\/\w+\?[a-zA-Z0-9_]+=\w+(&[a-zA-Z0-9_]+=\w+)*)?$');
          if (email.hasMatch(word.text) && emailid=="")
            emailid = word.text;
          else if (mobile.hasMatch(word.text) && mobileno=="")
            mobileno = word.text;
          else if(websiteurl.hasMatch(word.text) && website=="")
            website=word.text;
        }
      }
    }
    setState(() {
      mobileController.text=mobileno;
      emailidController.text=emailid;
      websiteController.text=website;
      nameController.text=fullname;
      company_nameController.text=companyname;

      card.mobile=mobileController.text;
      card.emailid=emailidController.text;
      card.website=websiteController.text;
      card.name=nameController.text;
      card.company_name=company_nameController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    nameController.text = card.name;
    company_nameController.text = card.company_name;
    mobileController.text = card.mobile;
    emailidController.text=card.emailid;
    websiteController.text=card.website;

    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    return Scaffold(
        appBar: AppBar(
          title: Text('Add Card'),
          leading: IconButton(icon: Icon(
              Icons.arrow_back),
              onPressed: () {
                // Write some code to control things, when user press back button in AppBar
                moveToLastScreen();
              }
          ),
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(

          child: Column(
            children: <Widget>[

              SizedBox(height: 20.0),

              (card.id==null)?ScanWidget():Container(),

              SizedBox(height: 20.0),

              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: nameController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Something changed in Title Text Field');
                    updateName();
                  },
                  decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: company_nameController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Something changed in Title Text Field');
                    updateCompanyName();
                  },
                  decoration: InputDecoration(
                      labelText: 'Post/Company Name',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: mobileController,
                  style: textStyle,
                  onChanged: (value) {
                  debugPrint('Something changed in Title Text Field');
                  updateMobile();
                },
                  decoration: InputDecoration(
                      labelText: 'Mobile No.',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: emailidController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Something changed in Title Text Field');
                    updateEmailid();
                  },
                  decoration: InputDecoration(
                      labelText: 'Email Id',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: websiteController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Something changed in Title Text Field');
                    updateWebsite();
                  },
                  decoration: InputDecoration(
                      labelText: 'Website',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
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

    updateName();
    updateCompanyName();
    updateMobile();
    updateEmailid();
    updateWebsite();
    moveToLastScreen();

    int result;

    if(card.id!=null)
      result=await helper.updateCard(card);
    else
      result = await helper.insertCard(card);

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Card Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Crad');
    }

  }

  void updateName(){
    card.name = nameController.text;
  }
  void updateCompanyName(){
    card.company_name = company_nameController.text;
  }
  void updateMobile(){
    card.mobile = mobileController.text;
  }
  void updateEmailid(){
    card.emailid = emailidController.text;
  }
  void updateWebsite(){
    card.website = websiteController.text;
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

}
