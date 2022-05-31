import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'db/db_helper.dart';
import 'di/app_binding.dart';
import 'modules/note_list_screen/note_list_screen.dart';

final _firebaseAuth = Get.put(FirebaseAuth.instance);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Get.putAsync(() => DbHelper().init());
  _firebaseAuth.authStateChanges().listen((user) {
    if (user != null) {
      runApp(MyApp(auth: true, uid: user.uid,));
    } else {
      runApp(const MyApp(auth: false,));
    }
  });
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.auth = false, this.uid}) : super(key: key);

  final bool auth;
  final String? uid;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBinding(),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NoteListScreen(),
    );
  }
}
