import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/intl/localizations_delegate.dart';
import 'package:simple_weight_tracking_app/screens/main_screen.dart';
import 'package:simple_weight_tracking_app/utils/fade_transition.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: Builder(builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _EmailPasswordForm(),
              Divider(
                color: AppThemes.CYAN,
                indent: 20.0,
                endIndent: 20.0,
              ),
              _SignInSection(),
            ],
          ),
        );
      }),
    );
  }

  // Example code for sign out.

}

class _EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/plain-logo.png',
            height: 150.0,
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
              validator: (String value) {
                if (value.isEmpty) {
                  return DemoLocalizations.of(context).enterText;
                }
                return null;
              },
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
              validator: (String value) {
                if (value.isEmpty) {
                  return DemoLocalizations.of(context).enterText;
                }
                return null;
              },
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
                    if (_emailController.text != "") {
                      _resetPassword();
                    } else {}
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
                    if (_formKey.currentState.validate()) {
                      _signInWithEmailAndPassword();
                    }
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
                          style: TextStyle(color: AppThemes.CYAN, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: const Text('A registrarse'),
                      ));
//                      _signInWithEmailAndPassword();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code of how to sign in with email and password.
  void _resetPassword() {
    _auth.sendPasswordResetEmail(email: _emailController.text);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: const Text('No one has signed in.'),
    ));
  }

  // Example code of how to sign in with email and password.
  void _signInWithEmailAndPassword() {
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
    }).catchError((e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: const Text('No se ha encontrado al usuario'),
      ));
    });
  }
}

class _SignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInSectionState();
}

class _SignInSectionState extends State<_SignInSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }

  // Example code of how to sign in with google.
  void _signInWithGoogle() async {
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
        Scaffold.of(context).showSnackBar(SnackBar(
          content: const Text('No one has signed in.'),
        ));
      }
    });
  }
}
