import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_color/random_color.dart';

class ShowDetail extends StatefulWidget {
  var data, countryTitle;
  ShowDetail(this.data, this.countryTitle);
  @override
  _ShowDetailState createState() => _ShowDetailState();
}

class _ShowDetailState extends State<ShowDetail> {
  RandomColor randomColor = RandomColor();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          widget.countryTitle.toString().toUpperCase(),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: LayoutBuilder(builder: (_, constraints) {
          var formatDate = DateTime.tryParse("${widget.data["lastUpdate"]}");
          String formattedDate = DateFormat('EEE, M/d/y, kk:mm') == null
              ? DateTime.now()
              : DateFormat('EEE, M/d/y, kk:mm').format(formatDate);
          debugPrint(formattedDate);
          if (constraints.maxWidth < 600) {
            height = height / 2;
            width = width - 40;
            // height = 250;
            // width = 250;
          } /* else if (constraints.maxWidth > 600 && constraints.maxWidth < 800) {
            // height = height / 2;
            // width = width - 80;
            height = 250;
            width = 250;
          } */
          else {
            height = height / 2;
            width = width / 2;
            // height = 250;
            // width = 250;
          }
          return Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Confirmed : ${widget.data["confirmed"]["value"]}",
                    // style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Deaths : ${widget.data["deaths"]["value"]}",
                    // style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Recovered : ${widget.data["recovered"]["value"]}",
                    // style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Last Updated : $formattedDate",
                    // style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
