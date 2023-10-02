import 'package:clg_project/Material.dart';
import 'package:clg_project/home_screen.dart';
import 'package:clg_project/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff002233)),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: FilesUpload()
        // Profile('koladiyamukund76@gmail.com')
        // Dashboard('student', 'abc@gmail.com'),
        );
  }
}

class HomeMain extends StatelessWidget {
  const HomeMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              backgroundColor: Colors.transparent,
                              side: const BorderSide(color: Colors.white)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login("student"),
                                ));
                          },
                          child: const Text(
                            "LOGIN AS STUDENT",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login("Faculty"),
                                ));
                          },
                          child: const Text(
                            "LOGIN AS FACULTY",
                            style: TextStyle(
                                color: Color(0xff002233), fontSize: 15),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
