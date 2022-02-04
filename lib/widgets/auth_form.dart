// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, unused_field, unused_element, avoid_print, prefer_final_fields, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
 final bool isLoadding;
  AuthForm(this.saveAuthForm, this.isLoadding);

  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) saveAuthForm;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>(); // to add keys so that each field is unique
  var _isLogin = true;
  var userEmail = '';
  var userName = '';
  var userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate(); // validate the entries
    FocusScope.of(context).unfocus(); // remove the keyboard
    if (isValid) {
      _formKey.currentState!.save(); // trigger all  onsave on textfield
      widget.saveAuthForm(  // refering to the widget coming from authScreen
        userEmail.trim(),
        userPassword.trim(),
        userName.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                    ),
                    onSaved: (value) {
                      userEmail = value!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 3) {
                          return 'give an username at least 4 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (value) {
                        userName = value!;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'The password is too short at least 7';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    onSaved: (value) {
                      userPassword = value!;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if(widget.isLoadding)
                  CircularProgressIndicator(),
                  if(!widget.isLoadding)
                  RaisedButton(
                    onPressed: _trySubmit,
                    child: Text(_isLogin ? 'Login' : 'Signup'),
                  ),
                  if(!widget.isLoadding)
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin
                        ? 'Create new account'
                        : 'I already have an account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
