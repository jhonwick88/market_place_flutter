import 'package:flutter/material.dart';
import 'package:market_place_flutter/api/api_client.dart';
import 'package:market_place_flutter/screens/calc_beapasang.dart';
import 'package:market_place_flutter/screens/catatan.dart';
import 'package:market_place_flutter/screens/listpayment.dart';
import 'package:market_place_flutter/screens/login_page.dart';
import 'package:market_place_flutter/utils/shared_preferences_actions.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

/// This is the main application widget.
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//   static const String _title = 'Flutter Code Sample';

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: _title,
//       home: MyStatefulWidget(),
//     );
//   }
// }

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  bool _isVisible = true;
  bool _isCatatan = false;
  var pref = SharedPreferencesActions();
  final DateTime initialDate = DateTime.now();
  DateTime? selectedDate;
  String query = "";

  List<Widget> _widgetOptions() => <Widget>[
        ListPayment(
            month: selectedDate!.month, year: selectedDate!.year, query: query),
        CalcBeaPasang(),
        CatatanPage(query: query),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      query == "";
      _isVisible = _selectedIndex != 1 ? true : false;
      _isCatatan = _selectedIndex == 2 ? true : false;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedDate = initialDate;
    //print("ini hari $selectedDate");
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> chidlren = _widgetOptions();
    return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            title: _isVisible
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextFormField(
                      autofocus: false,
                      decoration: InputDecoration(
                          icon: Icon(Icons.search),
                          border: InputBorder.none,
                          hintText:
                              _isCatatan ? "Cari Catatan" : "Cari Pelanggan",
                          hintStyle:
                              TextStyle(fontSize: 12, color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(vertical: 5)),
                      onChanged: (value) {
                        setState(() {
                          query = value.length > 2 ? value : "";
                        });
                      },
                    ),
                  )
                : Text("WifiPay"),
            actions: [
              Visibility(
                  visible: _selectedIndex == 0,
                  child: IconButton(
                      onPressed: () {
                        showMonthPicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year - 1, 5),
                          lastDate: DateTime(DateTime.now().year + 4, 9),
                          initialDate: selectedDate ?? initialDate,
                          locale: Locale("en"),
                        ).then((date) {
                          if (date != null) {
                            setState(() {
                              selectedDate = date;
                            });
                          }
                        });
                      },
                      icon: Icon(Icons.calendar_today))),
              PopupMenuButton(
                itemBuilder: (context) => [
                  // PopupMenuItem(
                  //     child: Row(
                  //       children: [
                  //         Icon(Icons.people, color: Colors.black),
                  //         SizedBox(width: 7),
                  //         Text("Profile")
                  //       ],
                  //     ),
                  //     value: 0),
                  PopupMenuItem(
                      child: Row(children: [
                        Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Text("Logout")
                      ]),
                      value: 0),
                ],
                onSelected: (item) => onSelected(context, item),
              ),
            ],
          ),
          body: Center(
            child: chidlren[_selectedIndex],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Laporan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calculate),
                label: 'Kalkulator',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Catatan',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        ));
  }

  void onSelected(context, item) {
    switch (item) {
      case 0:
        showDialog(
            context: context, builder: (context) => _buildExitDialog(context));
        break;
    }
  }

  getToken() async {
    return await pref.read(key: "token");
  }

  logout({required BuildContext context}) async {
    final response = await ApiClient(context).postUserLogout();
    print(response);
    if (response.code == 0) {
      await pref.delete(key: "token");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
        context: context, builder: (context) => _buildExitDialog(context));
    return exitResult ?? false;
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Konfirmasi"),
      content: const Text("Yakin ingin keluar aplikasi?"),
      actions: [
        ElevatedButton(
            onPressed: () {
              logout(context: context);
            },
            child: Text("Ya")),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("Tidak"))
      ],
    );
  }
}
