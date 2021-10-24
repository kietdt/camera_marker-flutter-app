import 'package:camera_marker/manager/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'database/database_ctr.dart';
import 'manager/resource_manager.dart';

Future<void> main() async {
  // Required for observing the lifecycle state from the widgets layer.
  WidgetsFlutterBinding.ensureInitialized();
  // Keep rotation at portrait mode.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //initRessource
  await ResourceManager().init();
  RouteManager().init();
  //init database
  await DataBaseCtr().init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: ResourceManager().appName,
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      //   scaffoldBackgroundColor: Color.fromARGB(245, 31, 31, 31),
      //   textTheme: TextTheme(bodyText2: TextStyle(color: Colors.white)),
      // ),
      navigatorObservers: [RouteManager().navigatorOnservers],
      initialRoute: RouteManager().initialRoute,
      onGenerateRoute: RouteManager().onGenerateRoute,
    );
  }
}
