import 'package:flutter/material.dart';
import './AnimatedTabItem.dart';
import './AnimatedTabController.dart';

class AnimatedTabBar extends StatefulWidget {
  final AnimatedTabController animatedTabController;

  AnimatedTabBar(this.animatedTabController);

  @override
  _AnimatedTabBarState createState() => _AnimatedTabBarState();
}

class _AnimatedTabBarState extends State<AnimatedTabBar> with SingleTickerProviderStateMixin {
  Animation<double> currentX;
  double fromX;
  double toX;

  AnimationController animationContoller;

  @override
  void initState() {
    super.initState();

    animationContoller = AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    CurvedAnimation curvedAnimation = CurvedAnimation(parent: animationContoller, curve: Curves.easeOutCubic);

    fromX = 0.0;
    toX = 0.0;
    currentX = Tween<double>(begin: fromX, end: toX).animate(curvedAnimation);

    animationContoller.addListener(() {
      setState(() {});
    });

    animationContoller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        fromX = toX;
      }
    });

    widget.animatedTabController.addListener(() {
      Size screenSize = MediaQuery.of(context).size;
      RenderBox parentRenderBox = context.findRenderObject();

      RenderBox renderBox = widget.animatedTabController.selectedItem.key.currentContext.findRenderObject();

      toX = renderBox.localToGlobal(Offset.zero).dx + renderBox.size.width * 0.5 - (screenSize.width - parentRenderBox.size.width) * 0.5;

      currentX = Tween<double>(begin: fromX, end: toX).animate(curvedAnimation);

      animationContoller.value = 0;
      animationContoller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(color: Colors.grey[800]),
        child: CustomPaint(
          painter: FocusPainter(Offset(currentX.value, 0.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widget.animatedTabController.tabInfos.map((tabInfo) {
              return AnimatedTabItem(tabInfo: tabInfo, animatedTabController: widget.animatedTabController);
            }).toList(),
          ),
        ));
  }
}

class FocusPainter extends CustomPainter {
  Offset position;

  FocusPainter(this.position);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.grey[800];
    double width = 150;
    double height = 30;

    Path path = Path();

    canvas.translate(position.dx - width * 0.5, 1.0);

    Offset g1 = Offset(0.0, 0.0);
    Offset c1 = Offset(width * 0.25, 0.0);
    Offset c2 = Offset(width * 0.25, -height);
    Offset g2 = Offset(width * 0.5, -height);
    path.moveTo(g1.dx, g1.dy);
    path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, g2.dx, g2.dy);

    c1 = g2 + Offset(width * 0.25, 0.0);
    c2 = c1 + Offset(0.0, height);
    g2 = c2 + Offset(width * 0.25, 0.0);
    path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, g2.dx, g2.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
