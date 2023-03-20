import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mahuva_azadari/Models/Round%20Button.dart';
import '../../Models/Hexa color.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  TextEditingController _subjectController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  String? _subject;
  String? _body;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text("Contact Us",
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25
      ),),
      centerTitle: true,
      backgroundColor: Color(hexColors('006064')),
      ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    maxLength: 60,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18
                    ),
                    controller: _subjectController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Enter Subject",
                      hintText: "Subject",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white),
                      )
                    ),
                    onChanged: (value) {
                      _subject = value;
                    },
                    validator: (value) {
                      return value!.trim().isEmpty ? 'Enter Subject' : null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                    ),
                    controller: _bodyController,
                    //keyboardType: TextInputType.text,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: "Write some thing",
                        hintText: "Comments",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white),
                        )
                    ),
                    onChanged: (value) {
                      _body = value;
                    },
                    validator: (value) {
                      return value!.trim().isEmpty ? 'Write some text' : null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RoundButton(title: "Submit",
                      onPress: (){
                    //close keyboard
                        FocusManager.instance.primaryFocus?.unfocus();
                        if(_formkey.currentState!.validate()){
                          sendEmail(_subject.toString(), _body.toString(), "mohammadrajani5@gmail.com");
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendEmail(String subject,String body,String recipientemail) async{
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: [recipientemail],
      // cc: ['cc@example.com'],
      // bcc: ['bcc@example.com'],
      // attachmentPaths: ['/path/to/attachment.zip'],
      isHTML: false,
    );
    try{
      await FlutterEmailSender.send(email);
      await Future.delayed(Duration(seconds: 5));
      _subjectController.text = "";
      _bodyController.text = "";
      Navigator.pop(context);
    }catch(e){
      // Fluttertoast.showToast(msg: e.toString(),
      //     backgroundColor: Color(hexColors("006064")));
      Navigator.pop(context);
    }

    //await FlutterEmailSender.send(email);

  }


}
