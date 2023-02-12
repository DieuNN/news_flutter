import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_flutter/utils/constants.dart';
import 'package:news_flutter/utils/global.dart';
import 'package:news_flutter/screens/home_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  List<String> availableCountries = [
    Constants.USA,
    Constants.France,
    Constants.Australia,
    Constants.Canada,
    Constants.China,
    Constants.Germany,
    Constants.Italy,
    Constants.Japan,
    Constants.Singapore
  ];
  String? selected;

  List<DropdownMenuItem<String>> _createList() {
    return availableCountries
        .map((e) => DropdownMenuItem(
              child: Text(e),
              value: e,
            ))
        .toList();
  }

  late var dropdown;

  @override
  void initState() {
    super.initState();
    selected = GetStorage().read("currentCountry");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Settings',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                GlobalVariables.currentLanguage = selected as String;
                GetStorage().write("currentCountry", selected);
                Fluttertoast.showToast(msg: "Saved successfully");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false);
              },
              icon: Icon(
                Icons.save,
                color: Colors.black,
              ))
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Country",
                  style: TextStyle(fontSize: 20),
                ),
                DropdownButton(
                  items: _createList(),
                  value: selected,
                  onChanged: (String? value) {
                    setState(() {
                      selected = value;
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
