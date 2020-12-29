import 'package:flutter/material.dart';
import 'AnimatedTabBar.dart';
import './AnimatedTabController.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AnimatedTabController animatedTabController;
  Color backgroundColor;

  @override
  void initState() {
    super.initState();
    animatedTabController = AnimatedTabController();
    animatedTabController.addListener(() {
      backgroundColor = animatedTabController.selectedItem.color;
      setState(() {});
    });
    backgroundColor = animatedTabController.selectedItem.color;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInCubic,
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(color: backgroundColor),
        child: FractionallySizedBox(
            alignment: Alignment.center,
            widthFactor: 0.8,
            heightFactor: 0.5,
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey[800], width: 4), borderRadius: BorderRadius.all(Radius.circular(20))),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: Stack(children: [Align(alignment: Alignment.bottomCenter, child: AnimatedTabBar(this.animatedTabController))]),
              ),
            )));
  }
}
