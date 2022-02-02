import 'package:newsapp/notifiers/auth_notifier.dart';
import 'package:newsapp/services/api.dart';
import 'package:newsapp/services/http.dart';
import 'package:newsapp/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:unicons/unicons.dart';
// import 'package:unicons/unicons.dart';
// import 'package:top_snackbar_flutter/custom_snack_bar.dart';
// import 'package:top_snackbar_flutter/tap_bounce_container.dart';
// import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  bool hidePassword = true;

  String email = "";
  String password = "";
  bool rememberme = false;
  bool loading = false;
  String error = "";

  TextEditingController _textcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    signIn(email, password) async {
      setState(() {
        loading = true;
      });
      RequestResult result = await loginUser(email, password);

      if (result.ok) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/applayout",
          (route) => false,
        );
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          error = result.data;
          loading = false;
        });
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 50),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Sign in",
                        style: TextStyle(
                            fontSize: 23,
                            color: Color(0xff333333),
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal),
                      ),
                      IconButton(
                        icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: greyColor.withOpacity(0.5),
                              ),
                            ),
                            child: Icon(UniconsLine.times, color: greyColor)),
                        onPressed: () {},
                        splashRadius: 20.0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          UniconsLine.google,
                          color: greyColor,
                          size: 16,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Sign in with Google",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Nunito',
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: greyColor)),
                      ),
                      fixedSize:
                          MaterialStateProperty.all(Size(double.maxFinite, 40)),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey;
                          }

                          return Colors
                              .transparent; // Use the component's default.
                        },
                      ),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        error = '';
                      });
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (formKey.currentState!.validate()) {
                        // signUp(authNotifier, fullname, phone, email,
                        //     password);
                      }
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Divider(
                      color: greyColor,
                      height: 3,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'Email',
                      style: TextStyle(
                        height: 1.5,
                      ),
                    ),
                  ),
                  TextFormField(
                      style: TextStyle(
                        height: 1.5,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return '⚠️ Email is required';
                        }

                        if (!RegExp(
                                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                            .hasMatch(value)) {
                          return '⚠️ Please enter a valid email address';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      autofocus: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: "Email address",
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          color: Color(0xff8D9091),
                        ),
                        focusColor: primaryColor,
                        fillColor: primaryColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: 5,
                          ),
                          borderRadius: BorderRadius.circular((10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular((10)),
                        ),
                      )
                      //   border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10)),
                      // ),

                      ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'Password',
                      style: TextStyle(
                        height: 1.5,
                      ),
                    ),
                  ),
                  TextFormField(
                      style: TextStyle(
                        height: 1.4,
                      ),
                      controller: _textcontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "⚠️ Enter a password";
                        }

                        if (value.length < 8 || value.length > 20) {
                          return '⚠️ Password must be between 8 and 20 characters';
                        }

                        if (error.isNotEmpty) {
                          return '⚠️ ' + error;
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                          error = "";
                        });
                      },
                      obscureText: hidePassword,
                      autofocus: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: "at least 8 characters",
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          color: Color(0xff8D9091),
                        ),
                        suffixIcon: InkWell(
                          child: Icon(
                            hidePassword
                                ? UniconsLine.eye_slash
                                : UniconsLine.eye,
                            color: const Color(0xff14142B),
                          ),
                          onTap: _togglePassword,
                        ),
                        focusColor: primaryColor,
                        fillColor: primaryColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: 5,
                          ),
                          borderRadius: BorderRadius.circular((10)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular((10)),
                        ),
                      )
                      //   border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10)),
                      // ),
                      ),

                  const SizedBox(
                    height: 0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: rememberme,
                        side: BorderSide(color: greyColor, width: 1),
                        onChanged: (val) {
                          setState(() {
                            rememberme = !rememberme;
                          });
                        },
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 16),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'I agree with ',
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                                text: 'Terms  ',
                                style: TextStyle(color: primaryColor)),
                            TextSpan(
                                text: 'and  ',
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                                text: 'Privacy  ',
                                style: TextStyle(color: primaryColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Text(
                  //   "Creating an account means you have accepted our"
                  //       " \n Terms & conditions",
                  //   style: TextStyle(
                  //       fontSize: 12,
                  //       fontFamily: 'Gordita',
                  //       // color: Colors.white,
                  //       fontWeight: FontWeight.w500,
                  //       fontStyle: FontStyle.normal),
                  // ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Sign in",
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      fixedSize:
                          MaterialStateProperty.all(Size(double.maxFinite, 50)),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey;
                          }

                          return primaryColor; // Use the component's default.
                        },
                      ),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: loading
                        ? null
                        : () {
                            setState(() {
                              error = '';
                            });
                            FocusManager.instance.primaryFocus?.unfocus();

                            if (formKey.currentState!.validate()) {
                              signIn(email, password);
                            }
                          },
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Divider(
                      color: greyColor,
                      height: 3,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff8D9091),
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal),
                          ),
                          SizedBox(height: 5),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/sign_up');
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: primaryColor,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _togglePassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }
}
