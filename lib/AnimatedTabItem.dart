import 'package:flutter/material.dart';
import './AnimatedTabController.dart';

class AnimatedTabItem extends StatefulWidget {
  final AnimatedTabController animatedTabController;
  final TabInfo tabInfo;
  AnimatedTabItem({this.animatedTabController, this.tabInfo}) : super(key: tabInfo.key);

  @override
  _AnimatedTabItemState createState() => _AnimatedTabItemState();
}

class _AnimatedTabItemState extends State<AnimatedTabItem> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<Color> backgroundColor;
  Animation<double> y;
  bool isMounted;

  @override
  initState() {
    super.initState();

    animationController = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    animationController.addListener(() {
      setState(() {});
    });
    CurvedAnimation curvedAnimation = CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
    backgroundColor = ColorTween(begin: widget.tabInfo.color.withOpacity(0.0), end: widget.tabInfo.color).animate(curvedAnimation);
    y = Tween<double>(begin: 0.0, end: -8).animate(curvedAnimation);

    widget.animatedTabController.addListener(() {
      (widget.animatedTabController.selectedItemKey == widget.tabInfo.key) ? animationController.forward() : animationController.reverse();
    });

    if ((widget.animatedTabController.selectedItemKey == widget.tabInfo.key)) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.animatedTabController.selectItemKey(widget.tabInfo.key);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.animatedTabController.selectItemKey(widget.tabInfo.key);
      },
      child: Transform.translate(
        offset: Offset(0.0, y.value),
        child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: backgroundColor.value, borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Icon(widget.tabInfo.iconData, color: Colors.white, size: 20)),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
