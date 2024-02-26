import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Mybottomnav extends StatelessWidget {
  void Function(int)? onTabChange;

  Mybottomnav({super.key,required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: GNav(
        color: const Color(0xff002233),
        activeColor: Colors.white,
        backgroundColor: Colors.white,
        tabActiveBorder: Border.all(color: Colors.grey.shade600),
        tabBackgroundColor: const Color(0xff002233),
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 30,
        gap: 10,
        onTabChange: (value)=> onTabChange!(value),
        tabs: const [
          GButton(icon: Icons.home,
            text: 'Home', ),
          GButton(icon: Icons.newspaper,
            text: 'Notice',),
          GButton(icon: Icons.person,
            text: 'Profile',),
        ],
      ),
    );
  }
}
