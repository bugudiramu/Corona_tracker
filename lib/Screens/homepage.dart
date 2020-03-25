import 'package:coronovirus_tracker/Models/confirmed_model.dart';
import 'package:coronovirus_tracker/Screens/show_detail.dart';
import 'package:coronovirus_tracker/Styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double height;
  double width;
  bool showicon;
  Map<String, dynamic> data;
  List allData = [];
  Map<String, dynamic> totalData;
  List<ConfirmedModel> confirmedData = List<ConfirmedModel>();
  bool isLoading = true;
  var countryController = TextEditingController();
  Future<void> getCoronaData(String country) async {
    String url = "https://covid19.mathdro.id/api/countries/$country";
    http.Response response = await http.get(Uri.encodeFull(url));
    var jsonData = await jsonDecode(response.body);
    setState(() {
      data = jsonData;
      isLoading = false;
    });
  }

  Future<void> getAllCoronaData() async {
    String url = "https://covid19.mathdro.id/api/confirmed";
    http.Response response = await http.get(Uri.encodeFull(url));
    var jsonData = await jsonDecode(response.body);
    setState(() {
      allData = jsonData;
      isLoading = false;
    });
  }

  Future<void> getTotalData() async {
    String url = "https://covid19.mathdro.id/api";
    http.Response response = await http.get(Uri.encodeFull(url));
    var jsonData = await jsonDecode(response.body);
    setState(() {
      totalData = jsonData;
      isLoading = false;
    });
    debugPrint(totalData.toString());
  }

  _showTotalDataDialog(Map<String, dynamic> totalData) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Corona Stats - Overall", textAlign: TextAlign.center),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SelectableText(
                "Confirmed Cases : ${totalData["confirmed"]["value"]}"
                    .toUpperCase(),
              ),
              SizedBox(height: 8.0),
              SelectableText(
                "Total Deaths : ${totalData["deaths"]["value"]}".toUpperCase(),
              ),
              SizedBox(height: 8.0),
              SelectableText(
                "Recovered : ${totalData["recovered"]["value"]}".toUpperCase(),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              color: Colors.green,
              onPressed: () => Navigator.pop(context),
              child: Text("Done")),
        ],
      ),
    );
  }

  Future _refresh() async {
    print("Refrshing");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    // _showTotalDataDialog(totalData);
    getTotalData();
    getAllCoronaData();
    showicon = false;
    Future.delayed(Duration(seconds: 2), () => _showTotalDataDialog(totalData));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    /* SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );*/

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            "Corona Tracker",
            style: Styles.headerStyle,
          ),
        ),
        body: isLoading == false
            ? SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  )),
                              child: TextField(
                                autofocus: false,
                                enableSuggestions: true,
                                cursorColor: Colors.purple,
                                controller: countryController,
                                toolbarOptions: ToolbarOptions(
                                    copy: true,
                                    cut: true,
                                    paste: true,
                                    selectAll: true),
                                textInputAction: TextInputAction.search,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: !showicon
                                      ? null
                                      : IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () {
                                            countryController.text = "";
                                          }),
                                  hintText: 'Search for a country... ',
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                ),
                                onChanged: (input) {
                                  if (countryController.text.length > 0) {
                                    setState(() {
                                      showicon = true;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            child: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () async {
                                  if (countryController.text.length >= 2) {
                                    await getCoronaData(countryController.text
                                        .toString()
                                        .trim());
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => ShowDetail(
                                                data,
                                                countryController.text
                                                    .toString())));
                                  } else {
                                    return;
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                    RefreshIndicator(
                        onRefresh: _refresh,
                        child: customBoxContainer(height, width, allData)),
                  ],
                ),
              )
            : LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.purpleAccent,
                semanticsLabel: "Loading",
              ));
  }
}

Widget customBoxContainer(double height, double width, allData) {
  int grids = 1;
  var fontSize = 18.0;

  return LayoutBuilder(builder: (_, constraints) {
    if (constraints.maxWidth < 600) {
      grids = 1;
      fontSize = 16.0;
    } else if (constraints.maxWidth > 600 && constraints.maxWidth < 800) {
      grids = 2;
      fontSize = 28.0;
    } else {
      grids = 4;
      fontSize = 22.0;
    }
    return Scrollbar(
      child: Container(
        height: height,
        child: GridView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: grids, crossAxisSpacing: 16, mainAxisSpacing: 16),
          itemCount: allData == null ? 0 : allData.length,
          itemBuilder: (context, i) => ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SelectableText(
                      "Country : ${allData[i]["countryRegion"]}".toUpperCase(),
                    ),
                    SelectableText(
                      "State : ${allData[i]["provinceState"] == null ? allData[i]["countryRegion"] : allData[i]["provinceState"]}"
                          .toUpperCase(),
                    ),
                    SelectableText(
                      "Confirmed : ${allData[i]["confirmed"]}".toUpperCase(),
                    ),
                    SelectableText(
                      "Deaths : ${allData[i]["deaths"]}".toUpperCase(),
                    ),
                    SelectableText(
                      "Recovered : ${allData[i]["recovered"]}".toUpperCase(),
                    ),
                    SelectableText(
                      "Active : ${allData[i]["active"]}",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  });
}

/**
 *       decoration: BoxDecoration(
              // color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.0),
              shape: BoxShape.rectangle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
 */
