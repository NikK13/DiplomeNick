import 'package:auto_route/auto_route.dart';
import 'package:diplome_nick/data/utils/guards.dart';
import 'package:diplome_nick/ui/fragments/flights.dart';
import 'package:diplome_nick/ui/fragments/settings.dart';
import 'package:diplome_nick/ui/fragments/tickets.dart';
import 'package:diplome_nick/ui/fragments/users.dart';
import 'package:diplome_nick/ui/pages/bookings.dart';
import 'package:diplome_nick/ui/pages/home.dart';
import 'package:diplome_nick/ui/pages/login.dart';

const String loginPath = "/login";
const String bookingsPath = "/bookings";
const String settingsPagePath = "/settings";
const String homePath = "";

const String usersPath = "users";
const String ticketsPath = "tickets";
const String flightsPath = "flights";
const String settingsPath = "settings";

@AdaptiveAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(
      initial: true,
      page: LoginPage,
      path: loginPath,
      guards: [CheckIfUserLoggedIn]
    ),
    AutoRoute(
      page: HomePage,
      path: homePath,
      children: [
        AutoRoute(
          initial: true,
          page: FlightsFragment,
          path: flightsPath,
        ),
        AutoRoute(
          page: TicketsFragment,
          path: ticketsPath,
        ),
        AutoRoute(
          page: UsersFragment,
          path: usersPath,
        ),
        AutoRoute(
          name: "SettingsFragmentRoute",
          page: SettingsPage,
          path: settingsPath,
        ),
      ],
      guards: [CheckIfUserLoggedIn]
    ),
    AutoRoute(
      name: "SettingsPageRoute",
      page: SettingsPage,
      path: settingsPagePath,
    ),
    AutoRoute(
      page: MyBookingsPage,
      path: bookingsPath,
    ),
    RedirectRoute(path: '*', redirectTo: "/")
  ],
)

class $AppRouter {}