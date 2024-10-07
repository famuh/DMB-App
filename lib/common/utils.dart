import 'package:flutter/material.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

double mediaQueryWidth(context) => MediaQuery.of(context).size.width;