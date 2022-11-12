// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:diplome_nick/data/utils/guards.dart' as _i8;
import 'package:diplome_nick/ui/fragments/flights.dart' as _i5;
import 'package:diplome_nick/ui/fragments/settings.dart' as _i3;
import 'package:diplome_nick/ui/fragments/tickets.dart' as _i4;
import 'package:diplome_nick/ui/pages/home.dart' as _i2;
import 'package:diplome_nick/ui/pages/login.dart' as _i1;
import 'package:flutter/material.dart' as _i7;

class AppRouter extends _i6.RootStackRouter {
  AppRouter({
    _i7.GlobalKey<_i7.NavigatorState>? navigatorKey,
    required this.checkIfUserLoggedIn,
  }) : super(navigatorKey);

  final _i8.CheckIfUserLoggedIn checkIfUserLoggedIn;

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    LoginPageRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.LoginPage(),
      );
    },
    HomePageRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomePage(),
      );
    },
    SettingsPageRoute.name: (routeData) {
      final args = routeData.argsAs<SettingsPageRouteArgs>(
          orElse: () => const SettingsPageRouteArgs());
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i3.SettingsPage(
          key: args.key,
          isFullPage: args.isFullPage,
        ),
      );
    },
    TicketsFragmentRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.TicketsFragment(),
      );
    },
    FlightsFragmentRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.FlightsFragment(),
      );
    },
    SettingsFragmentRoute.name: (routeData) {
      final args = routeData.argsAs<SettingsFragmentRouteArgs>(
          orElse: () => const SettingsFragmentRouteArgs());
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i3.SettingsPage(
          key: args.key,
          isFullPage: args.isFullPage,
        ),
      );
    },
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/login',
          fullMatch: true,
        ),
        _i6.RouteConfig(
          LoginPageRoute.name,
          path: '/login',
          guards: [checkIfUserLoggedIn],
        ),
        _i6.RouteConfig(
          HomePageRoute.name,
          path: '',
          guards: [checkIfUserLoggedIn],
          children: [
            _i6.RouteConfig(
              '#redirect',
              path: '',
              parent: HomePageRoute.name,
              redirectTo: 'tickets',
              fullMatch: true,
            ),
            _i6.RouteConfig(
              TicketsFragmentRoute.name,
              path: 'tickets',
              parent: HomePageRoute.name,
            ),
            _i6.RouteConfig(
              FlightsFragmentRoute.name,
              path: 'flights',
              parent: HomePageRoute.name,
            ),
            _i6.RouteConfig(
              SettingsFragmentRoute.name,
              path: 'settings',
              parent: HomePageRoute.name,
            ),
          ],
        ),
        _i6.RouteConfig(
          SettingsPageRoute.name,
          path: '/settings',
        ),
        _i6.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.LoginPage]
class LoginPageRoute extends _i6.PageRouteInfo<void> {
  const LoginPageRoute()
      : super(
          LoginPageRoute.name,
          path: '/login',
        );

  static const String name = 'LoginPageRoute';
}

/// generated route for
/// [_i2.HomePage]
class HomePageRoute extends _i6.PageRouteInfo<void> {
  const HomePageRoute({List<_i6.PageRouteInfo>? children})
      : super(
          HomePageRoute.name,
          path: '',
          initialChildren: children,
        );

  static const String name = 'HomePageRoute';
}

/// generated route for
/// [_i3.SettingsPage]
class SettingsPageRoute extends _i6.PageRouteInfo<SettingsPageRouteArgs> {
  SettingsPageRoute({
    _i7.Key? key,
    bool isFullPage = false,
  }) : super(
          SettingsPageRoute.name,
          path: '/settings',
          args: SettingsPageRouteArgs(
            key: key,
            isFullPage: isFullPage,
          ),
        );

  static const String name = 'SettingsPageRoute';
}

class SettingsPageRouteArgs {
  const SettingsPageRouteArgs({
    this.key,
    this.isFullPage = false,
  });

  final _i7.Key? key;

  final bool isFullPage;

  @override
  String toString() {
    return 'SettingsPageRouteArgs{key: $key, isFullPage: $isFullPage}';
  }
}

/// generated route for
/// [_i4.TicketsFragment]
class TicketsFragmentRoute extends _i6.PageRouteInfo<void> {
  const TicketsFragmentRoute()
      : super(
          TicketsFragmentRoute.name,
          path: 'tickets',
        );

  static const String name = 'TicketsFragmentRoute';
}

/// generated route for
/// [_i5.FlightsFragment]
class FlightsFragmentRoute extends _i6.PageRouteInfo<void> {
  const FlightsFragmentRoute()
      : super(
          FlightsFragmentRoute.name,
          path: 'flights',
        );

  static const String name = 'FlightsFragmentRoute';
}

/// generated route for
/// [_i3.SettingsPage]
class SettingsFragmentRoute
    extends _i6.PageRouteInfo<SettingsFragmentRouteArgs> {
  SettingsFragmentRoute({
    _i7.Key? key,
    bool isFullPage = false,
  }) : super(
          SettingsFragmentRoute.name,
          path: 'settings',
          args: SettingsFragmentRouteArgs(
            key: key,
            isFullPage: isFullPage,
          ),
        );

  static const String name = 'SettingsFragmentRoute';
}

class SettingsFragmentRouteArgs {
  const SettingsFragmentRouteArgs({
    this.key,
    this.isFullPage = false,
  });

  final _i7.Key? key;

  final bool isFullPage;

  @override
  String toString() {
    return 'SettingsFragmentRouteArgs{key: $key, isFullPage: $isFullPage}';
  }
}
