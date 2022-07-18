import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/common/constants.dart';
import 'package:to_do/common/themes.dart';

import '../Screens/components/hero_dialogue_route.dart';
import '_AddTodoPopupCard.dart';

class AddAct extends StatefulWidget {
  final id;

  const AddAct({Key? key, required this.id, }) : super(key: key);
  @override
  State<AddAct> createState() => _AddActState();
}

class _AddActState extends State<AddAct> {
  @override
  Widget build(BuildContext context) {
    final themeData =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? "DarkTheme"
            : "LightTheme";
    Size size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          shadowColor: themeData == "DarkTheme" ? kCardColorDark : Colors.white,
          color: themeData == "DarkTheme" ? kCardColorDark : Colors.white,
          child: Container(
            width: constraints.maxWidth / 2 - 10,
            height: size.height * 0.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
                child: IconButton(
              icon: Icon(
                Icons.add,
                color: kTextLightColor,
              ),
              onPressed: () {
                Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                  return AddCard(
                    themeData : themeData,
                    id: widget.id,
                  );
                }));
              },
            )),
          ),
        );
      },
    );
  }
}
