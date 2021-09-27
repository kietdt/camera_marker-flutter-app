import 'package:camera_marker/database/database_ctr.dart';
import 'package:camera_marker/manager/resource_manager.dart';
import 'package:camera_marker/manager/route_manager.dart';
import 'package:camera_marker/view/screen/statistics/statistics_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera_marker/main.dart' as mainApp;

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await mainApp.main();
  });
  group("Group smart OTP", () {
    testWidgets("Firebase OTP will be sent on the first time",
        (WidgetTester tester) async {
      await tester.pumpWidget(mainApp.MyApp());

      Key keyPage = Key("key_page");
      StatisticsPage page = StatisticsPage(key: keyPage);
      await tester.pumpWidget(page);

      // StatefulElement element = tester.element(find.byKey(keyPage));

      // PhoneOTPVerifyState state = element.state as PhoneOTPVerifyState;
      // PhoneOTPVerifyProvider provider = state.provider;

      // test("Phone true", () {
      //   expect(state.widget.phone, "0987654325");
      // });

      // expect(state.widget, equals(page));
    });
  });
}
