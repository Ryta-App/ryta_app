import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ryta_app/models/goal.dart';
import 'package:ryta_app/models/user.dart';
import 'package:ryta_app/models/user_file.dart';
import 'package:ryta_app/screens/home/goal_definition.dart';
import 'package:ryta_app/screens/home/settings_form.dart';
import 'package:ryta_app/services/database.dart';
import 'package:ryta_app/screens/home/goals_list.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  // final AuthService _auth = AuthService();

  // int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    GoalsList(),
    SettingsForm(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<RytaUser>(context);
    // final userfile = Provider.of<UserFile>(context);
    // final width = MediaQuery.of(context).size.width;
    // final iconLocation = width / 4 - 22;

    // Homescreen
    if (user != null)
      return MultiProvider(
          providers: [
            // Stream of data in USERFILE
            StreamProvider<UserFile>.value(
              catchError: (_, __) => null,
              value: DatabaseService(uid: user.uid).userfile,
              initialData: null,
            ),

            // Strean of GOALS
            StreamProvider<List<Goal>>.value(
              value: DatabaseService(uid: user.uid).goals,
              initialData: null,
            )
          ],
          // child: Builder(
          builder: (context, child) {
            final userfile = Provider.of<UserFile>(context);

            return new WillPopScope(
                onWillPop: () async => false,
                child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    extendBody: true,
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      elevation: 1.0,
                      centerTitle: true,
                      title: SizedBox(
                        height: 70,
                        child: Image.asset("assets/ryta_logo.png"),
                      ),
                      leading: null,

                      //    /* TextButton.icon(
                      //       icon: Icon(Icons.settings),
                      //       label: Text('settings'),
                      //       onPressed: () => _showSettingsPanel(),
                      //     ) */
                    ),
                    // body: Center(
                    body: NotificationListener<OverscrollIndicatorNotification>(
                      // disabling a scroll glow
                      // ignore: missing_return
                      onNotification: (overscroll) {
                        overscroll.disallowGlow();
                      },
                      child: TabBarView(children: [
                        _widgetOptions.elementAt(0),
                        (user.emailVerified == true)
                            ? _widgetOptions.elementAt(1)
                            : Container(), //_selectedIndex
                      ]),
                    ),

                    // Implementing the toolbar
                    bottomNavigationBar: BottomAppBar(
                      // elevation: 2.0,
                      shape: CircularNotchedRectangle(),
                      notchMargin: 5.0,
                      color: Colors.white,
                      child: Container(
                        color: Colors.transparent,
                        child: TabBar(
                          labelColor: Color(0xFF995C75),
                          unselectedLabelColor: Colors.grey[400],
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: EdgeInsets.all(5.0),
                          indicatorColor: Colors.transparent,
                          tabs: [
                            Tab(
                              icon: Icon(Icons.home_filled),
                            ),
                            Tab(
                              icon: Icon(Icons.person),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //Old bottomAppBar

                    // BottomAppBar(
                    //   // elevation: 2.0,
                    //   shape: CircularNotchedRectangle(),
                    //   notchMargin: 5.0,
                    //   color: Colors.white,
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.max,
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       IconButton(
                    //         color: Colors.grey[400],
                    //         icon: Icon(Icons.home_filled,
                    //             color: _selectedIndex == 0
                    //                 ? Color(0xFF995C75)
                    //                 : Colors.grey[400]),
                    //         padding: EdgeInsets.only(left: iconLocation),
                    //         onPressed: () {
                    //           if (user.emailVerified == true)
                    //             setState(() {
                    //               _selectedIndex = 0;
                    //             });
                    //         },
                    //       ),
                    //       IconButton(
                    //         color: Colors.grey[400],
                    //         icon: Icon(Icons.person,
                    //             color: _selectedIndex == 1
                    //                 ? Color(0xFF995C75)
                    //                 : Colors.grey[400]),
                    //         padding: EdgeInsets.only(right: iconLocation),
                    //         onPressed: () async {
                    //           DatabaseService(uid: user.uid)
                    //               .updateEmailVerified(user.emailVerified);
                    //           if (user.emailVerified == true)
                    //             setState(() {
                    //               _selectedIndex = 1;
                    //             });
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // Start a definition of a new goal
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,

                    floatingActionButton: FloatingActionButton(
                      elevation: 0.0,
                      clipBehavior: Clip.none,
                      onPressed: () async {
                        if (user.emailVerified == true) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GoalDefinition(
                                  userfile.throughIntroduction)));
                        }
                      },
                      tooltip: 'Add a new goal',
                      child: Icon(Icons.add),
                      backgroundColor: Color(0xFF995C75),
                    ),
                  ),
                ));
          });
    // );
    else {
      return Container(width: 0.0, height: 0.0);
    }
  }
}
