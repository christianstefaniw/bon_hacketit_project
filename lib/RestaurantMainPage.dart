import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

import 'Orders.dart';
import 'RestaurantOrCustomer.dart';

TextEditingController textControllerName = new TextEditingController();
var numItems = 1;

class RestaurantMainPage extends StatefulWidget {
  @override
  RestaurantMainPageState createState() => RestaurantMainPageState();
}


class RestaurantMainPageState extends State<RestaurantMainPage> {
  File file;
  File logo = File("");
  var nameUploaded = false;
  var defaultImage;
  List values = ['', ''];
  String uploadedFileURL = 'No image uploaded';
  FirebaseDatabase database = new FirebaseDatabase();
  final databaseReference =
      FirebaseDatabase.instance.reference().child("Restaurant's");
  TextEditingController textControllerItems = new TextEditingController();
  TextEditingController textControllerPrice = new TextEditingController();

  Future getFile() async {
    var filePicked = await FilePicker.getFile(
        type: FileType.custom, allowedExtensions: ['pdf']);
    setState(() {
      file = filePicked;
    });
  }

  Future getLogo() async {
    var filePicked = await FilePicker.getFile(type: FileType.image);
    setState(() {
      logo = filePicked;
    });
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('Menus/${Path.basename(file.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        uploadedFileURL = fileURL;
        values[0] = uploadedFileURL;
        values[1] = textControllerName.text;
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewQR(uploadedFileURL, logo, values),
            ));
      });
    });
  }

  void pushRecord() {
    databaseReference.child(textControllerName.text + '/value').set({
      'value': numItems,
    });

    databaseReference.child(textControllerName.text + '/item$numItems').set({
      'product': textControllerItems.text,
      'cost': textControllerPrice.text,
    });
    numItems++;
    textControllerPrice.text = '';
    textControllerItems.text = '';
  }

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      defaultImage = Image.asset("");
    } else {
      defaultImage = Image.asset(
        "assets/images/pdf.jpg",
        width: 100,
        height: 175,
      );
    }
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => RestaurantOrCustomer()))),
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Create eMenu',
          style: GoogleFonts.sourceSansPro(
            textStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.scanner),
            color: Colors.black,
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Orders())),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: textControllerName,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          hintText: "Enter your restaurant's name",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    RaisedButton(
                      child: Text('Upload'),
                      onPressed: () => setState(() {
                        nameUploaded = true;
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Container(
                      width: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: TextField(
                          controller: textControllerPrice,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            hintText: "Price",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      controller: textControllerItems,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        hintText: 'Item',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text('Upload Menu Item'),
                    onPressed:
                        nameUploaded == false ? null : () => pushRecord(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: RaisedButton(
                child: Text('Choose your menu'),
                onPressed: getFile,
              ),
            ),
            Material(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LargeImage(file)),
                  );
                },
                child: Container(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: defaultImage),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    child: Text('Choose your logo'),
                    onPressed: getLogo,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Image.file(logo),
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    child: Text('Upload Menu'),
                    onPressed: file == null ? null : uploadFile,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class ViewQR extends StatelessWidget {
  final String url;
  final File logo;
  final List data;

  ViewQR(this.url, this.logo, this.data);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'QR Code',
          style: GoogleFonts.sourceSansPro(
            textStyle:
            TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
          ),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: Center(
        child: Container(
          height: 220,
          child: QrImage(
            data: data.toString(),
            version: QrVersions.auto,
            embeddedImage: FileImage(logo),
            embeddedImageStyle: QrEmbeddedImageStyle(size: Size(30, 30)),
          ),
        ),
      ),
    );
  }
}

class LargeImage extends StatefulWidget {
  final File file;

  LargeImage(this.file);

  @override
  _LargeImageState createState() => _LargeImageState();
}

class _LargeImageState extends State<LargeImage> {
  bool loading = true;
  PDFDocument document;
  var num = 0;

  getPDF() async {
    setState(() {
      loading = true;
    });
    document = await PDFDocument.fromFile(widget.file);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (num == 0) {
      getPDF();
      num++;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selected PDF',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : PDFViewer(
              document: document,
            ),
    );
  }
}
