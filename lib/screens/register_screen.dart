import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_weight_tracking_app/appthemes.dart';
import 'package:simple_weight_tracking_app/intl/localizations_delegate.dart';
import 'package:simple_weight_tracking_app/widgets/loading_indicator.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  bool _terms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            DemoLocalizations.of(context).register,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.of(context).pop(true)),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Theme(
            data: ThemeData(
                primaryColor: AppThemes.CYAN,
                unselectedWidgetColor: AppThemes.CYAN,
                textTheme: TextTheme(
                  title: TextStyle(color: Colors.white),
                )),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
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
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: DemoLocalizations.of(context).repeatPassword,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: _terms,
                            onChanged: (value) {
                              setState(() {
                                _terms = value;
                              });
                            },
                            checkColor: AppThemes.BLACK_BLUE,
                            activeColor: AppThemes.CYAN,
                          ),
                          Expanded(
                            child: Text(
                              DemoLocalizations.of(context).termsAndConditions,
                              style: TextStyle(color: AppThemes.CYAN),
                            ),
                          )
                        ],
                      ),
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
                              DemoLocalizations.of(context).register.toUpperCase(),
                              style: TextStyle(color: AppThemes.BLACK_BLUE, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState.validate()) {
                          _register();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: _loading ? LoadingIndicator() : Container(),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code for registration.
  void _register() async {
    setState(() {
      _loading = true;
    });
    final FirebaseUser user = await _auth
        .createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
        .catchError((error) {
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
  }
}
