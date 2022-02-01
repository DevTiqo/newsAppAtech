import 'package:extended_image/extended_image.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/notifiers/auth_notifier.dart';

import 'package:newsapp/notifiers/news_notifier.dart';

import 'package:newsapp/theme/theme.dart';
import 'package:flutter/material.dart';

import 'package:riverpod/riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unicons/unicons.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  late int day;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController search_controller = new TextEditingController();

  String searchval = "";
  late dynamic myfuture;

  var focusNode = FocusNode();

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

    // myfuture = search('');

    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (focusNode.canRequestFocus) {
        FocusScope.of(context).requestFocus(focusNode);
      }
    });
  }

  // Future<List<List<Product>>> search(String val) async {
  //   val = val.toLowerCase();
  //   searchmenu.clear();
  //   productNotifier.productslist.forEach((element) {
  //     List<Product> news = [];

  //     element.forEach((elements) {
  //       if (elements.name.toLowerCase().contains(val)) {
  //         news.add(elements);
  //       }
  //     });
  //     print(searchmenu.length);
  //     setState(() {
  //       searchmenu.add(news);
  //     });
  //     // searchmenu.add(news);
  //   });

  //   return searchmenu;
  // }

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
        backgroundColor: backgroundColor,
        //App Bar Data
        // appBar: AppBar(
        //   iconTheme: const IconThemeData(color: Colors.black),
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   titleSpacing: 23,
        //   // leading: GestureDetector(
        //   //   onTap: () {
        //   //     _scaffoldKey.currentState!.openDrawer();
        //   //   },
        //   //   child: Image.asset(
        //   //     'assets/images/sort.png',
        //   //   ),
        //   // ),
        // ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 60, left: 24, right: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 48,
                              width: MediaQuery.of(context).size.width - 130,
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                //Color(0xffF6F6F6),

                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: TextField(
                                focusNode: focusNode,
                                controller: search_controller,
                                onSubmitted: (val) {},
                                onChanged: (val) {
                                  setState(() {
                                    searchval = val;
                                  });
                                  // search(val);
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
                                      child: Icon(UniconsSolid.airplay)),
                                ),
                              ),
                            ),
                            TextButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Nunito',
                                    color: primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal),
                              ),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(0.0)),
                                  textStyle: MaterialStateProperty.all(
                                    const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  fixedSize:
                                      MaterialStateProperty.all(Size(60, 20))),
                              onPressed: () {
                                // final form = formKey.currentState;
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      //Tab bar
                      TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        controller: tabController,
                        labelColor: primaryColor,
                        indicatorColor: primaryColor,
                        indicatorPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 0),
                        labelPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 0),
                        unselectedLabelColor: const Color(0xff8D9091),
                        isScrollable: true,
                        padding: EdgeInsets.only(left: 10, bottom: 0),
                        tabs: [
                          Tab(
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
                          Tab(
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
                          ),
                          Tab(
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
                          ),
                          Tab(
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
                          ),
                          Tab(
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
                          Tab(
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: Column(
            children: [
              // const SizedBox(height: 20),
              // Expanded(
              //   child: searchmenu.isNotEmpty
              //       ? TabBarView(
              //           controller: tabController,
              //           children: [
              //             searchmenu[0].length > 0
              //                 ? SearchRes(
              //                     pros: searchmenu[0],
              //                     day: 0,
              //                   )
              //                 : Center(
              //                     child: Column(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         Text(
              //                           "No results found ",
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                             fontFamily: 'Nunito',
              //                             fontSize: 18,
              //                             fontWeight: FontWeight.w600,
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           height: 10,
              //                         ),
              //                         Text(
              //                           "There were no items \n matching your search for  '$searchval'",
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                             height: 1.3,
              //                             fontFamily: 'Nunito',
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           height: 100,
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //             searchmenu[1].length > 0
              //                 ? SearchRes(
              //                     pros: searchmenu[1],
              //                     day: 1,
              //                   )
              //                 : Center(
              //                     child: Column(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         Text(
              //                           "No results found ",
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                             fontFamily: 'Nunito',
              //                             fontSize: 18,
              //                             fontWeight: FontWeight.w600,
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           height: 10,
              //                         ),
              //                         Text(
              //                           "There were no items \n matching your search for  '$searchval'",
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                             height: 1.3,
              //                             fontFamily: 'Nunito',
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           height: 100,
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //             searchmenu[2].length > 0
              //                 ? SearchRes(
              //                     pros: searchmenu[2],
              //                     day: 2,
              //                   )
              //                 : Center(
              //                     child: Column(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         Text(
              //                           "No results found ",
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                             fontFamily: 'Nunito',
              //                             fontSize: 18,
              //                             fontWeight: FontWeight.w600,
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           height: 10,
              //                         ),
              //                         Text(
              //                           "There were no items \n matching your search for  '$searchval'",
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                             height: 1.3,
              //                             fontFamily: 'Nunito',
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           height: 100,
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //             searchmenu[3].length > 0
              //                 ? SearchRes(
              //                     pros: searchmenu[3],
              //                     day: 3,
              //                   )
              //                 : Center(
              //                     child: Column(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         Text(
              //                           "No results found ",
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                             fontFamily: 'Nunito',
              //                             fontSize: 18,
              //                             fontWeight: FontWeight.w600,
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           height: 10,
              //                         ),
              //                         Text(
              //                           "There were no items \n matching your search for  '$searchval'",
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                             height: 1.3,
              //                             fontFamily: 'Nunito',
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           height: 100,
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //             searchmenu[4].length > 0
              //                 ? SearchRes(
              //                     pros: searchmenu[4],
              //                     day: 4,
              //                   )
              //                 : Center(
              //                     child: Column(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         Text(
              //                           "No results found ",
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                             fontFamily: 'Nunito',
              //                             fontSize: 18,
              //                             fontWeight: FontWeight.w600,
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           height: 10,
              //                         ),
              //                         Text(
              //                           "There were no items \n matching your search for  '$searchval'",
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                             height: 1.3,
              //                             fontFamily: 'Nunito',
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           height: 100,
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //             searchmenu[5].length > 0
              //                 ? SearchRes(
              //                     pros: searchmenu[5],
              //                     day: 5,
              //                   )
              //                 : Center(
              //                     child: Column(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         Text(
              //                           "No results found ",
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                             fontFamily: 'Nunito',
              //                             fontSize: 18,
              //                             fontWeight: FontWeight.w600,
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           height: 10,
              //                         ),
              //                         Text(
              //                           "There were no items \n matching your search for  '$searchval'",
              //                           textAlign: TextAlign.center,
              //                           style: TextStyle(
              //                             height: 1.3,
              //                             fontFamily: 'Nunito',
              //                           ),
              //                         ),
              //                         SizedBox(
              //                           height: 100,
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //           ],
              //         )
              //       : Container(),
              // ),
              Text('Hello'),
            ],
          ),
        )
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
        );
  }
}

class SearchRes extends StatelessWidget {
  List<News> pros;
  int day;
  SearchRes({Key? key, required this.pros, required this.day})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pros.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Navigator.pushNamed(
            //     context, '/order_details');
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ProductDetails(
            //       product: pros[index],
            //       day: day,
            //     ),
            //   ),
            // );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
            height: 118,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: pros[index].photo == ""
                        ? ExtendedImage.network(
                            'https://order-api.newsapp.ng/api/photo/asun-spaghetti-plantain-medium-chicken59.jpg',
                            fit: BoxFit.cover,
                            cache: true,
                            width: 90,
                            height: 90,
                          )
                        : ExtendedImage.network(
                            'https://order-api.newsapp.ng/api/photo/' +
                                pros[index].photo,
                            fit: BoxFit.cover,
                            cache: true,
                            width: 90,
                            height: 90,
                          ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0, right: 12,
                        // bottom: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              pros[index].name,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                //  'NGN 800',
                                ("NGN " + pros[index].price.toString()),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Nunito',
                                    color: primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
