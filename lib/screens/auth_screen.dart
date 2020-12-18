import 'package:e_commerce_app/exceptions/http_exception.dart';
import 'package:e_commerce_app/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  static const ROUTE_NAME = '/authScreen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  AuthType _authType = AuthType.Login;
  final _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();

  AnimationController _animationController;
  Animation<Size> _heightAnimation;

  bool isLoading = false;

  var _errorDialogMessage = 'Error Happened!';

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _heightAnimation = Tween<Size>(
      begin: Size(double.infinity, double.infinity),
      end: Size(double.infinity, double.infinity),
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    passwordFocusNode.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showAuthErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void _save() async {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });

      try {
        if (_authType == AuthType.Login) {
          // Log In User
          await Provider.of<Auth>(context, listen: false)
              .signInUser(_authData['email'], _authData['password']);
        } else {
          await Provider.of<Auth>(context, listen: false)
              .signUpUser(_authData['email'], _authData['password']);
        }
      } on HttpException catch (error) {
        if (error.toString() == 'EMAIL_EXISTS') {
          _errorDialogMessage = 'Email is already registered, try another one';
        } else if (error.toString() == 'OPERATION_NOT_ALLOWED') {
          _errorDialogMessage = 'Not allowed';
        } else if (error.toString() == 'TOO_MANY_ATTEMPTS_TRY_LATER') {
          _errorDialogMessage = 'You tried too many times, try again later';
        } else if (error.toString() == 'EMAIL_NOT_FOUND') {
          _errorDialogMessage = 'Your email is not found!';
        } else if (error.toString() == 'INVALID_PASSWORD') {
          _errorDialogMessage = 'You entered an invalid password';
        } else if (error.toString() == 'USER_DISABLED') {
          _errorDialogMessage = 'Account is banned, contact your administrator';
        }
        _showAuthErrorDialog(_errorDialogMessage);
      } catch (error) {
        _showAuthErrorDialog(error.toString());
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.red[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: EdgeInsets.all(32),
                //transform: Matrix4.rotationZ(-9 * pi / 180),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'E-Commerce App',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'E-Mail',
                            hintText: 'E-Mail',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onFieldSubmitted: (_) {
                            passwordFocusNode.requestFocus();
                          },
                          onSaved: (value) {
                            _authData['email'] = value.trim();
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Enter your Email';
                            } else if (!value.contains('@') ||
                                !value.trim().endsWith('.com')) {
                              return 'Enter a valid E-mail';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Password',
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          controller: passwordController,
                          focusNode: passwordFocusNode,
                          onSaved: (value) {
                            _authData['password'] = value.trim();
                          },
                          validator: (value) {
                            if (value.length == 0) {
                              return 'Enter your Password';
                            } else if (value.length < 6) {
                              return 'Password should be more than 5 characters';
                            }
                            return null;
                          },
                        ),
                        if (_authType == AuthType.SignUp) ...[
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              hintText: 'Confirm Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value != passwordController.text) {
                                return 'passwords doesn\'t match';
                              }
                              return null;
                            },
                          ),
                        ],
                        SizedBox(
                          height: 32,
                        ),
                        SizedBox(
                          width: 180,
                          child: RaisedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                _authType == AuthType.Login
                                    ? 'Log in'
                                    : 'Sign up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            color: Colors.red[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 8,
                            onPressed: isLoading ? null : _save,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        FlatButton(
                          child: Text(
                            _authType == AuthType.Login
                                ? 'New User? Sign up'
                                : 'Already have an account? Login',
                            style: TextStyle(
                              color: Colors.blue[700],
                            ),
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: toggleAuthStatus,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleAuthStatus() {
    if (_authType == AuthType.SignUp) {
      setState(() {
        _authType = AuthType.Login;
        passwordController.text = '';
      });
    } else {
      setState(() {
        _authType = AuthType.SignUp;
        passwordController.text = '';
      });
    }
  }
}

enum AuthType {
  Login,
  SignUp,
}
