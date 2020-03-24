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

  @override
  void initState() {
    super.initState();
    // getCoronaData("USA");

    getAllCoronaData();
    showicon = false;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
                    customBoxContainer(height, width, allData),
                  ],
                ),
              )
            : LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                backgroundColor: Colors.purpleAccent,
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
          itemBuilder: (context, i) => Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Country : ${allData[i]["countryRegion"]}",
                ),
                Text(
                  "State : ${allData[i]["provinceState"] == null ? allData[i]["countryRegion"] : allData[i]["provinceState"]}",
                ),
                Text(
                  "Confirmed : ${allData[i]["confirmed"]}",
                ),
                Text(
                  "Deaths : ${allData[i]["deaths"]}",
                ),
                Text(
                  "Recovered : ${allData[i]["recovered"]}",
                ),
                Text(
                  "Active : ${allData[i]["active"]}",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  });
}
