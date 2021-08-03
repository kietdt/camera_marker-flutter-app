import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:camera_marker/screen/camera_transform/yuv_transform_screen.dart';

Future<void> main() async {
  // Required for observing the lifecycle state from the widgets layer.
  WidgetsFlutterBinding.ensureInitialized();
  // Keep rotation at portrait mode.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'YUV Transformation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color.fromARGB(245, 31, 31, 31),
        textTheme: TextTheme(bodyText2: TextStyle(color: Colors.white)),
      ),
      home: YuvTransformScreen(),
      getPages: [
        GetPage(name: 'dash_board', page: () => YuvTransformScreen()),
        // GetPage(name: '/second', page: () => Second()),
      ],
    );
  }
}
