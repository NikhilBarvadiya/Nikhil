// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String? title;
  final GestureTapCallback? onPress;
  final IconData? icon;
  final Color? iconColor;
  final bool? showArrow;
  final String? subtitle;

  const MenuCard({Key? key, this.title, this.onPress, this.icon, this.iconColor = Colors.grey, this.showArrow = true, this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress!,
      leading: CircleAvatar(child: Icon(icon, color: iconColor,size: 20),
          backgroundColor: Colors.transparent),
      title: Text("$title"),
      subtitle: subtitle != null ? Text("${subtitle.toString()}") : null,
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14,color: Colors.grey,),
    );
  }
}
