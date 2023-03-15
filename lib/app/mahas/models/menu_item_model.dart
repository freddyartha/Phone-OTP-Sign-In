import 'package:flutter/material.dart';

class MenuItemModel {
  final String title;
  final IconData icon;
  final GestureTapCallback? onTab;

  MenuItemModel(this.title, this.icon, this.onTab);
}

class MenuModel {
  final String title;
  final GestureTapCallback? onTab;

  MenuModel(this.title, this.onTab);
}
