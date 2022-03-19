import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:newsapp/theme/theme.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/models/news.dart';
import 'package:unicons/unicons.dart';

class NewsDetails extends StatefulWidget {
  News? news;

  NewsDetails({
    Key? key,
    this.news,
  }) : super(key: key);
  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  // bool selected = false;

  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    News? thisnews = widget.news;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Details',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              UniconsLine.draggabledots,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: "Type a comment...",
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
                    IconlyLight.send,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      fixedSize: MaterialStateProperty.all(Size(40, 60))),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 300,
                    child: thisnews!.urlToImage == ""
                        ? ExtendedImage.network(
                            '',
                            fit: BoxFit.cover,
                            cache: true,
                          )
                        : ExtendedImage.network(
                            thisnews.urlToImage,
                            fit: BoxFit.cover,
                            cache: true,
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //shrinkWrap: true,
                children: [
                  Text(
                    '#Crypto',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Nunito',
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    thisnews.title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w800,
                        fontStyle: FontStyle.normal),
                  ),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/images/user.png',
                          height: 40,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(thisnews.author.toString(),
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    thisnews.description,
                    style: TextStyle(
                        fontSize: 12,
                        color: supportingText,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal),
                  ),
                  const Divider(),
                  const SizedBox(height: 24),
                  Text(
                    thisnews.content,
                    style: TextStyle(
                        fontSize: 15,
                        color: supportingText,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
