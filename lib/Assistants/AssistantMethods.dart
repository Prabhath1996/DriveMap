import 'package:drive_me/Assistants/requestAssistant.dart';
import 'package:drive_me/DataHandler/appData.dart';
import 'package:drive_me/Models/address.dart';
import 'package:drive_me/Models/directionDetails.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AssistantMathods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyBDmFlTwIcYOq5FakstxXPDuxJVqlNbtJg";

    var response = await RequestAssistant.getRequest(url);

    if (response != "failed") {
      placeAddress = response["results"][0]["formatted_address"];

      // st1 = response["results"][0]["address_components"][3]["long_name"];
      // st2 = response["results"][0]["address_components"][4]["long_name"];
      // st3 = response["results"][0]["address_components"][5]["long_name"];
      // st4 = response["results"][0]["address_components"][6]["long_name"];

      // placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;
      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;
      //print(placeAddress);
      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    } else {
     // print("somthing wrong");
    }
    return placeAddress;
  }

  static Future<DirectionDetails> obtainPlaceDirectioDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String dirctionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=AIzaSyBDmFlTwIcYOq5FakstxXPDuxJVqlNbtJg";

    var res = await RequestAssistant.getRequest(dirctionUrl);
    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];

    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];

    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static int claculateFares(DirectionDetails directionDetails) {
    //it itm USD
    double timeTraveleFare = (directionDetails.durationValue / 60) * 0.20;
    double distancTraveleFare = (directionDetails.durationValue / 1000) * 0.20;
    double totalFareAmount = timeTraveleFare + distancTraveleFare;

    //1$ = 160Rs
    double totalLocalAmount = totalFareAmount * 160;

    return totalFareAmount.truncate();
  }
}
