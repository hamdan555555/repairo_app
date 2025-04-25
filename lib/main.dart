import 'package:breaking_project/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
              selectionColor: Color.fromARGB(255, 124, 155, 207),
              selectionHandleColor: Color.fromARGB(255, 124, 155, 207),
              cursorColor: Color.fromARGB(255, 124, 155, 207))),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: 'login',
    );
  }
}
