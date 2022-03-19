import 'package:extended_image/extended_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/notifiers/auth_notifier.dart';
import 'package:newsapp/notifiers/news_notifier.dart';
import 'package:newsapp/pages/home/news_detail.dart';
import 'package:newsapp/pages/home/search_page.dart';
import 'package:newsapp/services/api.dart';
import 'package:newsapp/services/http.dart';
import 'package:newsapp/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unicons/unicons.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final String assetName = 'assets/images/cart.svg';

  late dynamic myfuture;

  String salutation = "";

  ScrollController _controller = new ScrollController(keepScrollOffset: true);

  late List<News> news;

  @override
  void initState() {
    super.initState();
    myfuture = call();
    salutation = greeting();
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => print('Called After finished'));
  }

  Future<List<News>> call() async {
    List<News> gotten = await getNewsFromFirebase();

    setState(() {
      news = gotten;
    });

    return gotten;
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
      backgroundColor: backgroundColor,
      //App Bar Data
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // here the desired height
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: backgroundColor,
          elevation: 0,
          titleSpacing: 23,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/user.png',
                    height: 60,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                          fontSize: 19,
                          fontFamily: 'Nunito',
                          color: textColor,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.normal),
                    ),
                    SizedBox(
                      height: 0.0,
                    ),
                    Text(
                      "Monday 3, January",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          color: greyColor,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
                    child: TextField(
                      readOnly: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPage(),
                          ),
                        );
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
                                    MaterialStateProperty.all(primaryColor),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                fixedSize:
                                    MaterialStateProperty.all(Size(40, 60))),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  //Tab bar
                  Padding(
                    padding: const EdgeInsets.only(left: .0, bottom: 10),
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: 10),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Center(
                                child: Text(
                                  '#Crypto ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      // color: Colors.white,
                                      color: greyColor,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Center(
                                child: Text(
                                  '#Politics',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: greyColor,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Center(
                                child: Text(
                                  '#Sports',
                                  style: TextStyle(
                                      fontSize: 14,
                                      // color: Colors.white,
                                      color: greyColor,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Center(
                                child: Text(
                                  '#Technology',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: greyColor,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  '#Science',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: greyColor,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Center(
                                child: Text(
                                  '#Finance',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: greyColor,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal),
                                ),
                              ),
                            ),
                          ],
                        ),
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

                      news = snap.data! as List<News>;
                      ref.read(NewsState.provider.notifier).setNews(news);
                      return ListView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Container(
                            height: 280,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              children: news.map((element) {
                                return BuildNews(
                                  news: element,
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: Text('Shorts For You'),
                          ),
                          Container(
                            height: 110,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              children: news.reversed.map((element) {
                                return BuildNewsShorts(
                                  news: element,
                                );
                              }).toList() as List<Widget>,
                            ),
                          ),
                        ],
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
    //             final Product mynews = news[0][index];
    //             return Text(mynews.name);
    //             // return ListTile(
    //             //   leading: Text(mynews.name),
    //             // );
    //             // Text(mynews.name);
    //           },
    //           itemCount: news[0].length,
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

//Order list section for drinks, special and Sandwiches and noodles
class BuildNews extends StatelessWidget {
  News news;

  BuildNews({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetails(
              news: news,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 2),
        width: 230,
        // height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.5),
          //     spreadRadius: 0,
          //     blurRadius: 1,
          //   ),
          // ],
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 150,
              margin: EdgeInsets.all(10),
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                child: news.urlToImage == ""
                    ? ExtendedImage.network(
                        '',
                        fit: BoxFit.cover,
                        cache: true,
                      )
                    : ExtendedImage.network(
                        news.urlToImage,
                        fit: BoxFit.cover,
                        cache: true,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10,
                top: 8,
                bottom: 6,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Center(
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/user.png',
                            height: 30,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (news.author),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal),
                            ),
                            Text(
                              '${news.publishedAt.day}/ ${news.publishedAt.month}/ ${news.publishedAt.year}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 8,
                                  color: Colors.grey,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            UniconsLine.folder_open,
                            color: Colors.white,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: primaryColor.withOpacity(0.12),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildNewsShorts extends StatelessWidget {
  News news;

  BuildNewsShorts({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetails(
              news: news,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 2),
        width: 250,
        // height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.5),
          //     spreadRadius: 0,
          //     blurRadius: 1,
          //   ),
          // ],
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: double.maxFinite,
                width: 80,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: news.urlToImage == ""
                      ? ExtendedImage.network(
                          '',
                          fit: BoxFit.cover,
                          cache: true,
                        )
                      : ExtendedImage.network(
                          news.urlToImage,
                          fit: BoxFit.cover,
                          cache: true,
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10,
                top: 8,
                bottom: 6,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      news.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Icon(
                        UniconsLine.eye,
                        color: greyColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        //  'NGN 800',
                        ('40,6537'),
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
