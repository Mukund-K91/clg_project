import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Mybottomnav extends StatelessWidget {
  void Function(int)? onTabChange;

  Mybottomnav({super.key,required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: GNav(
        color: Colors.black,
        activeColor: Colors.black,
        tabActiveBorder: Border.all(color: Colors.grey.shade400),
        tabBackgroundColor: Colors.grey.shade400,
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 16,
        gap: 8,
        onTabChange: (value)=> onTabChange!(value),
        tabs: [
          GButton(icon: Icons.home,
            text: 'Shop',),
          GButton(icon: Icons.shopping_bag_outlined,
            text: 'Cart',)
        ],
      ),
    );
  }
}
