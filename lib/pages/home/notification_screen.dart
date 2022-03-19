import 'package:newsapp/theme/theme.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
          'Notifications',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {},
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Clear all',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                        'Hi Jackson, what news would you like to read today?',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 16),
                    Text('2m ago',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color: supportingText,
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 16),
                    const Divider()
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                        'Hi Jackson, what news would you like to read today?',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 16),
                    Text('2m ago',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color: supportingText,
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 16),
                    const Divider()
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                        'Hi Jackson, what news would you like to read today?',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 16),
                    Text('2m ago',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color: supportingText,
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 16),
                    const Divider()
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                        'Hi Jackson, what news would you like to read today?',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 16),
                    Text('2m ago',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color: supportingText,
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 16),
                    const Divider()
                  ],
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                        'Hi Jackson, what news would you like to read today?',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 16),
                    Text('2m ago',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color: supportingText,
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 16),
                    const Divider()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
