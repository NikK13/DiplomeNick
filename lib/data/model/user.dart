import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class User{
  String? key;
  String? name;
  String? email;
  bool? isEnabled;

  User({this.key, this.name, this.email, this.isEnabled});

  factory User.fromJson(String key, Map<String, dynamic> json){
    return User(
      key: key,
      name: json['username'],
      email: json['email'],
      isEnabled: json['is_enabled']
    );
  }

  Map<String, Object?> toJson() => {
    'email': email,
    'username': name,
    'is_enabled': isEnabled,
  };
}

class UserItem extends StatefulWidget {
  final User? user;

  const UserItem({Key? key, this.user}) : super(key: key);

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  late bool isBanned;

  @override
  void initState() {
    isBanned = !widget.user!.isEnabled!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{

      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 1, color: Colors.grey)
        ),
        //width: 300,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.user!.name}",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              "${widget.user!.email}",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context, 'banned_user'),
                  style: const TextStyle(
                    fontSize: 14
                  ),
                ),
                CupertinoSwitch(
                  value: isBanned,
                  activeColor: appColor,
                  onChanged: (val){
                    setState(() => isBanned = !isBanned);
                    appBloc.updateUser(widget.user!.key!, {
                      "is_enabled": !isBanned
                    });
                  }
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
