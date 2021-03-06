import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:ryta_app/services/auth.dart';
import 'package:ryta_app/shared/constants.dart';
import 'package:ryta_app/shared/loading.dart';
import 'package:ryta_app/widgets/reset_password.dart';
import 'package:url_launcher/url_launcher.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';
  bool forgottenPasswordOption = false;

  @override
  Widget build(BuildContext context) {

    return loading
        ? Loading(Colors.white, Color(0xFF995C75))
        : NotificationListener<OverscrollIndicatorNotification>(
            // disabling a scroll glow
            // ignore: missing_return
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: Colors.white,
              // appBar: AppBar(
              //   backgroundColor: Colors.blue,
              //   title: Text('New to Ryta? Sign in!'),
              // ),
              body: ListView(
                children: [
                  SizedBox(height: 40.0),
                  Image.asset(
                    "assets/ryta_logo.png",
                    height: 150,
                    // width: 100,
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45.0),
                      child: Column(
                        children: <Widget>[
                          // Input email (panel)
                          SizedBox(height: 10.0),
                          TextFormField(
                              initialValue: email,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(
                                    r'[a-zA-Z0-9!@#$%^&*(),.?":{}|<>/_/-]'))
                              ],
                              keyboardType: TextInputType.text,
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Email'),
                              validator: (val) =>
                                  val.isEmpty ? 'Enter an email address' : null,
                              onChanged: (val) {
                                setState(() => email = val);
                              }),
                          // Input password (panel)
                          SizedBox(height: 10.0),
                          TextFormField(
                              obscureText: true,
                              decoration: textInputDecoration.copyWith(
                                  errorMaxLines: 3, hintText: 'Password'),
                              validator: (val) => val.length < 6
                                  ? 'Enter a password 6+ characters long, with at least letter and one digit'
                                  : null,
                              onChanged: (val) {
                                setState(() => password = val);
                              }),
                          //forgotten password?
                          if (forgottenPasswordOption == true)
                            ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all<double>(0),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 15.0)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey),
                                // shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                //         side: BorderSide(color: Colors.grey, width: 1.0),
                                //         borderRadius: BorderRadius.circular(15.0))),
                              ),
                              child: Text(
                                'FORGOT PASSWORD?',
                                //style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                _scaffoldKey.currentState.showBottomSheet(
                                    (context) => ResetPassword(email));
                              },
                              //bottom sheet to enter an email..
                            ),

                          // Implementation of the log in button.
                          if (forgottenPasswordOption == false)
                            SizedBox(height: 20.0),
                          ElevatedButton(
                              child: Text(
                                'LOG IN',
                                //style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                setState(() {
                                  forgottenPasswordOption = true;
                                });
                                if (_formKey.currentState.validate()) {
                                  setState(() => loading = true);
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email, password);

                                  if (result == null) {
                                    setState(() {
                                      error = 'Email or password not correct';
                                      loading = false;
                                    });
                                  }
                                }
                              }),
                          // Implementation of the register button.
                          SizedBox(height: 8.0),
                          ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all<double>(0),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 15.0)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFF995C75)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color(0xFF995C75),
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(15.0))),
                              ),
                              child: Text(
                                'REGISTER',
                                //style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                widget.toggleView();
                              }),
                          Row(children: <Widget>[
                            Expanded(
                              child: new Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 15.0),
                                  child: Divider(
                                    color: Colors.black,
                                    height: 50,
                                  )),
                            ),
                            Text("OR"),
                            Expanded(
                              child: new Container(
                                  margin: const EdgeInsets.only(
                                      left: 15.0, right: 10.0),
                                  child: Divider(
                                    color: Colors.black,
                                    height: 50,
                                  )),
                            ),
                          ]),
                          SignInButton(
                            Buttons.Google,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(color: Colors.grey)),
                            padding: EdgeInsets.fromLTRB(10, 5, 15, 5),
                            text: "CONTINUE WITH GOOGLE",
                            onPressed: () {
                              //LOGIN USING GOOGLE HERE
                              Loading.showLoading(context);

                              // AuthService authService = new AuthService();
                              var user = _auth.googleSignIn();

                              //Pop the loading
                              Navigator.of(context).pop(false);

                              //Check if the login was successful
                              if (user == null)
                                // {
                                //Login failed
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // return object of type Dialog
                                    return AlertDialog(
                                      title: Text("Failed to log in!"),
                                      content: Text(
                                          "Please make sure your Google Account is usable. Also make sure that you have a active internet connection, and try again."),
                                      actions: <Widget>[
                                        // usually buttons at the bottom of the dialog
                                        new ElevatedButton(
                                          child: new Text("Close"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              // } else {
                              //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
                              // }
                            },
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "By continuing, you agree to our ",
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'CenturyGothic',
                              fontSize: 12.0),
                        ),

                        // ignore: todo
                        // TODO: make the link work!!!
                        TextSpan(
                            text: "Terms of Use",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF995C75),
                                fontFamily: 'CenturyGothic',
                                fontSize: 12.0),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                var url = 'https://en.ryta.eu/agb';
                                if (await canLaunch(url)) {
                                  await launch(url.toString());
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }),
                        TextSpan(
                          text: " and ",
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'CenturyGothic',
                              fontSize: 12.0),
                        ),

                        TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF995C75),
                                fontFamily: 'CenturyGothic',
                                fontSize: 12.0),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url = 'https://en.ryta.eu/datenschutz';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

// body: ListView(
//   padding: EdgeInsets.all(24),
//   children: [
//     //Sub title
//     Text(
//       "Login with Google\n\nThis helps us to save your preferences and make this app sync across devices",
//       textAlign: TextAlign.start,
//     ),

//     //Illustration
//     Image.asset("assets/images/levitate.gif"),

//     SizedBox(height: 50),

//     //Google Login button
//     Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         RaisedButton(
//           padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.network(
//                 "https://www.freepnglogos.com/uploads/google-logo-png/google-logo-icon-png-transparent-background-osteopathy-16.png",
//                 height: 30,
//                 width: 30,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Text("Login with Google", style: TextStyle(color: Colors.white)),
//               ),
//             ],
//           ),
//           onPressed: () {
//             //LOGIN USING GOOGLE HERE
//             Utility.showLoading(context);

//             AuthService authService = new AuthService();
//             var user = authService.googleSignIn();

//             //Pop the loading
//             Navigator.of(context).pop(false);

//             //Check if the login was successful
//             if (user == null) {
//               //Login failed
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   // return object of type Dialog
//                   return AlertDialog(
//                     title: Text("Failed to log in!"),
//                     content: Text(
//                         "Please make sure your Google Account is usable. Also make sure that you have a active internet connection, and try again."),
//                     actions: <Widget>[
//                       // usually buttons at the bottom of the dialog
//                       new FlatButton(
//                         child: new Text("Close"),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   );
//                 },
//               );
//             } else {
//               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
//             }
//           },
//         ),
//       ],
//     ),
//   ],
// ),
