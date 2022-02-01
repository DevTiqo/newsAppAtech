import 'package:flutter/widgets.dart';
import 'package:newsapp/models/user.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthNotifier extends ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  User _user = User(
    id: 0,
    name: "",
    email: "",
    phone: "",
  );

  User get user => _user;

  Status get loggedInStatus => _loggedInStatus;
  Status get registerdInStatus => _registeredInStatus;

  set loggedInStatus(Status value) {
    _loggedInStatus = value;
  }

  set registeredInstatus(Status value) {
    registeredInstatus = value;
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void removeUser() {
    _user = User(name: "", id: 0, phone: "", email: "");
    notifyListeners();
  }
}
