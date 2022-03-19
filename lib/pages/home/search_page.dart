import 'package:extended_image/extended_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/notifiers/auth_notifier.dart';

import 'package:newsapp/notifiers/news_notifier.dart';

import 'package:newsapp/theme/theme.dart';
import 'package:flutter/material.dart';

import 'package:riverpod/riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unicons/unicons.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController search_controller = new TextEditingController();

  String searchval = "";
  List<News> searchnews = [];
  List<News> allnews = [];
  late dynamic myfuture;

  var focusNode = FocusNode();

  @override
  void initState() {
    // "ref" can be used in all life-cycles of a StatefulWidget
    final newsList = ref.read(NewsState.provider);
    setState(() {
      searchnews = newsList;
      allnews = newsList;
    });
    // myfuture = search('');

    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(
      (timeStamp) {
        if (focusNode.canRequestFocus) {
          FocusScope.of(context).requestFocus(focusNode);
        }
      },
    );
  }

  Future<List<News>> search(String val) async {
    val = val.toLowerCase();
    setState(() {
      searchnews = [];
    });

    allnews.forEach((element) {
      List<News> news = [];

      if (element.title.toLowerCase().contains(val)) {
        print(val);
        setState(() {
          searchnews.add(element);
        });
      }

      print(searchnews.length);
    });

    return searchnews;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: backgroundColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 23,
          // leading: GestureDetector(
          //   onTap: () {
          //     _scaffoldKey.currentState!.openDrawer();
          //   },
          //   child: Image.asset(
          //     'assets/images/sort.png',
          //   ),
          // ),
        ),
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 24, right: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextField(
                                focusNode: focusNode,
                                controller: search_controller,
                                onSubmitted: (val) {},
                                onChanged: (val) async {
                                  setState(() {
                                    searchval = val;
                                  });
                                  await search(val);
                                },
                                decoration: InputDecoration(
                                  hintText: "Search for articles..",
                                  filled: true,
                                  hintStyle: const TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Nunito',
                                    color: Color(0xff8D9091),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular((10)),
                                  ),
                                  fillColor: Colors.white,
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: TextButton(
                                      child: Icon(
                                        UniconsLine.search,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {},
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  primaryColor),
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          fixedSize: MaterialStateProperty.all(
                                              Size(40, 60))),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        //Tab bar
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: Column(
              children: [
                // const SizedBox(height: 20),
                Expanded(
                  child: searchnews.isNotEmpty
                      ? SearchRes(
                          pros: searchnews,
                          day: 0,
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No results found ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "There were no items \n matching your search for  '$searchval'",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  height: 1.3,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                              SizedBox(
                                height: 100,
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ))
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
                    child: pros[index].urlToImage == ""
                        ? ExtendedImage.network(
                            '',
                            fit: BoxFit.cover,
                            cache: true,
                            width: 90,
                            height: 90,
                          )
                        : ExtendedImage.network(
                            pros[index].urlToImage,
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
                              pros[index].title,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              //  'NGN 800',
                              ('By ' + pros[index].author.toString()),
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Nunito',
                                  color: primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal),
                            ),
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
