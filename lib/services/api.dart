import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/models/user.dart' as User2;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapp/notifiers/auth_notifier.dart';
import 'package:newsapp/notifiers/news_notifier.dart';
import 'package:newsapp/services/http.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

String getFirebaseError(error) {
  String errorMessage;
  switch (error.code) {
    case "ERROR_INVALID_EMAIL":
      errorMessage = "Your email address appears to be malformed.";
      break;
    case "ERROR_WRONG_PASSWORD":
      errorMessage = "Your password is wrong.";
      break;
    case "ERROR_USER_NOT_FOUND":
      errorMessage = "User with this email doesn't exist.";
      break;
    case "ERROR_USER_DISABLED":
      errorMessage = "User with this email has been disabled.";
      break;
    case "ERROR_TOO_MANY_REQUESTS":
      errorMessage = "Too many requests. Try again later.";
      break;
    case "ERROR_OPERATION_NOT_ALLOWED":
      errorMessage = "Signing in with Email and Password is not enabled.";
      break;
    default:
      errorMessage = "An undefined Error happened.";
  }

  if (errorMessage != null) {
    return errorMessage;
  }
  return '';
}

Future<List<News>> getNews() async {
  try {
    var result = await httpGet(
      'everything?q=crypto&from=2022-01-15&sortBy=publishedAt&apiKey=670e30e6d5194e76a4118fbadfb0e341',
      {},
    );

    if (result.ok) {
      List<News> news = [];
      if (result.data['status'] == 'ok') {
        List<dynamic> arrnews = [];

        print("200 way");
        print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxNews");
        arrnews = result.data['articles'];
        arrnews = arrnews.sublist(0, 10);
        for (var element in arrnews) {
          News cs = News.fromMap(element);
          news.add(cs);
          print(cs);

          await FirebaseFirestore.instance.collection('news').add({
            'name': element['source']['name'],
            'author': element['author'],
            'title': element['title'],
            'description': element['description'],
            'url': element['url'],
            'urlToImage': element['urlToImage'],
            'publishedAt': element['publishedAt'],
            'content': element['content'],
          });
        }

        print(news);
        return news;
      } else {
        return [];
      }
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}

Future<RequestResult> loginUser(String email, String password) async {
  String err = '';
  try {
    UserCredential authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    User? firebaseUser = authResult.user;
    if (firebaseUser != null) {
      print("Login $firebaseUser");

      DocumentReference snapshot = FirebaseFirestore.instance
          .collection("users")
          .doc(authResult.user!.uid);

      snapshot.get().then((datasnap) {
        if (datasnap.exists) {
          print(datasnap.data());
          // datasnap.data["userId"] = datasnap.documentID;
          // authNotifier.currentUser = User.fromMap(datasnap.data);
        }
      });
      return RequestResult(true, 200, err);
    } else {
      err = "No User";
      return RequestResult(false, 404, err);
    }
  } on FirebaseAuthException catch (error) {
    err = getFirebaseError(error);
    // print(error.code);
    print(err);
    return RequestResult(false, 404, err);
  }
}

Future<RequestResult> signupUser(
    String name, String email, String password) async {
  String err = '';
  try {
    UserCredential authResult = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((error) => print(error.code));

    User? firebaseUser = authResult.user;
    if (firebaseUser != null) {
      await firebaseUser.updateDisplayName(name);
      await firebaseUser.reload();
      print("SignUp: $firebaseUser");
      User? currentUser = await FirebaseAuth.instance.currentUser!;
      print("SignUp: $currentUser");
      // authNotifier.setUser(currentUser);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .set({
        'userName': name,
        'email': email,
        'userId': currentUser.uid,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
      });
      DocumentReference snapshot = FirebaseFirestore.instance
          .collection("users")
          .doc(authResult.user!.uid);

      snapshot.get().then((datasnap) {
        if (datasnap.exists) {
          print(datasnap.data());
          // datasnap.data["userId"] = datasnap.documentID;
          // authNotifier.currentUser = User.fromMap(datasnap.data);
        }
      });
      return RequestResult(true, 200, err);
    } else {
      err = "No good";
      return RequestResult(false, 404, err);
    }
  } on FirebaseAuthException catch (error) {
    err = getFirebaseError(error);
    return RequestResult(false, 404, err);
  }
}

Future<void> signout() async {
  await FirebaseAuth.instance.signOut();
}

Future<List<News>> getNewsFromFirebase() async {
  String err = '';
  try {
    CollectionReference snapshot =
        FirebaseFirestore.instance.collection("news");

    List<News> news = [];

    snapshot.get().then((datasnap) {
      datasnap.docs.forEach((element) {
        Map<String, dynamic> obj = element.data() as Map<String, dynamic>;
        News cs = News.fromFirebase(obj);
        news.add(cs);
        print(cs);
      });
    });
    // NewsNotifier newsNotifier=;
    // newsNotifier.setNews(news);
    return news;
  } on FirebaseAuthException catch (error) {
    err = getFirebaseError(error);
    return [];
  }
}
