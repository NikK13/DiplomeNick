import 'package:auto_route/auto_route.dart';
import 'package:diplome_nick/data/utils/router.gr.dart';
import 'package:diplome_nick/main.dart';

class CheckIfUserLoggedIn extends AutoRouteGuard{
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final bool isLoggedIn = firebaseBloc.fbUser != null;
    //print("ROUTE: ${resolver.route.name}");
    if(resolver.route.name == LoginPageRoute.name){
      if (isLoggedIn) {
        router.replaceAll([const HomePageRoute()]);
      } else {
        resolver.next(true);
      }
    }
    else{
      if (isLoggedIn) {
        resolver.next(true);
      } else {
        loadingFuture = Future.value(true);
        router.replaceAll([const LoginPageRoute()]);
      }
    }
  }
}