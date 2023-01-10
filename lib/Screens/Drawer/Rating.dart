import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mahuva_azadari/Models/Round%20Button.dart';

import '../../Models/Hexa color.dart';
import 'package:store_redirect/store_redirect.dart';

class ratingStar extends StatefulWidget {
  const ratingStar({Key? key}) : super(key: key);

  @override
  State<ratingStar> createState() => _ratingStarState();
}

class _ratingStarState extends State<ratingStar> {

  TextEditingController _feedbackController = TextEditingController();
  String? feedBack;
  late double ratingValue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
        backgroundColor: Color(hexColors('006064')),
        title: Text(
          "Rate Us",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            //color: Colors.black
          ),
        ),
        centerTitle: true,
      ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.favorite,
                    color: Colors.pink,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                    ratingValue = rating;
                    print(ratingValue);
                  },
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    //fontStyle: FontStyle.italic,
                    fontSize: 18
                ),
                controller: _feedbackController,
                decoration:InputDecoration(
                  hintText: "Comment",
                  labelText: "Comment",
                ),
                onChanged: (value) {
                feedBack = value;
              },
              ),
              SizedBox(height: 10,),
              RoundButton(title: "Submit",
                  onPress: (){
                FocusManager.instance.primaryFocus?.unfocus();
                StoreRedirect.redirect(
                  androidAppId: "com.example.mahuva_azadari"
                );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
