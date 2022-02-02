import 'package:newsapp/models/user.dart';
import 'package:newsapp/notifiers/auth_notifier.dart';
import 'package:newsapp/pages/sign_in.dart';
import 'package:newsapp/services/api.dart';
import 'package:newsapp/services/http.dart';
import 'package:newsapp/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shimmer/shimmer.dart';

class SavedScreen extends StatefulWidget {
  dynamic callback;
  SavedScreen({Key? key, required this.callback}) : super(key: key);

  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  _SavedScreenState();

  bool hidePassword = true;
  TextEditingController _textcontroller = TextEditingController();

  String email = "";
  String password = "";
  bool loading = false;
  String error = "";
  late dynamic myfuture;

  @override
  void initState() {
    super.initState();
    myfuture = call();
  }

  call() async {
    return [true, {}];
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        // titleSpacing: 23,
        centerTitle: true,
        // leading: GestureDetector(
        //   onTap: () {
        //     _scaffoldKey.currentState!.openDrawer();
        //   },
        //   child: Image.asset(
        //     'assets/images/sort.png',
        //   ),
        // ),
        title: const Text(
          'Your Saved News',
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'Nunito',
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal),
        ),
      ),

      body: FutureBuilder(
        future: myfuture,
        builder: (C, snap) {
          // Checking if future is resolved

          if (snap.connectionState != ConnectionState.waiting) {
            // If we got an error
            if (snap.hasError) {
              return Center(
                child: Text(
                  '${snap.error} occured',
                  style: const TextStyle(fontSize: 18),
                ),
              );

              // if we got our data
            } else if (snap.hasData) {
              // Extracting data from snap object
              // menu = snap.data! as List<List<Product>>;

              return Center(
                child: Text(
                  'You have no saved items',
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal),
                ),
              );
            }

            return Container();
          } else {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.loose,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[350]!,
                      highlightColor: Colors.grey[100]!,
                      enabled: true,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (_, __) => Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Container(
                                  // width: 150.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 150.0,
                                    height: 250.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                  ),
                                  Container(
                                    width: 150.0,
                                    height: 250.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        itemCount: 2,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      // : SingleChildScrollView(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.stretch,
      //       mainAxisSize: MainAxisSize.max,
      //       children: [
      //         SavedBar(
      //           name: 'Asun Spaghetti + Plantain',
      //           img: 'assets/images/sardine_sandwich.png',
      //           price: 800,
      //         ),
      //       ],
      //     ),
      //   ),
    );
  }

  void _togglePassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }
}
