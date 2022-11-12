import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/pages/admin.dart';
import 'package:diplome_nick/ui/pages/user.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isAsAdministrator ?
    const HomeAdminPage() :
    const HomeUserPage();
  }
}