import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:market_place_flutter/api/api_client.dart';
import 'package:market_place_flutter/models/base_model.dart';
import 'package:market_place_flutter/models/customer.dart';
import 'package:market_place_flutter/models/payment_method.dart';
import 'package:market_place_flutter/utils/constants.dart';
import 'package:market_place_flutter/utils/widgets_helper.dart';

class ListPayment extends StatefulWidget {
  final int month;
  final int year;
  final String query;
  ListPayment(
      {Key? key,
      required int this.month,
      required int this.year,
      required String this.query})
      : super(key: key);

  @override
  _ListPaymentState createState() => _ListPaymentState();
}

class _ListPaymentState extends State<ListPayment> {
  String token = '';
  bool isLunas = false;
  List<PaymentMethod> paymentMethodList = [];
  final _formKey = GlobalKey<FormState>();
  _ListPaymentState();
  //late Future<BaseModel> futureData;
  @override
  void initState() {
    super.initState();
    getPaymentMethod();

    //futureData = dataku();
    // SharedPreferencesActions()
    //     .read(key: 'token')
    //     .then((value) => token = value);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> params = {
      "month": widget.month,
      "year": widget.year,
      "q": widget.query
    };
    return Scaffold(
      body: Column(
        children: [
          // Container(
          //   margin: EdgeInsets.all(10),
          //   padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          //   decoration: BoxDecoration(
          //       color: Colors.grey, borderRadius: BorderRadius.circular(20)),
          //   child: TextField(
          //     decoration: InputDecoration(
          //         hintText: widget.month.toString(),
          //         icon: Icon(Icons.search_rounded)),
          //   ),
          // ),
          Expanded(
              child: FutureBuilder<BaseModel>(
            future: ApiClient(context)
                .getPaymentList(params)
                .onError((error, stackTrace) => handleError(error)),
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
    //bool isBayar = customer.payment.isNotEmpty ? true : false;
    PaymentMethod? _paymentMethodSelected;
    if (customer.payment.isNotEmpty) {
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
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0.0,
                    backgroundColor: Colors.white,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 25),
                              Text("Form Pembayaran Pelanggan"),
                              SizedBox(height: 25),
                              _formPembayaran("Nama", customer.name,
                                  Icons.people_alt_rounded),
                              _formPembayaran("Bulan", widget.month.toString(),
                                  Icons.calendar_view_day),
                              _formPembayaran("Tahun", widget.year.toString(),
                                  Icons.calendar_today),
                              _formPembayaran(
                                  "Total Bayar",
                                  customer.total_payment.toString(),
                                  Icons.money),
                              Container(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  width: 270,
                                  child: DropdownButtonFormField(
                                    validator: (value) => value == null
                                        ? "Pilih pembayaran dulu"
                                        : null,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          12.0, 8.0, 12.0, 8.0),
                                      icon: Icon(Icons.payment),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                      labelText: "Metoda Pembayaran",
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                    value: _paymentMethodSelected,
                                    items: paymentMethodList.map((item) {
                                      return new DropdownMenuItem(
                                          child: Text(item.name), value: item);
                                    }).toList(),
                                    onChanged: (newVal) {
                                      _paymentMethodSelected =
                                          newVal as PaymentMethod;
                                    },
                                  )),
                              SizedBox(height: 20),
                              ElevatedButton(
                                  style: raisedButtonStyle,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      Navigator.of(context).pop(true);
                                      showDialog(
                                          context: context,
                                          builder: (context) => WidgetHelper()
                                              .showAlertDialog(
                                                  context: context,
                                                  title:
                                                      "Bayar Tagihan Pelanggan " +
                                                          customer.name,
                                                  message:
                                                      "Anda setuju untuk membayar tagihan internet dan aksi ini tidak dapat dikembalikan, kamu yakin?",
                                                  actionYes: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                    payWifi(customer,
                                                        _paymentMethodSelected);
                                                  }));
                                    }
                                  },
                                  child: Text("Bayar"))
                            ],
                          )),
                    ),
                  );
                });
          },
          child: Text('BAYAR'),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(2),
              elevation: 3, //elevation of button
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              primary: Colors.transparent,
              side: BorderSide(color: Colors.red, width: 1)),
        ),
      );
    }
  }

  Widget _formPembayaran(String label, String value, IconData iconData) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        width: 270,
        height: 42,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          initialValue: value,
          enabled: false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
            icon: Icon(iconData),
            labelText: label,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(),
            ),
          ),
          onChanged: (val) {},
        ));
  }

  getPaymentMethod() async {
    final res = await ApiClient(context).getPaymentMethodList();
    if (res.code == 0) {
      paymentMethodList = (res.data['data'] as List)
          .map((e) => PaymentMethod.fromJson(e))
          .toList();
      //print(paymentMethodList.toString());
    }
  }

  payWifi(Customer customer, PaymentMethod? paymentMethodSelected) async {
    Map<String, dynamic> queries = {
      "customer_id": customer.id,
      "month": widget.month,
      "year": widget.year,
      "total": customer.total_payment,
      "status": 1,
      "payment_method_id": paymentMethodSelected!.id
    };
    final res = await ApiClient(context).postPayment(queries);
    if (res.code == 0) {
      setState(() {});
      final snackBar = SnackBar(content: Text('Pembayaran berhasil'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // });
    }
  }

  handleError(Object? error) {
    print("error juragan");
  }
}
