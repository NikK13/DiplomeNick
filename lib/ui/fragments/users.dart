import 'package:diplome_nick/data/model/user.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/widgets/loading.dart';
import 'package:flutter/material.dart';

class UsersFragment extends StatefulWidget {
  const UsersFragment({Key? key}) : super(key: key);

  @override
  State<UsersFragment> createState() => _UsersFragmentState();
}

class _UsersFragmentState extends State<UsersFragment> {

  @override
  void initState() {
    appBloc.callUsersStreams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: StreamBuilder(
          stream: appBloc.usersStream,
          builder: (context, AsyncSnapshot<List<User>?> snapshot){
            if(snapshot.hasData){
              if(snapshot.data!.isNotEmpty){
                return ListView.builder(
                  shrinkWrap: true,
                  /*gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCountOnWidth(context),
                  ),*/
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index){
                    return UserItem(user: snapshot.data![index]);
                  },
                );
              }
              return Center(child: Text(AppLocalizations.of(context, 'empty_request')));
            }
            return const LoadingView();
          },
        ),
      ),
    );
  }
}
