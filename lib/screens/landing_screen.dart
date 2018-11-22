import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/ticket.dart';
import 'dart:convert';
import './data_screen.dart';
import 'package:http/http.dart' as http;

const IS_USED = '1';
const IS_NOT_USED = '0';

class LandingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LandingScreenState();
  }
}

class LandingScreenState extends State<LandingScreen> {
  bool isCheking = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    bool isChecking = this.isCheking;
    var colorValue = isChecking ? Colors.blueGrey : Colors.white;


    var body = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "AyyQR Scanner",
          style: TextStyle(
              color: colorValue,
              fontSize: 50.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        AnimatedOpacity(
          opacity: isChecking ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: Text(
            "(Solo chequeo)",
            style: TextStyle(
                color: colorValue,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
        ),
        SizedBox(
          height: 40.0,
          width: 0.0,
        ),
        Container(
          height: 130.0,
          width: 160.0,
          margin: EdgeInsets.only(bottom: 20.0),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: colorValue,
            borderRadius: new BorderRadius.circular(25.0),
            border: new Border.all(
              width: 1.0,
              color: Colors.black26,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Text(
                  "Chequear",
                  style: TextStyle(
                    color: isChecking ? Colors.white : Colors.blueGrey,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Checkbox(
                  value: isChecking,
                  onChanged: (value) {
                    setState(() {
                      isCheking = value;
                    });
                  }),
            ],
          ),
        ),
        MaterialButton(
          onPressed: scan,
          color: colorValue,
          splashColor: Colors.black87,
          child: Text(
            isChecking ? 'Chequear Ticket' : 'Usar ticket',
            style: TextStyle(
              color: isChecking ? Colors.white : Colors.blueGrey,
              fontSize: 30.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );


    var bodyProgress = new Container(
      child: new Stack(
        alignment: Alignment.center,
        children: <Widget>[
          body,
          new Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: new BorderRadius.circular(10.0)
              ),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: new CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        "loading.. wait...",
                        style: new TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Material(
        child: Container(
      color: isChecking ? Colors.white : Colors.blueGrey,
      child: isLoading ? bodyProgress : body,
    ));
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      //setState(() => this.barcode = barcode);
      handleQRCode(barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        print('The user did not grant the camera permission!');
      } else {
        print('Unknown error: $e');
      }
    } on FormatException {
      print(
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      print('Unknown error: $e');
    }
  }

//  Future _launchURL() async {
//    const url = 'https://flutter.io';
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {
//      throw 'Could not launch $url';
//    }
//  }

  Future handleQRCode(String barcode) async {
    const url = "https://17f3e934.ngrok.io/api/";
    const ticketApi = 'ticket';
    const updateTicketApi = 'updateTicket';
    Ticket element;
    setState(() {
      isLoading = true;
    });
    http.post((url + ticketApi), body: {'ticketCode': barcode}).then(
        (response) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('chevere 1');
      element = Ticket.fromJson(json.decode(response.body));
      print('element used: ${element.is_used}');
      final isValid = element.gov_id != null;
      if (isValid && !element.is_used && !this.isCheking) {
        http.post((url + updateTicketApi), body: {'ticketCode': barcode}).then(
            (updateResponse) {
              print('chevere 2');
              setState(() {
                isLoading = false;
              });
              Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DataScreen(ticket: element, isChecking: false,)));
          print('Response status: ${updateResponse.statusCode}');
          print('Response body: ${updateResponse.body}');
        });
      } else if (isValid && this.isCheking) {
        print('chevere 3');
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DataScreen(ticket: element, isChecking: true)));
      }
      else if(!isValid){

        _showDialog();
      }
    });
  }

  void _showDialog() {
    setState(() {
      isLoading = false;
    });
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Lo lamentamos"),
          content: new Text("El Qr que usted busca no coincide con nuestra base de datos"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
