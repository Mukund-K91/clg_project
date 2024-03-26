
import 'package:clg_project/reusable_widget/reusable_textfield.dart';
import 'package:clg_project/student/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeMain extends StatelessWidget {
  const HomeMain({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (v){
        print("On Pop Scope--> $v");
      },
      child: Scaffold(
        body: Column(
          children: [
            const Image(
              image: AssetImage("assets/images/home_screen.png"),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color(0xff002233),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "eCollege",
                        style: TextStyle(fontSize: 35, color: Colors.white),
                      ),
                      const Text(
                        "eCollege Serves You Virtual Education At Your home",
                        style: TextStyle(
                            fontSize: 15, letterSpacing: 5, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Reusablebutton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login("Student"),
                                ));
                          },
                          Style: false,
                          child: const Text(
                            "LOGIN AS STUDENT",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Reusablebutton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login("Faculty"),
                                ));
                          },
                          Style: true,
                          child: const Text(
                            "LOGIN AS FACULTY",
                            style:
                            TextStyle(color: Color(0xff002233), fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
