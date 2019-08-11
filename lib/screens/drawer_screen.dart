import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/intl/localizations_delegate.dart';
import 'package:simple_weight_tracking_app/model/info_user.dart';
import 'package:simple_weight_tracking_app/model/weight.dart';
import 'package:simple_weight_tracking_app/screens/general_screen.dart';
import 'package:simple_weight_tracking_app/screens/goals_screen.dart';
import 'package:simple_weight_tracking_app/screens/select_height_screen.dart';
import 'package:simple_weight_tracking_app/screens/signin_screen.dart';
import 'package:simple_weight_tracking_app/utils/fade_transition.dart';
import 'package:simple_weight_tracking_app/widgets/profile_button.dart';

import 'notifications_screen.dart';

class DrawerScreen extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseUser user;
  final InfoUser infoUser;
  final List<Weight> weights;
  DrawerScreen({this.auth, this.user, this.infoUser, this.weights});

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> _drawerOptions = [
      DemoLocalizations.of(context).mainScreen,
      DemoLocalizations.of(context).objectives,
      DemoLocalizations.of(context).height,
      DemoLocalizations.of(context).notifications,
      DemoLocalizations.of(context).closeSession,
      DemoLocalizations.of(context).closeApp,
    ];
    void _signOut() async {
      await widget.auth.signOut().then((_) {
        Navigator.of(context).pushAndRemoveUntil(FadeTransitionRoute(widget: SignInScreen()), (Route<dynamic> route) => false);
      });
    }

    List<IconData> _iconOptions = [
      Icons.home,
      FontAwesomeIcons.bullseye,
      FontAwesomeIcons.rulerVertical,
      Icons.notifications_active,
      Icons.arrow_back,
      Icons.exit_to_app,
    ];
    Widget body;
    switch (_selectedIndex) {
      case 0:
        body = GeneralScreen(
          infoUser: widget.infoUser,
          weights: widget.weights,
          user: widget.user,
        );
        break;
      case 1:
        body = GoalsScreen(
          infoUser: widget.infoUser,
          user: widget.user,
        );
        break;
      case 2:
        body = HeightScreen(
          infoUser: widget.infoUser,
          user: widget.user,
        );
        break;
      case 3:
        body = NotificationsScreen();
        break;
    }
    return Scaffold(
        backgroundColor: AppThemes.BLACK_BLUE,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              MediaQuery.of(context).size.height < 700
                  ? Container()
                  : DrawerHeader(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ProfilePhoto(
                            imageUrl: widget.user.photoUrl,
                            size: 80.0,
                          ),
                          Text(
                            widget.user.displayName != null && widget.user.displayName != "" ? widget.user.displayName : widget.user.email != "" ? widget.user.email : " ",
                            style: TextStyle(
                              color: AppThemes.CYAN,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
              MediaQuery.of(context).size.height < 1000
                  ? Container()
                  : Divider(
                      color: AppThemes.CYAN,
                      indent: 10.0,
                      endIndent: 10.0,
                    ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _drawerOptions.length - 2,
                    itemBuilder: (context, index) {
                      List _actions = [
                        () {
                          if (_selectedIndex != index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          }
                          Navigator.of(context).pop();
                        },
                        () {
                          if (_selectedIndex != index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          }
                          Navigator.of(context).pop();
                        },
                        () {
                          if (_selectedIndex != index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          }
                          Navigator.of(context).pop();
                        },
                        () {
                          if (_selectedIndex != index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          }
                          Navigator.of(context).pop();
                        },
                      ];
                      if (index == 4) {
                        return Column(
                          children: <Widget>[
                            Divider(
                              color: AppThemes.CYAN,
                              indent: 10.0,
                              endIndent: 10.0,
                            ),
                            Container(
                              color: _selectedIndex == index ? AppThemes.CYAN : Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Container(
                                  color: _selectedIndex == index ? AppThemes.GREEN_GREYER : Colors.transparent,
                                  child: ListTile(
                                    leading: Icon(
                                      _iconOptions[index],
                                      color: _selectedIndex == index ? AppThemes.BLACK_BLUE : AppThemes.CYAN,
                                    ),
                                    selected: _selectedIndex == index,
                                    title: Text(
                                      _drawerOptions[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onTap: _actions[index],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Container(
                        color: _selectedIndex == index ? AppThemes.CYAN : Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Container(
                            color: _selectedIndex == index ? AppThemes.GREEN_GREYER : Colors.transparent,
                            child: ListTile(
                              leading: Icon(
                                _iconOptions[index],
                                color: _selectedIndex == index ? AppThemes.BLACK_BLUE : AppThemes.CYAN,
                              ),
                              selected: _selectedIndex == index,
                              title: Text(
                                _drawerOptions[index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: _actions[index],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Column(
                children: <Widget>[
                  Divider(
                    color: AppThemes.CYAN,
                    indent: 10.0,
                    endIndent: 10.0,
                  ),
                  Container(
                    color: _selectedIndex == _iconOptions.length - 2 ? AppThemes.CYAN : Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Container(
                        color: _selectedIndex == _iconOptions.length - 2 ? AppThemes.GREEN_GREYER : Colors.transparent,
                        child: ListTile(
                          leading: Icon(
                            _iconOptions[_iconOptions.length - 2],
                            color: _selectedIndex == _iconOptions.length - 2 ? AppThemes.BLACK_BLUE : AppThemes.CYAN,
                          ),
                          selected: _selectedIndex == _iconOptions.length - 2,
                          title: Text(
                            _drawerOptions[_iconOptions.length - 2],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            if (_selectedIndex != _iconOptions.length - 2) {
                              setState(() {
                                _selectedIndex = _iconOptions.length - 2;
                                _signOut();
                              });
                            }
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: _selectedIndex == _iconOptions.length - 1 ? AppThemes.CYAN : Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Container(
                        color: _selectedIndex == _iconOptions.length - 1 ? AppThemes.GREEN_GREYER : Colors.transparent,
                        child: ListTile(
                          leading: Icon(
                            _iconOptions[_iconOptions.length - 1],
                            color: _selectedIndex == _iconOptions.length - 1 ? AppThemes.BLACK_BLUE : AppThemes.CYAN,
                          ),
                          selected: _selectedIndex == _iconOptions.length - 1,
                          title: Text(
                            _drawerOptions[_iconOptions.length - 1],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            if (_selectedIndex != _iconOptions.length - 1) {
                              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: body);
  }

  @override
  bool get wantKeepAlive => true;
}
