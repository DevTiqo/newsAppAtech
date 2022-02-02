import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapp/models/user.dart' as User2;
import 'package:newsapp/notifiers/auth_notifier.dart';
import 'package:newsapp/services/api.dart';
import 'package:newsapp/services/http.dart';
import 'package:newsapp/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod/riverpod.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();

  //late File image;

  late User2.User thisuser;

  @override
  void initState() {
    super.initState();

    thisuser = User2.User(id: 0, name: 'name', email: 'email', phone: '00');
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    User? currentUser = await FirebaseAuth.instance.currentUser!;
    thisuser.name = currentUser.displayName!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 23,
        title: const Text(
          'Account',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/user.png',
                        height: 120,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      thisuser.name,
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                  Center(
                    child: Text(
                      '"News Reader"',
                      style: TextStyle(
                          fontSize: 15,
                          color: greyColor,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 30.0),
                        title: const Text(
                          'Logout',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal),
                        ),
                        onTap: () {
                          signout();
                        },
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );

    //Modal for address bottom sheet
  }
}
