import 'dart:io';

import 'package:newsapp/models/user.dart';
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
  late AuthNotifier authNotifier;
  //late File image;
  late User thisuser;
  String newphone = "";
  String newname = "";
  String email = "";

  String password = "";
  bool loading = false;
  String error = "";
  String phone = "";
  String name = "";
  bool canUpdate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    thisuser = authNotifier.user;
  }

  // File? image;
  // Future pickImage(ImageSource source) async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: source);
  //     if (image == null) return;

  //     final imagetep = File(image.path);
  //     setState(() {
  //       this.image = imagetep;
  //     });
  //   } on PlatformException catch (e) {
  //     print('failed to pick image $e');
  //   }
  // }

  // Future pickImage(ImageSource source) async {

  //   try {
  //     final image = await ImagePicker()
  //         .pickImage(source: source, preferredCameraDevice: CameraDevice.front);
  //     if (image == null) return;

  //     final imagetep = File(image.path);
  //     setState(() {
  //       this.image = imagetep;
  //     });
  //   } on PlatformException catch (e) {
  //     print('failed to pick image $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // updatedetails(AuthNotifier authNotifier, User user, name, phone) async {
    //   setState(() {
    //     loading = true;
    //   });
    //   RequestResult result =
    //       await userUpdateDetails(authNotifier, user, name, phone);

    //   if (result.ok) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(result.data),
    //         duration: Duration(milliseconds: 2000),
    //         // padding: EdgeInsets.all(10),

    //         behavior: SnackBarBehavior.floating,
    //         shape:
    //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //       ),
    //     );

    //     setState(() {
    //       thisuser.name = name;
    //       thisuser.phone = phone;
    //       UserPreferences().saveUser(thisuser);
    //       authNotifier.setUser(thisuser);

    //       loading = false;
    //     });
    //     Navigator.pop(context);
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(result.data),
    //         backgroundColor: Colors.red,
    //         duration: Duration(milliseconds: 2000),
    //         // padding: EdgeInsets.all(10),

    //         behavior: SnackBarBehavior.floating,
    //         shape:
    //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    //       ),
    //     );
    //     setState(() {
    //       error = result.data;
    //       loading = false;
    //     });
    //     Navigator.pop(context);
    //   }
    // }

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
            fontFamily: 'Integral',
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        // actions: [
        //   InkWell(
        //     onTap: () {
        //       Navigator.pushNamed(context, '/notification');
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
        //       child: Container(
        //         width: 36,
        //         height: 36,
        //         decoration: const BoxDecoration(
        //           color: Color(0xffF9F9F9),
        //           shape: BoxShape.circle,
        //         ),
        //         child: Image.asset('assets/images/notification.png'),
        //       ),
        //     ),
        //   ),
        //  ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Name',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Nunito',
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              SizedBox(
                                  // width: 250,
                                  child: Text(
                                'N/A',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal),
                              )),
                            ],
                          ),
                          // Spacer(),
                          ElevatedButton(
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Nunito',
                                    color: thisuser.id == 0
                                        ? Colors.black
                                        : primaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return Colors.grey;
                                    }

                                    return primaryLight; // Use the component's default.
                                  },
                                ),
                              ),
                              onPressed: () {}),
                        ],
                      ),
                      const SizedBox(height: 24),
                      //  Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //  children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Phone Number',
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Nunito',
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          thisuser.id == 0
                              ? const Text(
                                  'N/A',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal),
                                )
                              : SizedBox(
                                  //   width: 250,
                                  child: Text(
                                    thisuser.phone.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                        ],
                      ),
                      // ],
                      //  ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email Address',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Nunito',
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              thisuser.id == 0
                                  ? const Text(
                                      'N/A',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal),
                                    )
                                  : SizedBox(
                                      //   width: 250,
                                      child: Text(
                                        thisuser.email.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1.0,
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Address',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Nunito',
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              SizedBox(
                                // width: 250,
                                child: Text(
                                  'N/A',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ],
                          ),
                          // Spacer(),
                          ElevatedButton(
                            child: Text(
                              "Change",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Nunito',
                                  color: thisuser.id == 0
                                      ? Colors.black
                                      : primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return Colors.grey;
                                  }

                                  return primaryLight; // Use the component's default.
                                },
                              ),
                            ),
                            onPressed: thisuser.id == 0
                                ? null
                                : () {
                                    // buildaddressBottomSheet(context);
                                    Navigator.pushNamed(context, '/address');
                                  },
                          ),
                        ],
                      ),
                    ],
                  )),
              const Padding(
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 10.0, 10.0),
                child: Divider(
                  thickness: 1.0,
                ),
              ),
              Column(
                children: [
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                    title: const Text(
                      'Coupons',
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.pushNamed(context, '/coupon');
                    },
                  ),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                    title: const Text(
                      'Manage Addresses',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      Navigator.pushNamed(context, '/address');
                    },
                  ),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                    title: const Text(
                      'Customer Support',
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      showBottomSheet(
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewPadding.bottom,
                              ),
                              child: Material(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        'Customer Support',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                        child: const Text(
                                          "WhatsApp",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Nunito',
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal),
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  const Size(300, 55)),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xfff7B0304)),
                                          textStyle: MaterialStateProperty.all(
                                            const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {},
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                        child: const Text(
                                          "Phone Call",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Nunito',
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal),
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  const Size(300, 55)),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  primaryColor),
                                          textStyle: MaterialStateProperty.all(
                                            const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  ),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                    title: const Text(
                      'Settings',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    //Modal for address bottom sheet
  }
}
