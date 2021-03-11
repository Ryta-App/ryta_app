import 'package:flutter/material.dart';
import 'package:ryta_app/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   title: Text('New to Ryta? Sign in!'),
      // ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 230.0, horizontal: 70.0),
        children: [
          Image.asset("assets/ryta_logo.png"),

          ElevatedButton(
          child: Text('Sign in anon'),
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if (result == null) {
              print('error signing in');
            } else {
              print('signed in');
              print(result.uid);
            }
          }
          ),
        ],
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