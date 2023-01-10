import 'package:flutter/material.dart';
import '../../Models/Hexa color.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';


class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {

  bool _isLoading = true;
  late PDFDocument document;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDocument();
  }
  loadDocument() async {
    document = await PDFDocument.fromAsset('assets/calender1.pdf');
    PDFViewer(document: document);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
      backgroundColor: Color(hexColors('006064')),
      title: Text(
        "Calender",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          //color: Colors.black
        ),
      ),
      centerTitle: true,
    ),
          body: Center(
            child: _isLoading ? CircularProgressIndicator()
            :
            PDFViewer(
              document: document,
              zoomSteps: 1,
            ),
          ),

    )
    );
  }


}
