import 'package:newsapp/models/news.dart';
import 'package:newsapp/notifiers/auth_notifier.dart';
import 'package:newsapp/notifiers/news_notifier.dart';
import 'package:newsapp/pages/home/search_page.dart';
import 'package:newsapp/services/api.dart';
import 'package:newsapp/services/http.dart';
import 'package:newsapp/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unicons/unicons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late int day;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final String assetName = 'assets/images/cart.svg';

  late dynamic myfuture;

  String salutation = "";

  ScrollController _controller = new ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    day = DateTime.now().weekday;
    print("Day : $day");
    // Adjust by subtracting 1 to compensate for Sunday
    day -= 1;

    // When day does not exist in the tabs
    if (day > lengthTab - 1) day = 0;

    // Change to a Monday if day is Sunday
    if (day < 0) day = 0;

    tabController = TabController(
      length: lengthTab,
      vsync: this,
    );

    tabController.index = day;
    super.initState();

    super.initState();
    salutation = greeting();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => print('Called After finished'));
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning ';
    }
    if (hour < 17) {
      return 'Good Afternoon ';
    }
    return 'Good Evening ';
  }

  String emoji() {
    var hour = DateTime.now().hour;

    if (hour < 17) {
      return 'assets/images/Goodmorning.svg';
    }
    return 'assets/images/Goodevening.svg';
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  void dispose() async {
    // authNotifier.dispose();
    super.dispose();
  }

  final int lengthTab = 6;
  late TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      //App Bar Data
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 23,
        title: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Hi,  GUEST",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Integral',
                    color: textColor,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal),
              ),
              SizedBox(
                height: 2.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    salutation,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Icon(UniconsSolid.airplay)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/cart');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xffF9F9F9),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(UniconsSolid.airplay),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 24, right: 24),
                    child: Container(
                      height: 48,
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        //Color(0xffF6F6F6),

                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextField(
                        readOnly: true,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage()));
                        },
                        decoration: InputDecoration(
                          // contentPadding: EdgeInsets.all(15),
                          hintText: "Search",
                          filled: true,
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Nunito',
                            color: Color(0xff8D9091),
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular((10)),
                          ),
                          fillColor: const Color(0xFFF6F6F6),
                          prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(UniconsLine.search)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  //Tab bar
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, bottom: 10),
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(
                          color: Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryColor),
                        controller: tabController,
                        labelColor: Colors.white,
                        unselectedLabelColor: const Color(0xff8D9091),
                        isScrollable: true,
                        tabs: [
                          Tab(
                            child: Container(

                                //// height: 38,
                                decoration: const BoxDecoration(
                                  //  border: Border.all(color: Color(0xff8D9091)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Center(
                                    child: Text(
                                      'Monday ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          // color: Colors.white,
                                          //color: Color(0xff8D9091),
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ),
                                )),
                          ),
                          Tab(
                            child: Container(

                                //  height: 38,
                                decoration: const BoxDecoration(
                                  // border: Border.all(color: Color(0xff8D9091)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Center(
                                    child: Text(
                                      'Tuesday',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ),
                                )),
                          ),
                          Tab(
                            child: Container(

                                //height: 38,
                                decoration: const BoxDecoration(
                                  // border: Border.all(color: Color(0xff8D9091)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Center(
                                    child: Text(
                                      'Wednesday',
                                      style: TextStyle(
                                          fontSize: 14,
                                          // color: Colors.white,
                                          //color: Color(0xff8D9091),
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ),
                                )),
                          ),
                          Tab(
                            child: Container(

                                //  height: 38,
                                decoration: const BoxDecoration(
                                  //  border: Border.all(color: Color(0xff8D9091)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Center(
                                    child: Text(
                                      'Thursday',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal),
                                    ),
                                  ),
                                )),
                          ),
                          Tab(
                            child: Container(
                              // height: 38,
                              decoration: const BoxDecoration(
                                //  border: Border.all(color: Color(0xff8D9091)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Center(
                                  child: Text(
                                    'Friday',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              // height: 38,
                              decoration: const BoxDecoration(
                                //  border: Border.all(color: Color(0xff8D9091)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Center(
                                  child: Text(
                                    'Saturday',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: Column(
          children: [
            // const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
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

                      return Text('Hello Start Now');
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: Container(
                                          // width: 150.0,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 150.0,
                                            height: 250.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                          ),
                                          Container(
                                            width: 150.0,
                                            height: 250.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
            ),
          ],
        ),
      ),
    );
    //SignChildScro
    //     Container(
    //         child: FutureBuilder(
    //   future: future,
    //   builder: (C, snap) {
    //     if (snap.connectionState != ConnectionState.waiting) {
    //       if (snap.hasError) {
    //         return Center(
    //           child: Text(
    //             '${snap.error} occured',
    //           ),
    //         );
    //       } else if (snap.hasData) {
    //         return ListView.builder(
    //           shrinkWrap: true,
    //           controller: _scrollController,
    //           itemBuilder: (context, index) {
    //             final Product myproduct = product[0][index];
    //             return Text(myproduct.name);
    //             // return ListTile(
    //             //   leading: Text(myproduct.name),
    //             // );
    //             // Text(myproduct.name);
    //           },
    //           itemCount: product[0].length,
    //         );
    //       }
    //       return Container(
    //         child: Text('Error1'),
    //       );
    //     } else {
    //       return Container(
    //         child: const Center(
    //           child: CircularProgressIndicator(),
    //         ),
    //       );
    //     }
    //   },
    // ))
  }
}

// class searchbar extends SearchDelegate {

//   @override
//   // TODO: implement keyboardType
//   TextInputType? get keyboardType => super.keyboardType;

//   @override
//   // TODO: implement searchFieldStyle
//   TextStyle? get searchFieldStyle => TextStyle(backgroundColor: Colors.black);

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       Text(
//         'Cancel',
//         style: TextStyle(color: Colors.black),
//       )
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return Container();
//     // TODO: implement buildLeading
//     //throw UnimplementedError();
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     // TODO: implement buildResults
//     return Container();
//     // throw UnimplementedError();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // TODO: implement buildSuggestions
//     return Container();
//     // throw UnimplementedError();
//   }
// }

// class TabWidget extends StatelessWidget {
//   const TabWidget({
//     Key ? key, this.day,

//   }) : super(key: key);

//   final String day;

//   @override
//   Widget build(BuildContext context) {
//     return Tab(
//       child: Container(
//
//           height: 38,
//           decoration: BoxDecoration(
//             border: Border.all(color: Color(0xff8D9091)),
//             borderRadius: BorderRadius.all(Radius.circular(8)),
//           ),
//           child: Center(
//             child: Text(
//               day,
//               style: TextStyle(
//                   fontSize: 14,
//                   // color: Colors.white,
//                   //color: Color(0xff8D9091),
//                   fontFamily: 'Gordita',
//                   fontWeight: FontWeight.w500,
//                   fontStyle: FontStyle.normal),
//             ),
//           )),
//     );
//   }
// }
