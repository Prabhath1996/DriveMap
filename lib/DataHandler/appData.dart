import 'package:drive_me/Models/address.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation, dropOffLoction;

  void updatePickUpLocationAddress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updatedropOffLoction(Address dropOffLoctionAddress) {
    dropOffLoction = dropOffLoctionAddress;
    notifyListeners();
  }
}
