import 'package:appcomunity/login_flow/widgets/auth_page_title.dart';
import 'package:appcomunity/login_flow/widgets/button_sign_in.dart';
import 'package:appcomunity/login_flow/widgets/text_field.dart';
import 'package:flutter/material.dart';
final Color secondaryColor = Color(0xFFfff7f5);
final Color mainColor = Color(0xFFff7f5c);

class EmailAndPassword {
  final String email, password, userName, pis;
  EmailAndPassword(this.email, this.password, this.userName, this.pis);

  String get getterUserName {
    return this.userName;
  }

String get getterPis {
    return this.pis;
  }
  toString() => "Email: '$email' / Password: '$password'";

  
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _pis = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 100),
              AuthPageTitle('Sign Up'),
              SizedBox(height: 24),
              SignInTextField(SignInTextFieldType.email, _email),
              SizedBox(height: 24),
              SignInTextField(SignInTextFieldType.userName, _userName),
              SizedBox(height: 24),
              SignInTextField(SignInTextFieldType.pis, _pis),
              SizedBox(height: 24),
              SignInTextField(SignInTextFieldType.password, _password),
              SizedBox(height: 48),
              SignInButton(
                color: mainColor,
                text: 'Sign Up',
                onPressed: () {
                  Navigator.of(context).pop(
                    EmailAndPassword(
                        _email.text, _password.text, _userName.text, _pis.text),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
