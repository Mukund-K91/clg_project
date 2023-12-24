import 'dart:async';
import 'package:clg_project/demo.dart';
import 'package:clg_project/splash_screen.dart';
import 'package:clg_project/student/login.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//HET
//MUKUND
//SAMEER K
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // late StreamSubscription subscription;
  // var isConnected = false;
  // bool isAlert = false;
  // late ConnectivityResult result;
  // late StreamSubscription subscription;
  // var isConnected = false;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   startStream();
  // }
  // checkInternet() async {
  //   result =await Connectivity().checkConnectivity();
  //   if (result != ConnectivityResult.none) {
  //     isConnected = true;
  //   } else {
  //     isConnected = false;
  //     Text('no');
  //     showDialogBox();
  //   }
  //   setState(() {});
  // }
  // showDialogBox() {
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) => CupertinoAlertDialog(
  //         title: Text('NO'),
  //         content: Text('Check'),
  //         actions: [
  //           CupertinoButton.filled(child: Text('Retry'), onPressed: () {
  //             Navigator.pop(context);
  //             checkInternet();
  //           })
  //         ],
  //       ));
  // }
  // startStream(){
  //   subscription=Connectivity().onConnectivityChanged.listen((event) {
  //     checkInternet();
  //   });
  // }
  // void initState() {
  //   getConnectivity();
  //   super.initState();
  // }

  // getConnectivity() => subscription = Connectivity()
  //         .onConnectivityChanged
  //         .listen((ConnectivityResult result) async {
  //       isConnected = await InternetConnectionChecker().hasConnection;
  //       if (!isConnected && isAlert == false) {
  //         AwesomeDialog(
  //             context: context,
  //             dialogType: DialogType.error,
  //             animType: AnimType.bottomSlide,
  //             showCloseIcon: true,
  //             btnOkOnPress: () {
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => const HomeMain(),
  //                   ));
  //             },
  //             title: "Not Found",
  //             )
  //             .show();
  //         setState(() {
  //           isAlert = true;
  //         });
  //       }
  //     });

  // @override
  // void dispose() {
  //   subscription.cancel();
  //   super.dispose();
  // }
  @override



  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff002233)),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
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
                                  builder: (context) => Login("Student"),
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
