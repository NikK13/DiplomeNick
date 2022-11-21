import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:diplome_nick/data/utils/app.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/data/utils/router.gr.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/widgets/bottom_dialog.dart';
import 'package:diplome_nick/ui/widgets/button.dart';
import 'package:diplome_nick/ui/widgets/input.dart';
import 'package:diplome_nick/ui/widgets/loading.dart';
import 'package:diplome_nick/ui/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isForSignUp = false;
  bool _isInProgress = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      firebaseBloc.fbAuth.authStateChanges().listen((User? user) {
        loadingFuture = Future.value(true);
        if(user != null && isToRedirectHome){
          context.router.replaceAll([const HomePageRoute()]);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: FutureBuilder(
          future: loadingFuture,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done ? Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 380 ?
                  380 : MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10.0,
                          sigmaY: 10.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.grey.withOpacity(0.1),
                                Colors.grey.withOpacity(0.08),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                const Text(
                                  App.appName,
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 7.5,
                                    color: appColor
                                  ),
                                ),
                                const SizedBox(height: 28),
                                if(_isForSignUp)
                                Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: InputField(
                                        controller: _nameController,
                                        inputType: TextInputType.text,
                                        hint: AppLocalizations.of(context, 'nickname'),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: InputField(
                                    controller: _emailController,
                                    inputType: TextInputType.emailAddress,
                                    hint: AppLocalizations.of(context, 'email'),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: double.infinity,
                                  child: InputField(
                                    controller: _passwordController,
                                    isPassword: true,
                                    hint: AppLocalizations.of(context, 'password'),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 70,
                                  child: !_isInProgress ? Center(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: AppButton(
                                        fontSize: 18,
                                        text: !_isForSignUp ?
                                        AppLocalizations.of(context, 'login') :
                                        AppLocalizations.of(context, 'sign_up'),
                                        onPressed: () async{
                                          final email = _emailController.text.trim();
                                          final pass = _passwordController.text.trim();
                                          final name = _nameController.text.trim();
                                          if(email.isNotEmpty && pass.isNotEmpty &&
                                            (_isForSignUp ? name.isNotEmpty : true)){
                                            setState(() => _isInProgress = true);
                                            if(_isForSignUp){
                                              await firebaseBloc.createAccount(
                                                context,
                                                _nameController.text,
                                                _emailController.text,
                                                _passwordController.text,
                                                (){
                                                  _emailController.clear();
                                                  _nameController.clear();
                                                  _passwordController.clear();
                                                  setState(() => _isForSignUp = false);
                                                }
                                              );
                                            }
                                            else{
                                              await firebaseBloc.signIn(
                                                context,
                                                _emailController.text,
                                                _passwordController.text
                                              );
                                            }
                                            setState(() => _isInProgress = false);
                                          }
                                          else{
                                            showInfoDialog(context, AppLocalizations.of(context, 'empty_fields'));
                                          }
                                        },
                                      ),
                                    ),
                                  ) : const LoadingView()
                                ),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: (){
                                    setState(() => _isForSignUp = !_isForSignUp);
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: appColor,
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      fontFamily: appFont
                                    )
                                  ),
                                  child: Text(
                                    !_isForSignUp ?
                                    AppLocalizations.of(context, 'account_create') :
                                    AppLocalizations.of(context, 'account_exists')
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ) : const LoadingView();
          }
        )
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

