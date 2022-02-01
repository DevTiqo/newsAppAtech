import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/models/user.dart' as User2;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapp/notifiers/auth_notifier.dart';
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

Future<RequestResult> loginUser(String email, String password) async {
  String err = '';
  try {
    UserCredential authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    if (authResult != null) {
      User? firebaseUser = authResult.user;
      if (firebaseUser != null) {
        print("Login $firebaseUser");
        // authNotifier.setUser(firebaseUser);
        DocumentReference snapshot = FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user!.uid);

        snapshot.get().then((datasnap) {
          if (datasnap.exists) {
            print(datasnap.data);
            // datasnap.data["userId"] = datasnap.documentID;
            // authNotifier.currentUser = User.fromMap(datasnap.data);
          }
        });
        return RequestResult(true, 200, err);
      } else {
        err = "No User";
        return RequestResult(false, 404, err);
      }
    } else {
      err = "Error Occured";
      return RequestResult(false, 404, err);
    }
    return RequestResult(false, 404, err);
  } catch (error) {
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
    if (authResult.user != null) {
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
            print(datasnap.data);
            // datasnap.data["userId"] = datasnap.documentID;
            // authNotifier.currentUser = User.fromMap(datasnap.data);
          }
        });
        return RequestResult(true, 200, err);
      } else {
        err = "No good";
        return RequestResult(false, 404, err);
      }
    } else {
      err = "No good";
      return RequestResult(false, 404, err);
    }
  } catch (error) {
    err = getFirebaseError(error);
    return RequestResult(false, 404, err);
  }
}

// loginService(ServiceProvider serviceProvider, AuthNotifier authNotifier) async {
//   String err;
//   try {
//     AuthResult authResult = await FirebaseAuth.instance
//         .signInWithEmailAndPassword(
//             email: serviceProvider.email, password: serviceProvider.password)
//         .catchError((error) => print(error.code));

//     if (authResult != null) {
//       FirebaseUser firebaseUser = authResult.user;
//       if (firebaseUser != null) {
//         print("Login $firebaseUser");

//         DocumentReference snapshot = Firestore.instance
//             .collection("serviceProviders")
//             .document(authResult.user.uid);

//         snapshot.get().then((datasnap) {
//           if (datasnap.exists) {
//             datasnap.data["serviceId"] = datasnap.documentID;
//             authNotifier.currentServiceProvider =
//                 ServiceProvider.fromMap(datasnap.data);
//             authNotifier.setUser(firebaseUser);
//           }
//         });
//       }
//     }
//     return err;
//   } catch (error) {
//     err = getFirebaseError(error);
//     print(error.code);
//     print(err);
//     return err;
//   }
// }

// signupService(
//     ServiceProvider serviceProvider, AuthNotifier authNotifier) async {
//   try {
//     AuthResult authResult = await FirebaseAuth.instance
//         .createUserWithEmailAndPassword(
//             email: serviceProvider.email, password: serviceProvider.password)
//         .catchError((error) => print(error.code));
//     if (authResult != null) {
//       FirebaseUser firebaseUser = authResult.user;
//       if (firebaseUser != null) {
//         print("SignUp: $firebaseUser");
//         String type;
//         FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
//         authNotifier.setUser(currentUser);
//         await Firestore.instance
//             .collection('serviceProviders')
//             .document(currentUser.uid)
//             .setData({
//           'serviceName': serviceProvider.serviceName,
//           'serviceSlogan': "",
//           'email': serviceProvider.email,
//           'serviceId': currentUser.uid,
//           'pin': serviceProvider.serviceId,
//           'serviceType': serviceProvider.serviceType,
//           'image': "",
//           'createdAt': DateTime.now(),
//           'updatedAt': DateTime.now(),
//           'accountBalance': 0.00,
//           'isAvailable': true,
//         });

//         if (serviceProvider.serviceType == "Medical" ||
//             serviceProvider.serviceType == "Security") {
//           type = "welfareServices";
//         } else if (serviceProvider.serviceType == "News") {
//           type = "newsServices";
//         } else if (serviceProvider.serviceType == "Events") {
//           type = "eventServices";
//         } else if (serviceProvider.serviceType == "Association") {
//           type = "associationServices";

//           DocumentReference groupDocRef =
//               await Firestore.instance.collection("associations").add({
//             'groupName': serviceProvider.serviceName,
//             'groupIcon': '',
//             'adminId': currentUser.uid,
//             'members': [],
//             'groupId': '',
//             'recentMessage': '',
//             'recentMessageSender': '',
//             'recentMessageTime': ''
//           });

//           await groupDocRef.updateData({'groupId': groupDocRef.documentID});
//         } else {
//           type = "basicServices";
//         }

//         await Firestore.instance
//             .collection('serviceProviders')
//             .document("allSections")
//             .collection(type)
//             .document(currentUser.uid)
//             .setData({
//           'serviceName': serviceProvider.serviceName,
//           'serviceSlogan': "",
//           'email': serviceProvider.email,
//           'serviceId': currentUser.uid,
//           'pin': serviceProvider.serviceId,
//           'serviceType': serviceProvider.serviceType,
//           'image': "",
//           'createdAt': DateTime.now(),
//           'updatedAt': DateTime.now(),
//           'accountBalance': 0.00,
//           'isAvailable': true,
//         });
//         DocumentReference snapshot = Firestore.instance
//             .collection("serviceProviders")
//             .document(authResult.user.uid);

//         snapshot.get().then((datasnap) {
//           if (datasnap.exists) {
//             datasnap.data["serviceId"] = datasnap.documentID;
//             authNotifier.currentServiceProvider =
//                 ServiceProvider.fromMap(datasnap.data);
//           }
//         });
//       }
//     }
//   } catch (error) {
//     getFirebaseError(error);
//   }
// }

// signout(AuthNotifier authNotifier) async {
//   try {
//     await FirebaseAuth.instance
//         .signOut()
//         .catchError((error) => print(error.code));
//     authNotifier.setUser(null);
//   } catch (error) {
//     getFirebaseError(error);
//   }
// }

// initializeCurrentUser(AuthNotifier authNotifier, String user,
//     {ServiceProvider serviceProvider}) async {
//   FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

//   if (firebaseUser != null) {
//     print('$firebaseUser');
//     if (user == "serviceProvider") {
//       DocumentReference snapshot = Firestore.instance
//           .collection("serviceProviders")
//           .document(firebaseUser.uid);

//       snapshot.get().then((datasnap) {
//         if (datasnap.exists) {
//           authNotifier.currentServiceProvider =
//               ServiceProvider.fromMap(datasnap.data);
//         }
//       });
//     } else if (user == "user") {
//       DocumentReference snapshot =
//           Firestore.instance.collection("users").document(firebaseUser.uid);

//       snapshot.get().then((datasnap) {
//         if (datasnap.exists) {
//           authNotifier.currentUser = User.fromMap(datasnap.data);
//         }
//       });
//     } else {
//       print("error");
//     }
//     authNotifier.setUser(firebaseUser);
//   }
// }

// confirmPinUser() {}

// confirmPinService() {}

// getServiceProducts(ServiceProductNotifier serviceProductNotifier,
//     ServiceProvider serviceProvider, String categoryId) async {
//   QuerySnapshot snapshot = await Firestore.instance
//       .collection("serviceProviders")
//       .document("allSections")
//       .collection("basicServices")
//       .document(serviceProvider.serviceId)
//       .collection("category")
//       .document(categoryId)
//       .collection("serviceProduct")
//       .getDocuments();
//   List<ServiceProduct> _serviceProductList = [];
//   snapshot.documents.forEach((document) {
//     ServiceProduct serviceProduct = ServiceProduct.fromMap(document.data);
//     _serviceProductList.add(serviceProduct);
//   });
//   serviceProductNotifier.serviceProductList = _serviceProductList;
// }

// getServiceDeals(ServiceDealsNotifier serviceDealsNotifier,
//     ServiceProvider serviceProvider) async {
//   QuerySnapshot snapshot = await Firestore.instance
//       .collection("serviceProviders")
//       .document("allSections")
//       .collection("basicServices")
//       .document(serviceProvider.serviceId)
//       .collection("deals")
//       .getDocuments();
//   List<ServiceProduct> _serviceDealsList = [];
//   snapshot.documents.forEach((document) {
//     ServiceProduct serviceProduct = ServiceProduct.fromMap(document.data);
//     _serviceDealsList.add(serviceProduct);
//   });
//   serviceDealsNotifier.serviceDealsList = _serviceDealsList;
// }

// getServiceCategory(ServiceCategoryNotifier serviceCategoryNotifier,
//     ServiceProvider serviceProvider) async {
//   QuerySnapshot snapshot = await Firestore.instance
//       .collection("serviceProviders")
//       .document("allSections")
//       .collection("basicServices")
//       .document(serviceProvider.serviceId)
//       .collection("category")
//       .getDocuments();
//   List<ServiceCategory> _serviceCategoryList = [];
//   snapshot.documents.forEach((document) {
//     ServiceCategory serviceCategory = ServiceCategory.fromMap(document.data);
//     _serviceCategoryList.add(serviceCategory);
//   });
//   serviceCategoryNotifier.serviceCategoryList = _serviceCategoryList;
// }

// deleteServiceProduct(
//     ServiceProduct serviceProduct,
//     Function serviceProductDeleted,
//     ServiceProvider serviceProvider,
//     String categoryId) async {
//   if (serviceProduct.image != null) {
//     StorageReference storageReference = await FirebaseStorage.instance
//         .getReferenceFromUrl(serviceProduct.image);

//     print(storageReference.path);

//     await storageReference.delete();

//     print('image deleted');
//   }

//   await Firestore.instance
//       .collection("serviceProviders")
//       .document("allSections")
//       .collection("basicServices")
//       .document(serviceProvider.serviceId)
//       .collection("category")
//       .document(categoryId)
//       .collection("serviceProduct")
//       .document(serviceProduct.id)
//       .delete();
//   serviceProductDeleted(serviceProduct);
// }

// deleteServiceDeals(ServiceProduct serviceDeals, Function serviceDealsDeleted,
//     ServiceProvider serviceProvider) async {
//   if (serviceDeals.image != null) {
//     StorageReference storageReference =
//         await FirebaseStorage.instance.getReferenceFromUrl(serviceDeals.image);

//     print(storageReference.path);

//     await storageReference.delete();

//     print('image deleted');
//   }

//   await Firestore.instance
//       .collection("serviceProviders")
//       .document("allSections")
//       .collection("basicServices")
//       .document(serviceProvider.serviceId)
//       .collection("deals")
//       .document(serviceDeals.id)
//       .delete();
//   serviceDealsDeleted(serviceDeals);
// }

// deleteServiceCategory(
//     ServiceCategory serviceCategory,
//     Function serviceCategoryDeleted,
//     ServiceProvider serviceProvider,
//     String categoryId) async {
//   if (serviceCategory.image != null) {
//     StorageReference storageReference = await FirebaseStorage.instance
//         .getReferenceFromUrl(serviceCategory.image);

//     print(storageReference.path);

//     await storageReference.delete();

//     print('image deleted');
//   }

//   await Firestore.instance
//       .collection("serviceProviders")
//       .document("allSections")
//       .collection("basicServices")
//       .document(serviceProvider.serviceId)
//       .collection("category")
//       .document(categoryId)
//       .delete();
//   serviceCategoryDeleted(serviceCategory);
// }

// uploadServiceProductAndImage(
//     ServiceProduct serviceProduct,
//     bool isUpdating,
//     File localFile,
//     Function serviceProductUploaded,
//     ServiceProvider serviceProvider,
//     String categoryId) async {
//   if (localFile != null) {
//     print("uploading image");

//     var fileExtension = path.extension(localFile.path);
//     print(fileExtension);

//     var uuid = Uuid().v4();

//     final StorageReference firebaseStorageRef = FirebaseStorage.instance
//         .ref()
//         .child('serviceProducts/images/$uuid$fileExtension');

//     await firebaseStorageRef
//         .putFile(localFile)
//         .onComplete
//         .catchError((onError) {
//       print(onError);
//       return false;
//     });

//     String url = await firebaseStorageRef.getDownloadURL();
//     print("download url: $url");
//     _uploadServiceProduct(serviceProduct, isUpdating, serviceProductUploaded,
//         serviceProvider, categoryId,
//         imageUrl: url);
//   } else {
//     print('...skipping image upload');
//     _uploadServiceProduct(serviceProduct, isUpdating, serviceProductUploaded,
//         serviceProvider, categoryId);
//   }
// }

// _uploadServiceProduct(
//     ServiceProduct serviceProduct,
//     bool isUpdating,
//     Function serviceProductUploaded,
//     ServiceProvider serviceProvider,
//     String categoryId,
//     {String imageUrl}) async {
//   CollectionReference serviceProductRef = Firestore.instance
//       .collection("serviceProviders")
//       .document("allSections")
//       .collection("basicServices")
//       .document(serviceProvider.serviceId)
//       .collection("category")
//       .document(categoryId)
//       .collection("serviceProduct");

//   if (imageUrl != null) {
//     serviceProduct.image = imageUrl;
//   }

//   if (isUpdating) {
//     serviceProduct.updatedAt = Timestamp.now();

//     await serviceProductRef
//         .document(serviceProduct.id)
//         .updateData(serviceProduct.toMap());

//     serviceProductUploaded(serviceProduct);
//     print('updated serviceProduct with id: ${serviceProduct.id}');
//   } else {
//     serviceProduct.createdAt = Timestamp.now();

//     DocumentReference documentRef =
//         await serviceProductRef.add(serviceProduct.toMap());

//     serviceProduct.id = documentRef.documentID;

//     print('uploaded serviceProduct successfully: ${serviceProduct.toString()}');

//     await documentRef.setData(serviceProduct.toMap(), merge: true);

//     serviceProductUploaded(serviceProduct);
//   }
// }

// uploadServiceProviderAndImage(ServiceProvider currentServiceProvider,
//     File localFile, Function currentServiceProviderUploaded) async {
//   if (localFile != null) {
//     print("uploading image");

//     var fileExtension = path.extension(localFile.path);
//     print(fileExtension);

//     var uuid = Uuid().v4();

//     final StorageReference firebaseStorageRef = FirebaseStorage.instance
//         .ref()
//         .child('serviceProviders/images/$uuid$fileExtension');

//     await firebaseStorageRef
//         .putFile(localFile)
//         .onComplete
//         .catchError((onError) {
//       print(onError);
//       return false;
//     });

//     String url = await firebaseStorageRef.getDownloadURL();
//     print("download url: $url");
//     _uploadServiceProvider(
//         currentServiceProvider, currentServiceProviderUploaded,
//         imageUrl: url);
//   } else {
//     print('...skipping image upload');
//     _uploadServiceProvider(
//         currentServiceProvider, currentServiceProviderUploaded);
//   }
// }

// _uploadServiceProvider(ServiceProvider currentServiceProvider,
//     Function currentServiceProviderUploaded,
//     {String imageUrl}) async {
//   CollectionReference currentServiceProviderRef = Firestore.instance
//       .collection("serviceProviders")
//       .document("allSections")
//       .collection("basicServices");
//   CollectionReference currentServiceProviderRefGen =
//       Firestore.instance.collection("serviceProviders");
//   if (imageUrl != null) {
//     currentServiceProvider.image = imageUrl;
//   }

//   currentServiceProvider.updatedAt = Timestamp.now();

//   await currentServiceProviderRef
//       .document(currentServiceProvider.serviceId)
//       .updateData(currentServiceProvider.toMap());
//   await currentServiceProviderRefGen
//       .document(currentServiceProvider.serviceId)
//       .updateData(currentServiceProvider.toMap());

//   currentServiceProviderUploaded(currentServiceProvider);
//   print(
//       'updated currentServiceProvider with id: ${currentServiceProvider.serviceId}');
// }

// uploadServiceProviderPin(ServiceProvider currentServiceProvider,
//     Function currentServiceProviderUpdated) async {
//   CollectionReference currentServiceProviderRef = Firestore.instance
//       .collection("serviceProviders")
//       .document("allSections")
//       .collection("basicServices");
//   CollectionReference currentServiceProviderRefGen =
//       Firestore.instance.collection("serviceProviders");

//   currentServiceProvider.updatedAt = Timestamp.now();

//   await currentServiceProviderRef
//       .document(currentServiceProvider.serviceId)
//       .updateData(currentServiceProvider.toMap());
//   await currentServiceProviderRefGen
//       .document(currentServiceProvider.serviceId)
//       .updateData(currentServiceProvider.toMap());

//   currentServiceProviderUpdated();
//   print(
//       'updated currentServiceProvider with id: ${currentServiceProvider.serviceId}');
// }

// uploadServiceCategoryAndImage(
//     ServiceCategory serviceCategory,
//     bool isUpdating,
//     File localFile,
//     Function serviceCategoryUploaded,
//     ServiceProvider serviceProvider) async {
//   if (localFile != null) {
//     print("uploading image");

//     var fileExtension = path.extension(localFile.path);
//     print(fileExtension);

//     var uuid = Uuid().v4();

//     final StorageReference firebaseStorageRef = FirebaseStorage.instance
//         .ref()
//         .child('serviceCategory/images/$uuid$fileExtension');

//     await firebaseStorageRef
//         .putFile(localFile)
//         .onComplete
//         .catchError((onError) {
//       print(onError);
//       return false;
//     });

//     String url = await firebaseStorageRef.getDownloadURL();
//     print("download url: $url");
//     _uploadServiceCategory(
//         serviceCategory, isUpdating, serviceCategoryUploaded, serviceProvider,
//         imageUrl: url);
//   } else {
//     print('...skipping image upload');
//     _uploadServiceCategory(
//         serviceCategory, isUpdating, serviceCategoryUploaded, serviceProvider);
//   }
// }

// _uploadServiceCategory(ServiceCategory serviceCategory, bool isUpdating,
//     Function serviceCategoryUploaded, ServiceProvider serviceProvider,
//     {String imageUrl}) async {
//   CollectionReference serviceCategoryRef = Firestore.instance
//       .collection("serviceProviders")
//       .document("allSections")
//       .collection("basicServices")
//       .document(serviceProvider.serviceId)
//       .collection("category");

//   if (imageUrl != null) {
//     serviceCategory.image = imageUrl;
//   }

//   if (isUpdating) {
//     serviceCategory.updatedAt = Timestamp.now();

//     await serviceCategoryRef
//         .document(serviceCategory.id)
//         .updateData(serviceCategory.toMap());

//     serviceCategoryUploaded(serviceCategory);
//     print('updated serviceCategory with id: ${serviceCategory.id}');
//   } else {
//     serviceCategory.createdAt = Timestamp.now();
//     serviceCategory.updatedAt = Timestamp.now();

//     DocumentReference documentRef =
//         await serviceCategoryRef.add(serviceCategory.toMap());

//     serviceCategory.id = documentRef.documentID;

//     print(
//         'uploaded serviceCategory successfully: ${serviceCategory.toString()}');

//     await documentRef.setData(serviceCategory.toMap(), merge: true);

//     serviceCategoryUploaded(serviceCategory);
//   }
// }

// uploadServiceDealsAndImage(
//     ServiceProduct serviceDeals,
//     bool isUpdating,
//     File localFile,
//     Function serviceDealsUploaded,
//     ServiceProvider serviceProvider) async {
//   if (localFile != null) {
//     print("uploading image");

//     var fileExtension = path.extension(localFile.path);
//     print(fileExtension);

//     var uuid = Uuid().v4();

//     final StorageReference firebaseStorageRef = FirebaseStorage.instance
//         .ref()
//         .child('serviceDeals/images/$uuid$fileExtension');

//     await firebaseStorageRef
//         .putFile(localFile)
//         .onComplete
//         .catchError((onError) {
//       print(onError);
//       return false;
//     });

//     String url = await firebaseStorageRef.getDownloadURL();
//     print("download url: $url");
//     _uploadServiceDeals(
//         serviceDeals, isUpdating, serviceDealsUploaded, serviceProvider,
//         imageUrl: url);
//   } else {
//     print('...skipping image upload');
//     _uploadServiceDeals(
//         serviceDeals, isUpdating, serviceDealsUploaded, serviceProvider);
//   }
// }

// _uploadServiceDeals(ServiceProduct serviceDeals, bool isUpdating,
//     Function serviceDealsUploaded, ServiceProvider serviceProvider,
//     {String imageUrl}) async {
//   CollectionReference serviceDealsRef = Firestore.instance
//       .collection("serviceProviders")
//       .document("allSections")
//       .collection("basicServices")
//       .document(serviceProvider.serviceId)
//       .collection("deals");

//   if (imageUrl != null) {
//     serviceDeals.image = imageUrl;
//   }

//   if (isUpdating) {
//     serviceDeals.updatedAt = Timestamp.now();

//     await serviceDealsRef
//         .document(serviceDeals.id)
//         .updateData(serviceDeals.toMap());

//     serviceDealsUploaded(serviceDeals);
//     print('updated serviceDeals with id: ${serviceDeals.id}');
//   } else {
//     serviceDeals.createdAt = Timestamp.now();

//     DocumentReference documentRef =
//         await serviceDealsRef.add(serviceDeals.toMap());

//     serviceDeals.id = documentRef.documentID;

//     print('uploaded serviceDeals successfully: ${serviceDeals.toString()}');

//     await documentRef.setData(serviceDeals.toMap(), merge: true);

//     serviceDealsUploaded(serviceDeals);
//   }
// }

// getServiceProviders(
//     ServiceProviderNotifier serviceProviderNotifier, String serviceType) async {
//   QuerySnapshot snapshot = await Firestore.instance
//       .collection("serviceProviders")
//       .document("allSections")
//       .collection("basicServices")
//       .where('serviceType', isEqualTo: serviceType)
//       .getDocuments();
//   List<ServiceProvider> _serviceProviderList = [];
//   snapshot.documents.forEach((document) {
//     ServiceProvider serviceProvider = ServiceProvider.fromMap(document.data);
//     _serviceProviderList.add(serviceProvider);
//   });
//   serviceProviderNotifier.serviceProviderList = _serviceProviderList;
// }

// depositUser(User currentUser, Deposit attemptDeposit) async {
//   attemptDeposit.createdAt = Timestamp.now();
//   await Firestore.instance
//       .collection("users")
//       .document(currentUser.userId)
//       .collection("deposits")
//       .add(attemptDeposit.toMap());
//   double currentAccBal = currentUser.accountBalance;
//   currentAccBal = attemptDeposit.amount + currentAccBal;
//   currentUser.accountBalance = double.parse(currentAccBal.toStringAsFixed(2));

//   await Firestore.instance
//       .collection("users")
//       .document(currentUser.userId)
//       .updateData(currentUser.toMap());
// }

// Future<bool> checkAccBalSufficiency(User currentUser, double toDebit) async {
//   DocumentSnapshot snapshot = await Firestore.instance
//       .collection("users")
//       .document(currentUser.userId)
//       .get();
//   double currentBal = snapshot.data['accountBalance'];
//   if (currentBal >= toDebit) {
//     return true;
//   } else {
//     return false;
//   }
// }

// orderProcess(User currentUser, List<CartItem> cartList, double ordPrice,
//     String type, String specifications) async {
//   DocumentSnapshot docSnap = await Firestore.instance
//       .collection("users")
//       .document(currentUser.userId)
//       .get();
//   double currentBal = docSnap.data['accountBalance'];
//   bool check = await checkAccBalSufficiency(currentUser, ordPrice);
//   if (check && currentBal >= ordPrice) {
//     currentBal = currentBal - ordPrice;
//     currentUser.accountBalance = double.parse(currentBal.toStringAsFixed(2));
//     await Firestore.instance
//         .collection("users")
//         .document(currentUser.userId)
//         .updateData(currentUser.toMap());
//     _sendOrders(currentUser, cartList, ordPrice, type, specifications);
//   } else {
//     return "Insufficient Funds";
//   }
// }

// _sendOrders(User currentUser, List<CartItem> cartList, double ordPrice,
//     String type, String specificationss) {
//   CollectionReference orders = Firestore.instance.collection("orders");

//   // orders.getDocuments().then((value){
//   //   value.documents.forEach((element) async{
//   //     orders.document(element.documentID).collection("orderRequests").getDocuments().then((valube){
//   //       valube.documents.forEach((elementHigh) async{
//   //         // await orders.document(element.documentID).collection("orderRequest").document(elementHigh.documentID).delete();
//   //         await elementHigh.reference.delete();

//   //         print("dddd");
//   //       });

//   //     });
//   //     await orders.document(element.documentID).delete();
//   //   });
//   // });

//   Map<Y, List<T>> groupBy<T, Y>(Iterable<T> itr, Y Function(T) fn) {
//     return Map.fromIterable(itr.map(fn).toSet(),
//         value: (i) => itr.where((v) => fn(v) == i).toList());
//   }

//   Map<String, List<CartItem>> hello =
//       groupBy(cartList, (v) => v.serviceProvider.serviceId);
//   print(hello);

//   hello.forEach((key, value) {
//     double totalPrice = 0.0;
//     value.forEach((element) {
//       totalPrice += double.parse((element.ordPrice).toStringAsFixed(2));
//     });
//     Timestamp createdAt = Timestamp.now();
//     Timestamp updatedAt = Timestamp.now();
//     String specifications = specificationss;
//     String status = "Pending";
//     String orderType = type;
//     totalPrice = double.parse(totalPrice.toStringAsFixed(2));
//     orders.add({
//       'totalPrice': totalPrice,
//       'userId': currentUser.userId,
//       'serviceProviderId': key,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//       'specifications': specifications,
//       'status': status,
//       'orderType': orderType,
//     }).then((doc) {
//       value.forEach((element) {
//         print("hello" + element.categoryId.toString());
//         String ref;
//         if (element.type == "deals") {
//           ref = "serviceProviders/allSections/basicServices/" +
//               element.serviceProvider.serviceId +
//               "/deals/" +
//               element.serviceProduct.id +
//               "";
//         } else if (element.type == "serviceProduct") {
//           ref = "serviceProviders/allSections/basicServices/" +
//               element.serviceProvider.serviceId +
//               "/category/" +
//               element.categoryId +
//               "/serviceProduct/" +
//               element.serviceProduct.id +
//               "";
//         } else {
//           print("No type defined");
//         }

//         orders.document(doc.documentID).collection("orderRequests").add({
//           'reference': ref,
//           'itemCount': element.itemCount,
//           'orderPrice': element.ordPrice,
//         });
//       });
//     });
//   });
// }

// getUserOrders(OrderNotifier orderNotifier, User currentUser) async {
//   QuerySnapshot snapshot = await Firestore.instance
//       .collection("orders")
//       .where('userId', isEqualTo: currentUser.userId)
//       .getDocuments();
//   List<Order> activeOrdersList = [];
//   snapshot.documents.forEach((document) {
//     List<Item> itemss = [];
//     Order activeOrder = new Order();
//     activeOrder.orderId = document.documentID;
//     activeOrder.user = currentUser;
//     activeOrder.orderType = document.data['orderType'];
//     activeOrder.specifications = document.data['specifications'];
//     activeOrder.status = document.data['status'];
//     activeOrder.createdAt = document.data['createdAt'];
//     activeOrder.updatedAt = document.data['updatedAt'];
//     activeOrder.totalPrice = document.data['totalPrice'];
//     activeOrder.serviceProvider = new ServiceProvider();
//     activeOrder.items = [];
//     DocumentReference serviceProvider = Firestore.instance
//         .collection("serviceProviders")
//         .document(document.data['serviceProviderId']);
//     serviceProvider.get().then((value) {
//       activeOrder.serviceProvider = ServiceProvider.fromMap(value.data);
//     });
//     DocumentReference anOrder =
//         Firestore.instance.collection("orders").document(document.documentID);
//     anOrder.get().then((value) async {
//       QuerySnapshot shot =
//           await anOrder.collection("orderRequests").getDocuments();

//       shot.documents.forEach((element) {
//         Firestore.instance
//             .document(element.data['reference'])
//             .get()
//             .then((value) {
//           ServiceProduct serviceProduct = ServiceProduct.fromMap(value.data);
//           Item itemToAdd = Item.fromMap({
//             'serviceProduct': serviceProduct,
//             'itemCount': element.data['itemCount'],
//             'orderPrice': element.data['orderPrice'],
//           });

//           itemss.insert(0, itemToAdd);
//           activeOrder.items = itemss;
//         });
//       });
//     });

//     activeOrdersList.add(activeOrder);
//   });

//   orderNotifier.activeOrdersList = activeOrdersList;
// }

// getServiceProviderOrders(
//     OrderNotifier orderNotifier, ServiceProvider currentServiceProvider) async {
//   QuerySnapshot snapshot = await Firestore.instance
//       .collection("orders")
//       .where('serviceProviderId', isEqualTo: currentServiceProvider.serviceId)
//       .where('status', whereIn: ['Pending', 'Accepted']).getDocuments();
//   List<Order> activeOrdersList = [];
//   snapshot.documents.forEach((document) {
//     List<Item> itemss = [];
//     Order activeOrder = new Order();
//     activeOrder.orderId = document.documentID;
//     activeOrder.serviceProvider = currentServiceProvider;
//     activeOrder.orderType = document.data['orderType'];
//     activeOrder.specifications = document.data['specifications'];
//     activeOrder.status = document.data['status'];
//     activeOrder.createdAt = document.data['createdAt'];
//     activeOrder.updatedAt = document.data['updatedAt'];
//     activeOrder.totalPrice = document.data['totalPrice'];
//     activeOrder.serviceProvider = new ServiceProvider();
//     activeOrder.items = [];
//     DocumentReference user = Firestore.instance
//         .collection("users")
//         .document(document.data['userId']);
//     user.get().then((value) {
//       activeOrder.user = User.fromMap(value.data);
//     });
//     DocumentReference anOrder =
//         Firestore.instance.collection("orders").document(document.documentID);
//     anOrder.get().then((value) async {
//       QuerySnapshot shot =
//           await anOrder.collection("orderRequests").getDocuments();

//       shot.documents.forEach((element) {
//         Firestore.instance
//             .document(element.data['reference'])
//             .get()
//             .then((value) {
//           ServiceProduct serviceProduct = ServiceProduct.fromMap(value.data);
//           Item itemToAdd = Item.fromMap({
//             'serviceProduct': serviceProduct,
//             'itemCount': element.data['itemCount'],
//             'orderPrice': element.data['orderPrice'],
//           });

//           itemss.insert(0, itemToAdd);
//           activeOrder.items = itemss;
//         });
//       });
//     });

//     activeOrdersList.add(activeOrder);
//   });

//   orderNotifier.activeOrdersList = activeOrdersList;
// }

// updateOrder(OrderNotifier orderNotifier, String status, Order orderX) {
//   DocumentReference order =
//       Firestore.instance.collection("orders").document(orderX.orderId);
//   orderX.status = status;
//   order.updateData(orderX.toMap());
// }

// cancelOrder(OrderNotifier orderNotifier, User currentUser, Order orderX) async {
//   DocumentReference orderDocs =
//       Firestore.instance.collection("orders").document(orderX.orderId);
//   double ordPrice;
//   DocumentSnapshot getter = await orderDocs.get();
//   ordPrice = getter.data['totalPrice'];
//   DocumentSnapshot docSnap = await Firestore.instance
//       .collection("users")
//       .document(currentUser.userId)
//       .get();
//   double currentBal = docSnap.data['accountBalance'];

//   currentBal = currentBal + ordPrice;
//   currentUser.accountBalance = double.parse(currentBal.toStringAsFixed(2));
//   await Firestore.instance
//       .collection("users")
//       .document(currentUser.userId)
//       .updateData(currentUser.toMap());

//   CollectionReference order = orderDocs.collection('orderRequest');

//   order.getDocuments().then(
//         (value) => value.documents.forEach((element) {
//           order.document(element.documentID).delete();
//         }),
//       );
//   Firestore.instance.collection("orders").document(orderX.orderId).delete();
// }

// Future<int> checkAvailableServices(String serviceType) async {
//   QuerySnapshot count = await Firestore.instance
//       .collection('serviceProviders')
//       .document('allSections')
//       .collection('basicServices')
//       .where('serviceType', isEqualTo: serviceType)
//       .where('isAvailable', isEqualTo: true)
//       .getDocuments();
//   return count.documents.length;
// }

// //Add News Category
// uploadNewsCategoryAndImage(
//     NewsCategory newsCategory,
//     bool isUpdating,
//     File localFile,
//     Function newsCategoryUploaded,
//     ServiceProvider serviceProvider) async {
//   if (localFile != null) {
//     print("uploading image");

//     var fileExtension = path.extension(localFile.path);
//     print(fileExtension);

//     var uuid = Uuid().v4();

//     final StorageReference firebaseStorageRef = FirebaseStorage.instance
//         .ref()
//         .child('newsCategory/images/$uuid$fileExtension');

//     await firebaseStorageRef
//         .putFile(localFile)
//         .onComplete
//         .catchError((onError) {
//       print(onError);
//       return false;
//     });

//     String url = await firebaseStorageRef.getDownloadURL();
//     print("download url: $url");
//     _uploadNewsCategory(
//         newsCategory, isUpdating, newsCategoryUploaded, serviceProvider,
//         imageUrl: url);
//   } else {
//     print('...skipping image upload');
//     _uploadNewsCategory(
//         newsCategory, isUpdating, newsCategoryUploaded, serviceProvider);
//   }
// }

// _uploadNewsCategory(NewsCategory newsCategory, bool isUpdating,
//     Function newsCategoryUploaded, ServiceProvider serviceProvider,
//     {String imageUrl}) async {
//   CollectionReference newsCategoryRef = Firestore.instance.collection("news");

//   if (imageUrl != null) {
//     newsCategory.image = imageUrl;
//   }

//   if (isUpdating) {
//     newsCategory.updatedAt = Timestamp.now();

//     await newsCategoryRef.add(newsCategory.toMap());

//     newsCategoryUploaded(newsCategory);
//     print('updated newsCategory with id: ${newsCategory.id}');
//   } else {
//     newsCategory.createdAt = Timestamp.now();
//     newsCategory.updatedAt = Timestamp.now();

//     DocumentReference documentRef =
//         await newsCategoryRef.add(newsCategory.toMap());

//     newsCategory.id = documentRef.documentID;

//     print('uploaded newsCategory successfully: ${newsCategory.toString()}');

//     await documentRef.setData(newsCategory.toMap(), merge: true);

//     newsCategoryUploaded(newsCategory);
//   }
// }

// //Add News from NewsDocuments Service Provider
// uploadNewsDocumentAndImage(
//     NewsDocument newsDocument,
//     bool isUpdating,
//     File localFile,
//     Function newsDocumentUploaded,
//     ServiceProvider serviceProvider,
//     String categoryId) async {
//   if (localFile != null) {
//     print("uploading image");

//     var fileExtension = path.extension(localFile.path);
//     print(fileExtension);

//     var uuid = Uuid().v4();

//     final StorageReference firebaseStorageRef = FirebaseStorage.instance
//         .ref()
//         .child('newsDocuments/images/$uuid$fileExtension');

//     await firebaseStorageRef
//         .putFile(localFile)
//         .onComplete
//         .catchError((onError) {
//       print(onError);
//       return false;
//     });

//     String url = await firebaseStorageRef.getDownloadURL();
//     print("download url: $url");
//     _uploadNewsDocument(newsDocument, isUpdating, newsDocumentUploaded,
//         serviceProvider, categoryId,
//         imageUrl: url);
//   } else {
//     print('...skipping image upload');
//     _uploadNewsDocument(newsDocument, isUpdating, newsDocumentUploaded,
//         serviceProvider, categoryId);
//   }
// }

// _uploadNewsDocument(
//     NewsDocument newsDocument,
//     bool isUpdating,
//     Function newsDocumentUploaded,
//     ServiceProvider serviceProvider,
//     String categoryId,
//     {String imageUrl}) async {
//   CollectionReference newsDocumentRef = Firestore.instance
//       .collection("news")
//       .document(categoryId)
//       .collection("documents");
//   newsDocument.serviceProviderId = serviceProvider.serviceId;

//   if (imageUrl != null) {
//     newsDocument.image = imageUrl;
//   }

//   if (isUpdating) {
//     newsDocument.updatedAt = Timestamp.now();

//     await newsDocumentRef
//         .document(newsDocument.id)
//         .updateData(newsDocument.toMap());

//     newsDocumentUploaded(newsDocument);
//     print('updated newsDocument with id: ${newsDocument.id}');
//   } else {
//     newsDocument.updatedAt = Timestamp.now();

//     DocumentReference documentRef =
//         await newsDocumentRef.add(newsDocument.toMap());

//     newsDocument.id = documentRef.documentID;

//     print('uploaded newsDocument successfully: ${newsDocument.toString()}');

//     await documentRef.setData(newsDocument.toMap(), merge: true);

//     newsDocumentUploaded(newsDocument);
//   }
// }

// getNewsCategory(NewsCategoryNotifier newsCategoryNotifier) async {
//   QuerySnapshot snapshot =
//       await Firestore.instance.collection("news").getDocuments();
//   List<NewsCategory> _newsCategoriesList = [];
//   snapshot.documents.forEach((document) {
//     document.data['id'] = document.documentID;
//     if (document.data['name'] != "Headlines") {
//       NewsCategory newsCategory = NewsCategory.fromMap(document.data);
//       _newsCategoriesList.add(newsCategory);
//     }
//   });
//   newsCategoryNotifier.newsCategoryList = _newsCategoriesList;
// }

// getHeadlinesAndAnnouncements(NewsHeadlineNotifier newsHeadlinesNotifier,
//     AnnouncementNotifier announcementNotifier) async {
//   List<NewsDocument> _newsHeadlinesList = [];
//   List<NewsDocument> _newsAnnouncementsList = [];
//   QuerySnapshot snap = await Firestore.instance
//       .collection("news")
//       .where("name", isEqualTo: "Headlines")
//       .getDocuments();
//   snap.documents.forEach((element) async {
//     QuerySnapshot snapshot = await Firestore.instance
//         .collection("news")
//         .document(element.documentID)
//         .collection("documents")
//         .getDocuments();

//     snapshot.documents.forEach((document) {
//       NewsDocument newsDocument = NewsDocument.fromMap(document.data);
//       _newsHeadlinesList.add(newsDocument);
//     });
//     newsHeadlinesNotifier.newsHeadlinesList = _newsHeadlinesList;
//   });

//   QuerySnapshot announce = await Firestore.instance
//       .collection("news")
//       .where("name", isEqualTo: "Announcements")
//       .getDocuments();
//   announce.documents.forEach((element) async {
//     QuerySnapshot snapshot = await Firestore.instance
//         .collection("news")
//         .document(element.documentID)
//         .collection("documents")
//         .getDocuments();

//     snapshot.documents.forEach((document) {
//       NewsDocument newsDocument = NewsDocument.fromMap(document.data);
//       _newsAnnouncementsList.add(newsDocument);
//     });
//     announcementNotifier.announcementsList = _newsAnnouncementsList;
//   });
// }

// //Get Current News in Batches  of 10
// getNewsDocuments(NewsDocumentNotifier newsDocumentsNotifier,
//     NewsCategoryNotifier newsCategoryNotifier) async {
//   QuerySnapshot categories =
//       await Firestore.instance.collection("news").getDocuments();
//   categories.documents.forEach((element) async {
//     List<NewsDocument> newsDocuments = [];
//     QuerySnapshot snapshot = await Firestore.instance
//         .collection("news")
//         .document(newsCategoryNotifier.currentNewsCategory.id)
//         .collection("documents")
//         .getDocuments();

//     snapshot.documents.forEach((document) {
//       document.data['id'] = document.documentID;
//       NewsDocument newsDocument = NewsDocument.fromMap(document.data);
//       newsDocuments.add(newsDocument);
//     });
//     newsDocumentsNotifier.newsDocumentList = newsDocuments;
//   });
// }

// //
// getServiceHeadlinesAndAnnouncements(
//     NewsHeadlineNotifier newsHeadlinesNotifier,
//     AnnouncementNotifier announcementNotifier,
//     ServiceProvider serviceProvider) async {
//   List<NewsDocument> _newsHeadlinesList = [];
//   List<NewsDocument> _newsAnnouncementsList = [];
//   QuerySnapshot snap = await Firestore.instance
//       .collection("news")
//       .where("name", isEqualTo: "Headlines")
//       .getDocuments();
//   snap.documents.forEach((element) async {
//     QuerySnapshot snapshot = await Firestore.instance
//         .collection("news")
//         .document(element.documentID)
//         .collection("documents")
//         .getDocuments();

//     snapshot.documents.forEach((document) {
//       NewsDocument newsDocument = NewsDocument.fromMap(document.data);
//       _newsHeadlinesList.add(newsDocument);
//     });
//     newsHeadlinesNotifier.newsHeadlinesList = _newsHeadlinesList;
//   });

//   QuerySnapshot announce = await Firestore.instance
//       .collection("news")
//       .where("name", isEqualTo: "Announcements")
//       .getDocuments();
//   announce.documents.forEach((element) async {
//     QuerySnapshot snapshot = await Firestore.instance
//         .collection("news")
//         .document(element.documentID)
//         .collection("documents")
//         .where("serviceProviderId", isEqualTo: serviceProvider.serviceId)
//         .getDocuments();

//     snapshot.documents.forEach((document) {
//       NewsDocument newsDocument = NewsDocument.fromMap(document.data);
//       _newsAnnouncementsList.add(newsDocument);
//     });
//     announcementNotifier.announcementsList = _newsAnnouncementsList;
//   });
// }

// //Get Current News in Batches  of 10
// getServiceNewsDocuments(
//     NewsDocumentNotifier newsDocumentsNotifier,
//     NewsCategoryNotifier newsCategoryNotifier,
//     ServiceProvider serviceProvider) async {
//   QuerySnapshot categories =
//       await Firestore.instance.collection("news").getDocuments();
//   categories.documents.forEach((element) async {
//     List<NewsDocument> newsDocuments = [];
//     QuerySnapshot snapshot = await Firestore.instance
//         .collection("news")
//         .document(newsCategoryNotifier.currentNewsCategory.id)
//         .collection("documents")
//         .where("serviceProviderId", isEqualTo: serviceProvider.serviceId)
//         .getDocuments();

//     snapshot.documents.forEach((document) {
//       document.data['id'] = document.documentID;
//       NewsDocument newsDocument = NewsDocument.fromMap(document.data);
//       newsDocuments.add(newsDocument);
//     });
//     newsDocumentsNotifier.newsDocumentList = newsDocuments;
//   });
// }

// deleteNewsDocument(NewsDocument newsDocument, Function newsDocumentDeleted,
//     ServiceProvider serviceProvider, String categoryId) async {
//   if (newsDocument.image != null) {
//     StorageReference storageReference =
//         await FirebaseStorage.instance.getReferenceFromUrl(newsDocument.image);

//     print(storageReference.path);

//     await storageReference.delete();

//     print('image deleted');
//   }

//   await Firestore.instance
//       .collection("serviceProviders")
//       .document("allSections")
//       .collection("basicServices")
//       .document(serviceProvider.serviceId)
//       .collection("category")
//       .document(categoryId)
//       .collection("newsDocument")
//       .document(newsDocument.id)
//       .delete();
//   newsDocumentDeleted(newsDocument);
// }

// deleteNewsCategory(NewsCategory newsCategory, Function newsCategoryDeleted,
//     ServiceProvider serviceProvider, String categoryId) async {
//   if (newsCategory.image != null) {
//     StorageReference storageReference =
//         await FirebaseStorage.instance.getReferenceFromUrl(newsCategory.image);

//     print(storageReference.path);

//     await storageReference.delete();

//     print('image deleted');
//   }

//   await Firestore.instance
//       .collection("serviceProviders")
//       .document("allSections")
//       .collection("basicServices")
//       .document(serviceProvider.serviceId)
//       .collection("category")
//       .document(categoryId)
//       .delete();
//   newsCategoryDeleted(newsCategory);
// }

// // Association Functions

// // toggling the user group join
// Future togglingGroupJoin(Group association, String type,
//     AuthNotifier authNotifier, GroupNotifier groupNotifier) async {
//   DocumentReference userDocRef = Firestore.instance
//       .collection("users")
//       .document(authNotifier.currentUser.userId);
//   DocumentSnapshot userDocSnapshot = await userDocRef.get();

//   DocumentReference groupDocRef =
//       Firestore.instance.collection(type).document(association.groupId);

//   List<dynamic> groups;
//   if (type == "associations") {
//     groups = await userDocSnapshot.data['associations'];
//   } else if (type == "trends") {
//     groups = await userDocSnapshot.data['trends'];
//   }

//   if (groups.contains(association.groupId)) {
//     if (type == "associations") {
//       await userDocRef.updateData({
//         'associations': FieldValue.arrayRemove([association.groupId])
//       });
//     } else if (type == "trends") {
//       await userDocRef.updateData({
//         'trends': FieldValue.arrayRemove([association.groupId])
//       });
//     }

//     await groupDocRef.updateData({
//       'members': FieldValue.arrayRemove([authNotifier.currentUser.userId])
//     });
//     association.isMember = false;
//   } else {
//     //print('nay');
//     if (type == "associations") {
//       await userDocRef.updateData({
//         'associations': FieldValue.arrayUnion([association.groupId])
//       });
//       await groupDocRef.updateData({
//         'members': FieldValue.arrayUnion([authNotifier.currentUser.userId])
//       });
//     } else if (type == "trends") {
//       await userDocRef.updateData({
//         'trends': FieldValue.arrayUnion([association.groupId])
//       });
//       await groupDocRef.updateData({
//         'members': FieldValue.arrayUnion([authNotifier.currentUser.userId])
//       });
//     }
//     association.isMember = true;
//   }

//   if (type == "associations") {
//     groupNotifier.currentAssociation = association;
//   } else if (type == "trends") {
//     groupNotifier.currentTrend = association;
//   }
// }

// createTrend(
//     Group trend, AuthNotifier authNotifier, GroupNotifier groupNotifier) async {
//   DocumentReference userDocRef = Firestore.instance
//       .collection("users")
//       .document(authNotifier.currentUser.userId);

//   DocumentReference groupDocRef =
//       await Firestore.instance.collection("trends").add({
//     'groupName': trend.groupName,
//     'groupIcon': '',
//     'admin': authNotifier.currentUser.userName,
//     'adminId': authNotifier.currentUser.userId,
//     'members': [],
//     'groupSlogan': trend.groupSlogan,
//     'groupId': '',
//     'recentMessage': '',
//     'recentMessageSender': '',
//     'recentMessageTime': ''
//   });

//   await groupDocRef.updateData({
//     'members': FieldValue.arrayUnion([authNotifier.currentUser.userId]),
//     'groupId': groupDocRef.documentID
//   });

//   await userDocRef.updateData({
//     'trends': FieldValue.arrayUnion([groupDocRef.documentID])
//   });
//   List<Group> trendList = [];
//   trendList.add(trend);
//   groupNotifier.trendList = groupNotifier.trendList + trendList;
// }

// // has user joined the group
// Future<bool> isUserJoined(Group association, AuthNotifier authNotifier) async {
//   DocumentReference userDocRef = Firestore.instance
//       .collection("users")
//       .document(authNotifier.currentUser.userId);
//   DocumentSnapshot userDocSnapshot = await userDocRef.get();

//   List<dynamic> associations = await userDocSnapshot.data['associations'];

//   if (associations.contains(association.groupId)) {
//     //print('he');
//     return true;
//   } else {
//     //print('ne');
//     return false;
//   }
// }

// // // get user data
// // Future getUserData(String email) async {
// //   QuerySnapshot snapshot =
// //       await userCollection.where('email', isEqualTo: email).getDocuments();
// //   print(snapshot.documents[0].data);
// //   return snapshot;
// // }

// // // get user groups
// // getUserGroups() async {
// //   // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
// //   return Firestore.instance.collection("users").document(uid).snapshots();
// // }

// // send message
// sendMessage(Group association, String type, chatMessageData) {
//   Firestore.instance
//       .collection(type)
//       .document(association.groupId)
//       .collection('messages')
//       .add(chatMessageData);
//   Firestore.instance.collection(type).document(association.groupId).updateData({
//     'recentMessage': chatMessageData['message'],
//     'recentMessageSender': chatMessageData['sender'],
//     'recentMessageTime': chatMessageData['time'].toString(),
//   });
// }

// // get chats of a particular group
// getChats(Group association, String type) async {
//   return Firestore.instance
//       .collection(type)
//       .document(association.groupId)
//       .collection('messages')
//       .orderBy('time')
//       .snapshots();
// }

// getUserGroups(GroupNotifier groupNotifier, User currentUser) async {
//   List<Group> trendList = [];
//   List<Group> trendListNot = [];
//   List<Group> associationList = [];
//   List<Group> associationListNot = [];

//   QuerySnapshot inasso =
//       await Firestore.instance.collection("associations").getDocuments();

//   inasso.documents.forEach((snapshot) async {
//     Group activeGroup = new Group();
//     List<dynamic> membersinasso = snapshot['members'];
//     activeGroup.groupId = snapshot.data['groupId'];
//     activeGroup.groupName = snapshot.data['groupName'];
//     activeGroup.adminId = snapshot.data['adminId'];
//     activeGroup.groupSlogan = snapshot.data['groupSlogan'];

//     activeGroup.members = snapshot.data['members'];
//     activeGroup.recentMessage = snapshot.data['recentMessage'];
//     activeGroup.recentMessageSender = snapshot.data['recentMessageSender'];
//     activeGroup.recentMessageTime = snapshot.data['recentMessageTime'];
//     DocumentReference serviceProvider = Firestore.instance
//         .collection("serviceProviders")
//         .document(snapshot.data['adminId']);
//     serviceProvider.get().then((value) {
//       value.data['serviceId'] = snapshot.data['adminId'];
//       activeGroup.image = ServiceProvider.fromMap(value.data).image;
//     });
//     if (membersinasso.contains(currentUser.userId)) {
//       activeGroup.isMember = true;
//       associationList.add(activeGroup);
//     } else {
//       activeGroup.isMember = false;
//       associationListNot.add(activeGroup);
//     }
//   });

//   QuerySnapshot intrend =
//       await Firestore.instance.collection("trends").getDocuments();

//   intrend.documents.forEach((snapshot) async {
//     Group activeTrend = new Group();
//     List<dynamic> membersintrend = snapshot['members'];
//     activeTrend.groupId = snapshot.data['groupId'];
//     activeTrend.groupName = snapshot.data['groupName'];
//     activeTrend.adminId = snapshot.data['adminId'];
//     activeTrend.groupSlogan = snapshot.data['groupSlogan'];

//     activeTrend.members = snapshot.data['members'];
//     activeTrend.recentMessage = snapshot.data['recentMessage'];
//     activeTrend.recentMessageSender = snapshot.data['recentMessageSender'];
//     activeTrend.recentMessageTime = snapshot.data['recentMessageTime'];
//     DocumentReference serviceProvider = Firestore.instance
//         .collection("users")
//         .document(snapshot.data['adminId']);
//     serviceProvider.get().then((value) {
//       value.data['userId'] = snapshot.data['adminId'];
//       activeTrend.image = User.fromMap(value.data).image;
//     });
//     if (membersintrend.contains(currentUser.userId)) {
//       activeTrend.isMember = true;
//       trendList.add(activeTrend);
//     } else {
//       activeTrend.isMember = false;
//       trendListNot.add(activeTrend);
//     }
//   });

//   groupNotifier.associationList = associationList + associationListNot;
//   groupNotifier.trendList = trendList + trendListNot;
// }

// getServiceProviderGroups(
//     GroupNotifier groupNotifier, ServiceProvider currentServiceProvider) async {
//   List<Group> associationList = [];
//   QuerySnapshot snapshot = await Firestore.instance
//       .collection("associations")
//       .where("adminId", isEqualTo: currentServiceProvider.serviceId)
//       .getDocuments();

//   snapshot.documents.forEach((element) {
//     Group activeGroup = new Group();
//     activeGroup.groupId = element.data['groupId'];
//     activeGroup.groupName = element.data['groupName'];
//     activeGroup.adminId = element.data['adminId'];
//     activeGroup.groupSlogan = element.data['groupSlogan'];
//     activeGroup.members = element.data['members'];
//     activeGroup.recentMessage = element.data['recentMessage'];
//     activeGroup.recentMessageSender = element.data['recentMessageSender'];
//     activeGroup.recentMessageTime = element.data['recentMessageTime'];
//     DocumentReference serviceProvider = Firestore.instance
//         .collection("serviceProviders")
//         .document(currentServiceProvider.serviceId);
//     serviceProvider.get().then((value) {
//       value.data['serviceId'] = value.documentID;
//       activeGroup.image = ServiceProvider.fromMap(value.data).image;
//     });
//     associationList.add(activeGroup);
//     // groupNotifier.currentAssociation = activeGroup;
//   });

//   groupNotifier.associationList = associationList;
// }

// //Event Functions

// uploadEventAndImage(Event event, bool isUpdating, File localFile,
//     Function eventUploaded, ServiceProvider serviceProvider) async {
//   if (localFile != null) {
//     print("uploading image");

//     var fileExtension = path.extension(localFile.path);
//     print(fileExtension);

//     var uuid = Uuid().v4();

//     final StorageReference firebaseStorageRef = FirebaseStorage.instance
//         .ref()
//         .child('events/images/$uuid$fileExtension');

//     await firebaseStorageRef
//         .putFile(localFile)
//         .onComplete
//         .catchError((onError) {
//       print(onError);
//       return false;
//     });

//     String url = await firebaseStorageRef.getDownloadURL();
//     print("download url: $url");
//     _uploadEvent(event, isUpdating, eventUploaded, serviceProvider,
//         imageUrl: url);
//   } else {
//     print('...skipping image upload');
//     _uploadEvent(event, isUpdating, eventUploaded, serviceProvider);
//   }
// }

// _uploadEvent(Event event, bool isUpdating, Function eventUploaded,
//     ServiceProvider serviceProvider,
//     {String imageUrl}) async {
//   CollectionReference eventRef = Firestore.instance.collection("events");
//   event.serviceProviderId = serviceProvider.serviceId;

//   if (imageUrl != null) {
//     event.image = imageUrl;
//   }

//   if (isUpdating) {
//     event.updatedAt = Timestamp.now();

//     await eventRef.document(event.id).updateData(event.toMap());

//     eventUploaded(event);
//     print('updated event with id: ${event.id}');
//   } else {
//     event.updatedAt = Timestamp.now();
//     event.createdAt = Timestamp.now();

//     DocumentReference documentRef = await eventRef.add(event.toMap());

//     event.id = documentRef.documentID;

//     print('uploaded event successfully: ${event.toString()}');

//     await documentRef.setData(event.toMap(), merge: true);

//     eventUploaded(event);
//   }
// }

// getServiceEvents(
//     EventNotifier eventsNotifier, ServiceProvider serviceProvider) async {
//   QuerySnapshot categories =
//       await Firestore.instance.collection("events").getDocuments();
//   categories.documents.forEach((element) async {
//     List<Event> events = [];
//     QuerySnapshot snapshot = await Firestore.instance
//         .collection("events")
//         .where("serviceProviderId", isEqualTo: serviceProvider.serviceId)
//         .getDocuments();

//     snapshot.documents.forEach((document) {
//       document.data['id'] = document.documentID;

//       Event event = Event.fromMap(document.data);
//       event.eventDate = DateTime.fromMillisecondsSinceEpoch(
//           document.data['eventDate'].millisecondsSinceEpoch);

//       events.add(event);
//     });
//     eventsNotifier.eventList = events;
//   });
// }

// getEvents(EventNotifier eventsNotifier) async {
//   QuerySnapshot categories =
//       await Firestore.instance.collection("events").getDocuments();
//   categories.documents.forEach((element) async {
//     List<Event> events = [];
//     QuerySnapshot snapshot =
//         await Firestore.instance.collection("events").getDocuments();

//     snapshot.documents.forEach((document) {
//       document.data['id'] = document.documentID;

//       Event event = Event.fromMap(document.data);
//       event.eventDate = DateTime.fromMillisecondsSinceEpoch(
//           document.data['eventDate'].millisecondsSinceEpoch);

//       events.add(event);
//     });
//     eventsNotifier.eventList = events;
//   });
// }

// getMedicalServices(EmergencyNotifier emergencyNotifier) async {
//   List<ServiceProvider> medicalList = [];
//   QuerySnapshot snap = await Firestore.instance
//       .collection("serviceProviders")
//       .document("allSections")
//       .collection("welfareServices")
//       .where("serviceType", isEqualTo: "Medical")
//       .getDocuments();

//   snap.documents.forEach((element) {
//     ServiceProvider medical = new ServiceProvider();
//     medical = ServiceProvider.fromMap(element.data);
//     medical.serviceId = element.documentID;
//     medicalList.add(medical);
//   });
//   emergencyNotifier.medicalServices = medicalList;
// }

// getSecurityServices(EmergencyNotifier emergencyNotifier) async {
//   List<ServiceProvider> securityList = [];
//   QuerySnapshot snap = await Firestore.instance
//       .collection("serviceProviders")
//       .document("allSections")
//       .collection("welfareServices")
//       .where("serviceType", isEqualTo: "Security")
//       .getDocuments();

//   snap.documents.forEach((element) {
//     ServiceProvider security = new ServiceProvider();
//     security = ServiceProvider.fromMap(element.data);
//     security.serviceId = element.documentID;
//     securityList.add(security);
//   });
//   emergencyNotifier.securityServices = securityList;
// }

// sendEmergency(Emergency emergency) async {
//   emergency.createdAt = DateTime.now();
//   emergency.status = "Active";
//   print(emergency.type);

//   DocumentReference documentRef = await Firestore.instance
//       .collection("emergencyCalls")
//       .add(emergency.toMap());

//   emergency.id = documentRef.documentID;

//   await documentRef.setData(emergency.toMap(), merge: true);
// }

// getEmergencyCalls(
//     EmergencyNotifier emergencyNotifier, AuthNotifier authNotifier) async {
//   QuerySnapshot snap = await Firestore.instance
//       .collection("emergencyCalls")
//       .where("type", isEqualTo: authNotifier.currentServiceProvider.serviceType)
//       .where("status", isEqualTo: "Active")
//       .getDocuments();
//   List<Emergency> elements = [];
//   snap.documents.forEach((element) async {
//     Emergency emergency = new Emergency();
//     emergency = Emergency.fromMap(element.data);
//     emergency.createdAt = DateTime.fromMillisecondsSinceEpoch(
//         element.data['createdAt'].millisecondsSinceEpoch);
//     QuerySnapshot userSnap = await Firestore.instance
//         .collection("users")
//         .where("userId", isEqualTo: element.data['senderId'])
//         .getDocuments();
//     userSnap.documents.forEach((element) {
//       User user = new User();

//       user = User.fromMap(element.data);
//       user.userId = element.documentID;
//       emergency.user = user;
//     });

//     elements.add(emergency);
//   });
//   emergencyNotifier.emergencyList = elements;
//   print(elements);
// }

// alertEmergency(Emergency emergency) async {
//   QuerySnapshot snap =
//       await Firestore.instance.collection("users").getDocuments();
//   List<String> userTokens = [];

//   snap.documents.forEach((element) async {
//     QuerySnapshot snapb = await Firestore.instance
//         .collection("users")
//         .document(element.documentID)
//         .collection("tokens")
//         .getDocuments();
//     snapb.documents.forEach((elementb) {
//       userTokens.add(elementb.documentID);
//       callOnFcmApiSendPushNotifications(elementb.documentID, emergency);
//     });
//     // userTokens.add(token);
//   });
// }

// Future<bool> callOnFcmApiSendPushNotifications(
//     String userToken, Emergency emergency) async {
//   final postUrl = 'https://fcm.googleapis.com/fcm/send';
//   final data = {
//     "to": userToken,
//     "collapse_key": "type_a",
//     "notification": {
//       "title": emergency.category,
//       "body": emergency.description,
//     }
//   };

//   final headers = {
//     'content-type': 'application/json',
//     'Authorization':
//         "key=AAAAWarxmCY:APA91bEarSjce7OeE_fuIOwIknNsvl08zEWLJTZ4MBV7twVSyoX2UfTcl_XEAlaLUr6TEZ9aS-4IJtWGvJcXi4PX5kQ6pugRjpgH4MEUChRXj9wqNBgUJgMOrC4fEKlUO-R7_Vuaoioq" // 'key=YOUR_SERVER_KEY'
//   };

//   final response = await http.post(postUrl,
//       body: json.encode(data),
//       encoding: Encoding.getByName('utf-8'),
//       headers: headers);

//   if (response.statusCode == 200) {
//     // on success do sth
//     print('test ok push CFM');
//     return true;
//   } else {
//     print(' CFM error');
//     // on failure do sth
//     return false;
//   }
// }
