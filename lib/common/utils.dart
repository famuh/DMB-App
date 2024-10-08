import 'package:flutter/material.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

double mediaQueryWidth(context) => MediaQuery.of(context).size.width;
double mediaQueryHeight(context) => MediaQuery.of(context).size.height;

Widget spaceH10 = const SizedBox(height: 10);
Widget spaceH30 = const SizedBox(height: 30);
Widget spaceH50 = const SizedBox(height: 50);