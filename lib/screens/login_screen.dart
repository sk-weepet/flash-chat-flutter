import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/Model/user_data.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/provider/user_provider.dart';
// import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'chat_screen.dart';
import 'tap_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // keyboard 입력시 화면 깨지는거 flexible하게 조정
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log In',
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                    if (user != null) {
                      // Navigator.pushNamed(context, ChatScreen.id);
                      Navigator.pushNamed(context, TapScreen.id);
                      // Navigator.pushNamedAndRemoveUntil(context, ChatScreen.id, (route) => route.settings.name == WelcomeScreen.id);
                    }

                    QuerySnapshot docs = await Firestore.instance.collection("users").where("email", isEqualTo: email).getDocuments();
                    // FirebaseUser loggedInUser = await FirebaseAuth.instance.currentUser();
                    // DocumentSnapshot doc = await Firestore.instance.collection("users").document(loggedInUser.uid).get();
                    // UserProvider.instance.userData = UserData.fromFirebase(doc);

                    // 바로 위 docs가 아직 data가 없기 때문에 null
                    UserProvider.instance.userData = UserData.fromFirebase(docs.documents[0]);

                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                  // Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
