import 'package:flutter/material.dart';

class TabInfo {
  GlobalKey key;
  IconData iconData;
  Color color;

  TabInfo({this.iconData, this.color}) {
    key = GlobalKey();
  }
}

class AnimatedTabController extends ChangeNotifier {
  GlobalKey selectedItemKey;

  List<TabInfo> tabInfos;

  AnimatedTabController() {
    tabInfos = [
      TabInfo(color: Colors.amber[400], iconData: Icons.phone_outlined),
      TabInfo(color: Colors.red[400], iconData: Icons.email_outlined),
      TabInfo(color: Colors.green[400], iconData: Icons.photo_camera_outlined),
      TabInfo(color: Colors.yellow[400], iconData: Icons.settings_outlined)
    ];

    selectedItemKey = tabInfos[2].key;
  }

  TabInfo get selectedItem => tabInfos.firstWhere((tabInfo) => tabInfo.key == selectedItemKey);

  void selectItemKey(itemKey) {
    selectedItemKey = itemKey;
    notifyListeners();
  }
}
