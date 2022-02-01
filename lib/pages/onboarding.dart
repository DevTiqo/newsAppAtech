import 'package:newsapp/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image.asset(
              //   'assets/images/Group.png',
              //   height: size.height * 0.53,
              // ),

              //Ther was an error loading this in SVG

              // SvgPicture.asset(
              //   'assets/images/Group.svg',

              //   height: size.height * 0.6,
              //   // color: Provider.of<ThemeNotifier>(context).darkTheme
              //   //     ? light.scaffoldBackgroundColor
              //   //     : primaryColor,
              // ),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Get the latest and Updated \n ',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    color: textColor,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                  children: [
                    TextSpan(
                        text: ' Articles',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 23,
                            color: primaryColor)),
                    TextSpan(
                      text: '  Easily With Us',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 23,
                          color: textColor),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              const SizedBox(
                width: 350,
                child: Text(
                  'Come on, get the latest articles and updates \n every day and add insight, your trusted \n knowledge with us',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    height: 1.5,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(1.0)),
                    elevation: MaterialStateProperty.all(0.0),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(primaryColor),
                    fixedSize: MaterialStateProperty.all(const Size(250, 60.0)),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 23,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pushNamed('/sign_up'),
                ),
              ),

              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
