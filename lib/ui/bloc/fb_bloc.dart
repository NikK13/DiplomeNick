// ignore_for_file: use_build_context_synchronously
import 'package:auto_route/auto_route.dart';
import 'package:diplome_nick/data/utils/constants.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/data/utils/router.gr.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/bloc/bloc.dart';
import 'package:diplome_nick/ui/widgets/bottom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FirebaseBloc implements BaseBloc{
  late FirebaseAuth fbAuth;

  User? fbUser;

  String? username;
  String? image;

  bool emailValidated(email) => email.contains("@") && email.length >= 4;

  bool passwordValidated(password) => password.length >= 6;
  bool nameValidated(name) => name.length >= 2;

  FirebaseBloc() {
    load();
  }

  load() async {
    fbAuth = FirebaseAuth.instance;
    fbAuth.authStateChanges().listen((User? user) {
      //debugPrint("USER CHANGE: $user");
      fbUser = fbAuth.currentUser;
      if(fbUser != null){
        isAsAdministrator = fbUser!.email!.contains(adminEmail);
      }
    });
  }

  Future<void> signOutUser() async{
    await fbAuth.signOut();
  }

  Future<void> createAccount(context, name, email, password, onSuccess) async {
    if(emailValidated(email) && passwordValidated(password) && nameValidated(name)){
      isToRedirectHome = false;
      try {
        final UserCredential user = await fbAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if(user.user != null){
          await user.user!.sendEmailVerification();
          await createUserProfile(user.user!, name, email);
          await fbAuth.signOut();
          showInfoDialog(context, AppLocalizations.of(context, 'sign_up_success'));
          onSuccess();
        }
      } on FirebaseAuthException catch (e) {
        showInfoDialog(context, e.message.toString());
      }
    }
    else{
      if(!emailValidated(email)){
        showInfoDialog(context, AppLocalizations.of(context, 'error_email'));
      }
      if(!nameValidated(name)){
        showInfoDialog(context, AppLocalizations.of(context, 'error_name'));
      }
      if(!passwordValidated(email)){
        showInfoDialog(context, AppLocalizations.of(context, 'error_password'));
      }
    }
  }

  Future<void> signIn(BuildContext context, email, password) async {
    try {
      isToRedirectHome = false;
      await fbAuth.signInWithEmailAndPassword(email: email, password: password);
      if(fbAuth.currentUser != null){
        if(fbAuth.currentUser!.email!.contains(adminEmail)){
          context.router.replaceAll([const HomePageRoute()]);
          isAsAdministrator = true;
          isToRedirectHome = true;
        }
        else{
          if(fbAuth.currentUser!.emailVerified){
            context.router.replaceAll([const HomePageRoute()]);
            isAsAdministrator = false;
            isToRedirectHome = true;
          }
          else{
            showInfoDialog(context, AppLocalizations.of(context, 'login_verify'));
            await fbAuth.signOut();
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      showInfoDialog(context, e.message.toString());
    }
  }

  updateUserData({required Map<String, dynamic> data}) async {
    final db = FirebaseDatabase.instance.ref().child('users/${fbAuth.currentUser!.uid}');
    await db.once().then((child) {
      db.child(fbAuth.currentUser!.uid).parent!.update(data);
    });
  }

  Future<bool> userIsEnabled(User user) async{
    final db = await FirebaseDatabase.instance.ref().child('users/${user.uid}').once();
    return ((db.snapshot.value as Map)['is_enabled']) as bool;
  }

  createUserProfile(user, name, email) async {
    final db = FirebaseDatabase.instance.ref().child('users/${user.uid}');
    await db.once().then((child) {
      if (!child.snapshot.exists) {
        debugPrint("Value was null: ${child.snapshot.value}");
        db.child(user.uid).parent!.set(<String, dynamic>{
          "username": name,
          "email": email,
          "is_enabled": true,
        });
      }
    });
  }

  @override
  dispose() {}
}