import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_flutter/screens/home_screen.dart';

void main() async {
  init();
  runApp(const MyApp());
}

void init() async {
  await GetStorage.init();
  final box = await GetStorage();
  if (box.read("savedNews") == null) {
    await box.write("savedNews", "");
  }
  if(box.read("currentLanguage") == null) {
    await box.write("currentLanguage", "us");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
