import 'package:flutter/material.dart';
import '../models/ticket.dart';

class DataScreen extends StatelessWidget {
  final Ticket ticket;
  final bool isChecking;
  DataScreen({this.ticket, this.isChecking});

  @override
  Widget build(BuildContext context) {
    String displayText = '';

    if(ticket.is_used){
      displayText = 'el boleto ya fue utilizado';
    } else if (isChecking && !ticket.is_used){
      displayText = 'El boleto esta listo para utilizar';
    } else if (!isChecking && !ticket.is_used){
      displayText = 'Boleto utilizado, Disfrute su evento!';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Ticket'),
        backgroundColor: ticket.is_used ? Colors.blueGrey : Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.account_circle,
                          color: Colors.black87,
                          size: 40.0,
                        ),
                        SizedBox(width: 10.0,),
                        Text(
                          'Cliente: ',
                          style: TextStyle(color: Colors.black87, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 60.0,),
                  Text(
                    ticket.name,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 22.0, color: Colors.teal),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.picture_in_picture,
                          color: Colors.black87,
                          size: 40.0,
                        ),
                        SizedBox(width: 10.0,),
                        Text(
                          'ID nacional: ',
                          style: TextStyle(color: Colors.black87, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      ticket.gov_id,
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 22.0, color: Colors.teal),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.confirmation_number,
                          color: Colors.black87,
                          size: 40.0,
                        ),
                        SizedBox(width: 10.0,),
                        Text(
                          'Numero de Ticket: ',
                          style: TextStyle(color: Colors.black87, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    ticket.ticket_alias,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 22.0, color: Colors.teal),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          ticket.is_used ? Icons.block : Icons.check,
                          color: ticket.is_used ? Colors.red: Colors.green,
                          size: 60.0,
                        ),
                        SizedBox(width: 10.0,),
                      ],
                    ),
                  ),
                  Text(
                    displayText,
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    softWrap: true,
                    style: TextStyle(fontSize: 22.0, color: ticket.is_used ? Colors.red: Colors.green,),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
