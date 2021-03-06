import 'package:drive_me/AllWidgets/Divider.dart';
import 'package:drive_me/Assistants/requestAssistant.dart';
import 'package:drive_me/DataHandler/appData.dart';
import 'package:drive_me/Models/address.dart';
import 'package:drive_me/Models/placePredictions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOfTextEditingController = TextEditingController();
  List<PlacePredeictions> placePredictionList = [];
  @override
  Widget build(BuildContext context) {
    // String placeAddress =
    //     Provider.of<AppData>(context).pickUpLocation.placeName ?? "";
    //
    String placeAddress = Provider.of<AppData>(context).pickUpLocation != null
        ? Provider.of<AppData>(context).pickUpLocation.placeName
        : "Searching...";
    pickUpTextEditingController.text = placeAddress;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: 180.0,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 6.0,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              )
            ]),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 25.0, top: 20.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 5.0,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                      Center(
                        child: Text(
                          "Set Drop Of",
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand-Bold"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      Image.asset("images/current_location.png",
                          height: 30.0, width: 30.0),
                      SizedBox(
                        height: 18.0,
                      ),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: TextField(
                            controller: pickUpTextEditingController,
                            decoration: InputDecoration(
                              hintText: "PickUp Location",
                              fillColor: Colors.grey[300],
                              filled: true,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(
                                  left: 11.0, top: 8.0, bottom: 8.0),
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                  //
                  SizedBox(
                    height: 18.0,
                  ),
                  Row(
                    children: [
                      Image.asset("images/where_to.png",
                          height: 30.0, width: 30.0),
                      SizedBox(
                        height: 18.0,
                      ),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: TextField(
                            onChanged: (val) {
                              findplace(val);
                            },
                            controller: dropOfTextEditingController,
                            decoration: InputDecoration(
                              hintText: "Where To?",
                              fillColor: Colors.grey[300],
                              filled: true,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(
                                  left: 11.0, top: 8.0, bottom: 8.0),
                            ),
                          ),
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),
          //title for display predictions
          SizedBox(
            height: 10.0,
          ),
          (placePredictionList.length > 0)
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListView.separated(
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, index) {
                      return PredictionTitle(
                        placePredeictions: placePredictionList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        DividerWidgets(),
                    itemCount: placePredictionList.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void findplace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${placeName}&key=AIzaSyBDmFlTwIcYOq5FakstxXPDuxJVqlNbtJg&sessiontoken=1234567890&components=country:lk";
      var res = await RequestAssistant.getRequest(autoCompleteUrl);

      if (res == "failed") {
        return null;
      }

      if (res["status"] == "OK") {
        //print("Place Predication Response:: Status Ok");
        var predictions = res["predictions"];
        var placeList = (predictions as List)
            .map((e) => PlacePredeictions.fromJson(e))
            .toList();
        //print(placeList);

        setState(() {
          placePredictionList = placeList;
        });
      }
      // print(res);
      // print("sample ========================== " +
      //     placePredictionList[1].main_text);
    }
  }
}

class PredictionTitle extends StatelessWidget {
  final PlacePredeictions placePredeictions;

  PredictionTitle({Key key, this.placePredeictions}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        getPlaceAddreesDetails(placePredeictions.place_id, context);
        //print("placePredeictions.place_id:::::" + placePredeictions.place_id);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(
              width: 10.0,
            ),
            Row(
              children: [
                Icon(Icons.add_location_alt_outlined),
                SizedBox(
                  width: 14.0,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      placePredeictions.main_text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      placePredeictions.secondary_text, //secondary_text
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                  ],
                )),
              ],
            ),
            SizedBox(
              width: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}

void getPlaceAddreesDetails(String placeId, context) async {
  String placeDetails =
      "https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&key=AIzaSyBDmFlTwIcYOq5FakstxXPDuxJVqlNbtJg";
  var res = await RequestAssistant.getRequest(placeDetails);
  // Navigator.pop(context);

  if (res == "failed") {
    //  print("sumthing wrong+++++++++++");
    return;
  }
  if (res["status"] == "OK") {
    Address address = Address();
    address.placeName = res["result"]["name"];
    address.placeId = placeId;
    address.latitude = res["result"]["geometry"]["location"]["lat"];
    address.longitude = res["result"]["geometry"]["location"]["lng"];

    Provider.of<AppData>(context, listen: false).updatedropOffLoction(address);
    // print("This is drop of location==============================" +
    //     address.placeName +
    //     "....... " +
    //     address.placeId +
    //     " latitude = " +
    //     address.latitude.toString() +
    //     " address.longitude =  " +
    //     address.longitude.toString());

    Navigator.pop(context, "obtainDirection");
  }
}
