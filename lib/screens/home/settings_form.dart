import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/models/user_file.dart';
import 'package:ryta_app/screens/wrapper.dart';
import 'package:ryta_app/services/auth.dart';
import 'package:ryta_app/services/database.dart';
import 'package:ryta_app/shared/constants.dart';
import 'package:ryta_app/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart';

///Showing a personal settings and info
class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  double price = 0;

  double oneThird = 0;

  bool _checkboxListTile1 = false;
  bool _checkboxListTile2 = false;
  bool _checkboxListTile3 = false;
  bool _newsletterSubscription = true;
  // bool _checkboxListTile4 = false;
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<RytaUser>(context);
    final userfile = Provider.of<UserFile>(context);

    if (userfile == null)
      return Loading(Colors.white, Color(0xFF995C75));
    else
      oneThird = num.parse((userfile.priceInitialized / 3).toStringAsFixed(3));

    _newsletterSubscription = userfile.newsletterSubscription;

    if (userfile.willToPay == true) {
      _checkboxListTile1 = userfile.package1;
      _checkboxListTile2 = userfile.package2;
      _checkboxListTile3 = userfile.package3;
      // _checkboxListTile4 = userfile.package4;
      price = userfile.price;
    }

    return NotificationListener<OverscrollIndicatorNotification>(
      // disabling a scroll glow
      // ignore: missing_return
      onNotification: (overscroll) {
        overscroll.disallowGlow();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            // SizedBox(height: 20.0),
            // username
            Form(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, left: 30.0, right: 30.0, bottom: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.displayName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.0),
                        ),
                        SizedBox(width: 40.0),
                        // settings
                        IconButton(
                          icon: Icon(
                            Icons.settings,
                            color: Color(0xFF995C75),
                          ),
                          tooltip: 'Settings',
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                // title: Row(children: [
                                //   Padding(
                                //     padding:
                                //         const EdgeInsets.only(right: 10.0),
                                //     child: Icon(
                                //       Icons.settings,
                                //       color: Colors.grey,
                                //       size: 40.0,
                                //     ),
                                //   ),
                                //   // Flexible(
                                //   //     child: Text(
                                //   //         'We are doing our best to make these features available!')),
                                // ]),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Settings",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                          color: Colors.grey),
                                    ),
                                    SizedBox(height: 20.0),
                                    CheckboxListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      // checkColor: Color(0xFFF9A825),
                                      activeColor: Color(0xFFF9A825),
                                      title: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8.0, top: 8.0),
                                        child: Text(
                                          'Newsletter',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0),
                                        ),
                                      ),
                                      // subtitle: Text(
                                      //     'Stay on track with all the new stuff coming soon in Ryta!',
                                      //     style: TextStyle(fontSize: 17.0)),
                                      value: _newsletterSubscription,
                                      onChanged: (value) async {
                                        setState(() {
                                          _newsletterSubscription =
                                              !_newsletterSubscription;
                                        });

                                        await DatabaseService(uid: user.uid)
                                            .updateNewsletterSubscription(
                                          _newsletterSubscription,
                                        );

                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        //change the value in firestore
                                      },
                                    ),
                                    Text(
                                        'Stay on track with all the new stuff coming soon in Ryta!',
                                        style: TextStyle(fontSize: 17.0)),
                                    SizedBox(height: 30.0),
                                    ElevatedButton(
                                        style: ButtonStyle(
                                          elevation:
                                              MaterialStateProperty.all<double>(
                                                  0),
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  horizontal: 30.0,
                                                  vertical: 15.0)),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.transparent),
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.grey),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0))),
                                        ),
                                        child: Text(
                                          'DELETE ACCOUNT',
                                        ),
                                        onPressed: () async {
                                          //Ask if the user is sure?
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                new AlertDialog(
                                              title: new Text(
                                                  'Do you really want to delete your Ryta account?'),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0)),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: Text("No"),
                                                  style: ButtonStyle(
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all<double>(0),
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(EdgeInsets.all(
                                                                10.0)),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Color(
                                                                0xFF995C75)),
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Colors.white),
                                                    shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            // side: BorderSide(color: Color(0xFF995C75), width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0))),
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                                TextButton(
                                                  onPressed: () async {
                                                    //more user to archive and delete all the personal data...
                                                    dynamic f = await _auth
                                                        .deleteUser();
                                                    //is reauthentication needed?
                                                    if (f != null)
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            new AlertDialog(
                                                          title: new Text(
                                                              'Please enter your password to reauthenticate'),
                                                          content: Form(
                                                            child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  SizedBox(
                                                                      height:
                                                                          10.0),
                                                                  TextFormField(
                                                                      obscureText:
                                                                          true,
                                                                      decoration: textInputDecoration.copyWith(
                                                                          hintText:
                                                                              'Password'),
                                                                      validator: (val) => val.length <
                                                                              6
                                                                          ? 'Enter a valid password'
                                                                          : null,
                                                                      onChanged:
                                                                          (val) {
                                                                        setState(() =>
                                                                            password =
                                                                                val);
                                                                      }),
                                                                ]),
                                                          ),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0)),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                if (_formKey
                                                                    .currentState
                                                                    .validate()) {
                                                                  String email =
                                                                      userfile
                                                                          .email;

                                                                  // Create a credential
                                                                  EmailAuthCredential
                                                                      credential =
                                                                      EmailAuthProvider.credential(
                                                                          email:
                                                                              email,
                                                                          password:
                                                                              password);
                                                                  dynamic result = await FirebaseAuth
                                                                      .instance
                                                                      .currentUser
                                                                      .reauthenticateWithCredential(
                                                                          credential);

                                                                  if (result ==
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      error =
                                                                          'Password not correct';
                                                                    });
                                                                  }
                                                                }
                                                                //more user to archive and delete all the personal data...
                                                                await _auth
                                                                    .deleteUser();

                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                Wrapper()));
                                                                //Navigator.of(context).pop();
                                                              },
                                                              style:
                                                                  ButtonStyle(
                                                                elevation:
                                                                    MaterialStateProperty
                                                                        .all<double>(
                                                                            0),
                                                                padding: MaterialStateProperty
                                                                    .all(EdgeInsets
                                                                        .all(
                                                                            10.0)),
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .transparent),
                                                                foregroundColor:
                                                                    MaterialStateProperty.all<
                                                                            Color>(
                                                                        Color(
                                                                            0xFF995C75)),
                                                                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                                                    side: BorderSide(
                                                                        color: Color(
                                                                            0xFF995C75),
                                                                        width:
                                                                            1.0),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.0))),
                                                              ),
                                                              child: Text(
                                                                  "CONFIRM"),
                                                            ),
                                                            SizedBox(
                                                                height: 10.0),
                                                            Text(
                                                              error,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize:
                                                                      14.0),
                                                            ),
                                                          ],
                                                        ),
                                                      );

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Wrapper()));
                                                    //Navigator.of(context).pop();
                                                  },
                                                  style: ButtonStyle(
                                                    elevation:
                                                        MaterialStateProperty
                                                            .all<double>(0),
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(EdgeInsets.all(
                                                                10.0)),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Colors
                                                                .transparent),
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Color(
                                                                0xFF995C75)),
                                                    shape: MaterialStateProperty
                                                        .all(RoundedRectangleBorder(
                                                            side: BorderSide(
                                                                color: Color(
                                                                    0xFF995C75),
                                                                width: 1.0),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0))),
                                                  ),
                                                  child: Text("Yes"),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),

                                    // actions: <Widget>[
                                    //   TextButton(
                                    //     child: Text('Back to the app'),
                                    //     onPressed: (){
                                    //       Navigator.of(context).pop();
                                    //     }
                                    //   ),
                                  ],
                                ),
                              ),
                            );

                            //newsletter check box

                            //delete the acount?
                          },
                        ),
                      ],
                    ),
                  ),

                  // SizedBox(height: 20.0),
                  // email
                  Text(
                    user.email,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17.0),
                  ),
                  SizedBox(height: 30.0),
                  ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(0),
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 15.0)),
                        // backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                        // foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF995C75)),
                        // shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        //         // side: BorderSide(color: Color(0xFF995C75), width: 1.0),
                        //         borderRadius: BorderRadius.circular(15.0))),
                      ),
                      child: Text(
                        'LOGOUT',
                      ),
                      onPressed: () async {
                        await _auth.signOut();
                      }),
                  SizedBox(height: 10.0),

                  Visibility(
                    // visible: (userfile.willToPay!=true),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 40.0, right: 40.0),
                          child: Divider(
                            color: Colors.black,
                            height: 50,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          "Ryta Premium:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25.0),
                        ),
                        SizedBox(height: 15.0),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Column(
                            children: <Widget>[
                              CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                // checkColor: Color(0xFFF9A825),
                                activeColor: Color(0xFFF9A825),
                                title: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, top: 8.0, right: 8.0),
                                  child: Text(
                                    'Get practical',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0),
                                  ),
                                ),
                                subtitle: Text(
                                    'Connect Ryta to your calendar, add your ToDo-lists.',
                                    style: TextStyle(fontSize: 17.0)),
                                value: _checkboxListTile1,
                                onChanged: (value) {
                                  setState(() {
                                    if (userfile.willToPay != true) {
                                      _checkboxListTile1 = !_checkboxListTile1;
                                      if (_checkboxListTile1 == true)
                                        price = price + oneThird;
                                      if (_checkboxListTile1 == false)
                                        price = price - oneThird;
                                    }
                                  });
                                },
                              ),
                              // CheckboxListTile(
                              //   controlAffinity: ListTileControlAffinity.leading,
                              //   // checkColor: Color(0xFFF9A825),
                              //   activeColor: Color(0xFFF9A825),
                              //   title: Padding(
                              //     padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, right:8.0),
                              //     child: Text('Personalize', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),),
                              //   ),
                              //   subtitle: Text('personal pictures, favorite quote, design...', style: TextStyle(fontSize: 17.0)),
                              //   value: _checkboxListTile2,
                              //   onChanged: (value) {
                              //     setState(() {
                              //       if(userfile.willToPay!=true) {
                              //       _checkboxListTile2 = !_checkboxListTile2;
                              //       if (_checkboxListTile2==true)
                              //       price=price+1;
                              //       if (_checkboxListTile2==false)
                              //       price=price-1;
                              //       }
                              //     });
                              //   },
                              // ),
                              CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                // checkColor: Color(0xFFF9A825),
                                activeColor: Color(0xFFF9A825),
                                title: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, top: 8.0, right: 8.0),
                                  child: Text(
                                    'Push yourself',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0),
                                  ),
                                ),
                                subtitle: Text(
                                    'Smart push notifications and a timer for your targets, so you never lose track of them.',
                                    style: TextStyle(fontSize: 17.0)),
                                value: _checkboxListTile2,
                                onChanged: (value) {
                                  setState(() {
                                    if (userfile.willToPay != true) {
                                      _checkboxListTile2 = !_checkboxListTile2;
                                      if (_checkboxListTile2 == true)
                                        price = price + oneThird;
                                      if (_checkboxListTile2 == false)
                                        price = price - oneThird;
                                    }
                                  });
                                },
                              ),
                              CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                // checkColor: Color(0xFFF9A825),
                                activeColor: Color(0xFFF9A825),
                                title: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, top: 8.0, right: 8.0),
                                  child: Text(
                                    'Get the most out of your data',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0),
                                  ),
                                ),
                                subtitle: Text(
                                    "Combine the data of your favorite apps with Ryta. Ryta's analysis will show you the way to your targets/ Ryta's analysis will help you reach your targets",
                                    style: TextStyle(fontSize: 17.0)),
                                value: _checkboxListTile3,
                                onChanged: (value) {
                                  setState(() {
                                    if (userfile.willToPay != true) {
                                      _checkboxListTile3 = !_checkboxListTile3;
                                      if (_checkboxListTile3 == true)
                                        price = price + oneThird;
                                      if (_checkboxListTile3 == false)
                                        price = price - oneThird;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          "${(num.parse((price).toStringAsFixed(2))).abs()} EUR per month",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 20.0),
                        ),
                        SizedBox(height: 20.0),
                        ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(0),
                              backgroundColor: (_checkboxListTile1 == false &&
                                      _checkboxListTile2 == false &&
                                      _checkboxListTile3 == false)
                                  ? MaterialStateProperty.all<Color>(
                                      Colors.grey)
                                  : MaterialStateProperty.all<Color>(
                                      Color(0xFFF9A825)),
                            ),
                            child: Text('UPGRADE TO PREMIUM',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: () async {
                              if (_checkboxListTile1 == false &&
                                  _checkboxListTile2 == false &&
                                  _checkboxListTile3 == false) {
                                return null;
                              } else
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    title: Row(children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Icon(
                                          Icons.thumb_up_alt,
                                          color: Color(0xFFF9A825),
                                          size: 40.0,
                                        ),
                                      ),
                                      Flexible(
                                          child: Text(
                                              'We are doing our best to make these features available!')),
                                    ]),
                                    content: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text:
                                              "We appreciate your interest! If you like our vision, have other ideas or would like to give us personal feedback, please contact us at ",
                                          style: TextStyle(color: Colors.black),
                                        ),

                                        // ignore: todo
                                        // TODO: make the link work!!!
                                        TextSpan(
                                            text: "info@ryta.eu",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                var url =
                                                    'https://www.ryta.eu/';
                                                if (await canLaunch(url)) {
                                                  await launch(url.toString());
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                              }),
                                        TextSpan(
                                          text: ". Your Ryta team :)",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ]),
                                    ),
                                    // actions: <Widget>[
                                    //   TextButton(
                                    //     child: Text('Back to the app'),
                                    //     onPressed: (){
                                    //       Navigator.of(context).pop();
                                    //     }
                                    //   ),
                                    // ],
                                  ),
                                );
                              if (userfile.willToPay != true)
                                // Set willToPay to True
                                DatabaseService(uid: user.uid)
                                    .updateUserWillingnessToPay(
                                        true,
                                        _checkboxListTile1,
                                        _checkboxListTile2,
                                        _checkboxListTile3,
                                        num.parse((price).toStringAsFixed(2)));
                            }),
                        SizedBox(height: 40.0),
                      ],
                    ),
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

//// Alternative Settings
/*
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/services/database.dart';
import 'package:ryta_app/shared/constants.dart';
import 'package:ryta_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> topic = ['sports', 'education', 'personality', 'nutrition', 'finance'];

  String _currentName;
  String _currentTopic;
  String _currentUrl;

  @override
  Widget build(BuildContext context) {

    RytaUser user = Provider.of<RytaUser>(context);

    return StreamBuilder<RytaUser> (
      stream: DatabaseService(uid: user.uid).RytaUser,
      builder: (context, snapshot){
        if(snapshot.hasData) {
          RytaUser userData = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                'Update your goals',
                style: TextStyle(fontSize: 18.0),
                ),
              SizedBox(height: 20.0),
              TextFormField(
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() => _currentName = val),
              ),
              SizedBox(height: 10.0),
              DropdownButtonFormField(
                decoration: textInputDecoration,
                items: topic.map((topic) {
                  return DropdownMenuItem(
                    value: topic,
                  );
                }).toList(),
                onChanged: (val) => setState(() => _currentTopic = val ),
              ),
                SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration,
                validator: (val) => val.isEmpty ? 'Please enter an url' : null,
                onChanged: (val) => setState(() => _currentUrl = val),
                ),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    await DatabaseService(uid: user.uid).updateUserData(
                        _currentName ?? snapshot.data.name,
                        _currentName ?? snapshot.data.name,
                        _currentUrl ?? snapshot.data.strength,
                    );
                    Navigator.pop(context);
                  }
                }
              ],
            ),
          );
        }else{
            return Loading();
    }
      }
    );
  }
}
*/
