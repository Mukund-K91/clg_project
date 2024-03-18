import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;
  final VoidCallback? leadingAction;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.leadingIcon,
    this.leadingAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white, size: 25),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      toolbarHeight: 150,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(80),
          bottomRight: Radius.circular(80),
        ),
      ),
      centerTitle: true,
      title: Text(
        title,
      ),
      leading: leadingIcon != null
          ? IconButton(
        icon: Icon(leadingIcon),
        onPressed: leadingAction ?? () {},
      )
          : null,
      backgroundColor: Color(0xff002233),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(150);
}
