import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/intl/localizations_delegate.dart';
import 'package:simple_weight_tracking_app/screens/main_screen.dart';
import 'package:simple_weight_tracking_app/screens/register_screen.dart';
import 'package:simple_weight_tracking_app/utils/fade_transition.dart';
import 'package:flushbar/flushbar.dart';
import 'package:simple_weight_tracking_app/widgets/loading_indicator.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  @override
  void initState() {
    _auth.currentUser().then((FirebaseUser user) {
      if (user != null) {
        Navigator.of(context).pushReplacement(FadeTransitionRoute(widget: MainScreen()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: Theme(
            data: ThemeData(
              primaryColor: AppThemes.CYAN,
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/plain-logo.png',
                            height: MediaQuery.of(context).size.height / 7,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: DemoLocalizations.of(context).email,
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: DemoLocalizations.of(context).password,
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                FlatButton(
                                  padding: EdgeInsets.all(0.0),
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          DemoLocalizations.of(context).forgotPassword,
                                          style: TextStyle(color: AppThemes.CYAN, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    _resetPassword();
                                  },
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                  color: AppThemes.CYAN,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          DemoLocalizations.of(context).signIn.toUpperCase(),
                                          style: TextStyle(color: AppThemes.BLACK_BLUE, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    _signInWithEmailAndPassword();
                                  },
                                ),
                                FlatButton(
                                  padding: EdgeInsets.all(0.0),
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          DemoLocalizations.of(context).dontHaveAccount,
                                          style: TextStyle(color: AppThemes.CYAN),
                                        ),
                                        Container(
                                          width: 5.0,
                                        ),
                                        Text(
                                          DemoLocalizations.of(context).register,
                                          style: TextStyle(color: AppThemes.CYAN, fontWeight: FontWeight.bold, fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.of(context).push(FadeTransitionRoute(widget: RegisterScreen()));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppThemes.CYAN,
                      indent: 20.0,
                      endIndent: 20.0,
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            DemoLocalizations.of(context).otherAccounts,
                            style: TextStyle(color: AppThemes.CYAN),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              MaterialButton(
                                onPressed: _signInWithGoogle,
                                child: Container(
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/images/google-logo.png',
                                      height: 40.0,
                                    ),
                                  ),
                                ),
                                shape: CircleBorder(
                                  side: BorderSide(width: 2.0, color: AppThemes.CYAN),
                                ),
                              ),
                              MaterialButton(
                                onPressed: _signInWithGoogle,
                                child: Container(
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/images/facebook-logo.png',
                                      height: 40.0,
                                    ),
                                  ),
                                ),
                                shape: CircleBorder(
                                  side: BorderSide(width: 2.0, color: AppThemes.CYAN),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: _loading ? LoadingIndicator() : Container(),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  // Example code of how to sign in with google.
  void _signInWithGoogle() async {
    FocusScope.of(context).unfocus();
    await _googleSignIn.signOut();
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        _auth.currentUser().then((FirebaseUser user) {
          if (user != null) {
            Navigator.of(context).pushReplacement(FadeTransitionRoute(widget: MainScreen()));
          }
        });
      } else {
        String message = 'E';
        Flushbar(
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          backgroundColor: Colors.red,
          messageText: Text(message),
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code of how to sign in with email and password.
  void _resetPassword() {
    setState(() {
      _loading = true;
    });
    _auth.sendPasswordResetEmail(email: _emailController.text).catchError((error) {
      String message;
      switch (error.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          message = 'Correo electrónico en uso';
          break;
        case 'ERROR_WEAK_PASSWORD':
          message = 'La contraseña debe tener por lo menos 6 caracteres';
          break;
        case 'ERROR_INVALID_EMAIL':
          message = 'El correo electrónico no es válido';
          break;
        default:
          message = error.code;
          break;
      }
      Flushbar(
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        backgroundColor: Colors.red,
        messageText: Text(message),
        duration: Duration(seconds: 3),
      ).show(context);
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
    ;
  }

  // Example code of how to sign in with email and password.
  void _signInWithEmailAndPassword() {
    setState(() {
      _loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
        .then((user) {
      if (user != null) {
        _auth.currentUser().then((FirebaseUser user) {
          if (user != null) {
            Navigator.of(context).pushReplacement(FadeTransitionRoute(widget: MainScreen()));
          }
        });
      } else {}
    }).catchError((error) {
      String message;
      switch (error.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          message = 'Correo electrónico en uso';
          break;
        case 'ERROR_WEAK_PASSWORD':
          message = 'La contraseña debe tener por lo menos 6 caracteres';
          break;
        case 'ERROR_INVALID_EMAIL':
          message = 'El correo electrónico no es válido';
          break;
        case 'ERROR_USER_NOT_FOUND':
          message = 'No se ha encontrado ningún usuario con este email';
          break;
        default:
          message = error.code;
          break;
      }
      Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        backgroundColor: Colors.red,
        messageText: Text(
          message,
          style: TextStyle(color: AppThemes.BLACK_BLUE, fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 4),
      ).show(context);
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }
}
