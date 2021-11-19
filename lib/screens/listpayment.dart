import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:market_place_flutter/api/api_client.dart';
import 'package:market_place_flutter/models/base_model.dart';
import 'package:market_place_flutter/models/customer.dart';

class ListPayment extends StatefulWidget {
  final int month;
  final int year;
  ListPayment({Key? key, required int this.month, required int this.year})
      : super(key: key);

  @override
  _ListPaymentState createState() => _ListPaymentState();
}

class _ListPaymentState extends State<ListPayment> {
  String token = '';
  bool isLunas = false;

  _ListPaymentState();
  //late Future<BaseModel> futureData;
  @override
  void initState() {
    super.initState();
    //futureData = dataku();
    // SharedPreferencesActions()
    //     .read(key: 'token')
    //     .then((value) => token = value);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> params = {"month": widget.month, "year": widget.year};
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(20)),
            child: TextField(
              decoration: InputDecoration(
                  hintText: widget.month.toString(),
                  icon: Icon(Icons.search_rounded)),
            ),
          ),
          Expanded(
              child: FutureBuilder<BaseModel>(
            future: ApiClient(context).getPaymentList(params),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var listdinamic = snapshot.data!.data;
                List<Customer> pay = (listdinamic['data'] as List)
                    .map((e) => Customer.fromJson(e))
                    .toList();
                return _uiListData(pay);
              } else {
                // print(snapshot.error.toString());
                return Center(child: CircularProgressIndicator());
              }
            },
          ))
        ],
      ),
    );
  }

  Widget _uiListData(List<Customer> pay) {
    return ListView.builder(
      itemCount: pay.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
            child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(pay[index].name),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          margin: EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            color: Colors.red,
                          ),
                          child: Text(pay[index].network_type,
                              style:
                                  TextStyle(fontSize: 8, color: Colors.white)))
                    ],
                  ),
                  Text(
                    pay[index].adress,
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  )
                ],
              ),
              Row(children: [
                Text("Rp. " + pay[index].total_payment.toString()),
                SizedBox(
                  width: 10,
                ),
                _uiActionStatus(customer: pay[index])
              ])
            ],
          ),
        ));
      },
    );
  }

  Widget _uiActionStatus({required Customer customer}) {
    bool isBayar = customer.payment.length != 0 ? true : false;
    if (isBayar) {
      return Column(
        children: [
          Text(
            "2021-02-22",
            style: TextStyle(fontSize: 10),
          ),
          SizedBox(
            width: 60,
            height: 20,
            child: ElevatedButton(
              child: Text("PAID"),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(2),
                  elevation: 3, //elevation of button
                  shape: RoundedRectangleBorder(
                      //to set border radius to button
                      borderRadius: BorderRadius.circular(20)),
                  primary: Colors.green,
                  side: BorderSide(color: Colors.yellow, width: 1)),
            ),
          )
        ],
      );
    } else {
      return SizedBox(
        width: 60,
        height: 20,
        child: ElevatedButton(
          onPressed: () {},
          child: Text('BAYAR'),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(2),
              elevation: 3, //elevation of button
              shape: RoundedRectangleBorder(
                  //to set border radius to button
                  borderRadius: BorderRadius.circular(20)),
              primary: Colors.transparent,
              side: BorderSide(color: Colors.red, width: 1)),
        ),
      );
    }
  }
}
