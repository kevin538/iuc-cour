// ignore_for_file: prefer_const_constructors, unused_element, unused_field, unused_local_variable, non_constant_identifier_names, deprecated_member_use, avoid_print, unused_import, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential AuthResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        AuthResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        AuthResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(AuthResult.user!.uid)
            .set({
          'username': username,
          'email': email,
        });
      }
    } on FirebaseException catch (err) {
      var message = 'An error occured, please check your credentials!';
      if (err.message != null) {
        message = err.message!;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
