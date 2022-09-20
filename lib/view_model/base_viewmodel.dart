import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  final Map<int, bool> _busyStates = <int, bool>{};

  bool busy(Object object) => _busyStates[object.hashCode] ?? false;

  bool get isBusy => busy(this);

  void setBusy(bool value) {
    setBusyForObject(this, value);
  }

  void setBusyForObject(Object object, bool value) {
    _busyStates[object.hashCode] == value;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      notifyListeners();
    });
  }

  Future runBusyFuture(Future busyFuture, {required Object busyHascode}) async {
    setBusyForObject(this, true);
    var value = await busyFuture;
    setBusyForObject(this, false);
    return value;
  }
}
