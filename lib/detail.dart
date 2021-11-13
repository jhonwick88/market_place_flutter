// import 'package:flutter/material.dart';
//
// class MyDetail extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.deepOrange,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page oke'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   // int _counter = 0;
//   // void _incrementCounter() {
//   //   setState(() {
//   //     _counter++;
//   //   });
//   // }
//   // void _decrementCounter(){
//   //   setState(() {
//   //     _counter--;
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     Widget _buildCard() {
//       return SizedBox(
//         height: 210,
//         child: Card(
//           child: Column(
//             children: [
//               ListTile(
//                 title: const Text(
//                   '1625 Main Street',
//                   style: TextStyle(fontWeight: FontWeight.w500),
//                 ),
//                 subtitle: const Text('My City, CA 99984'),
//                 leading: Icon(
//                   Icons.restaurant_menu,
//                   color: Colors.blue[500],
//                 ),
//               ),
//               const Divider(),
//               ListTile(
//                 title: const Text(
//                   '(408) 555-1212',
//                   style: TextStyle(fontWeight: FontWeight.w500),
//                 ),
//                 leading: Icon(
//                   Icons.contact_phone,
//                   color: Colors.blue[500],
//                 ),
//               ),
//               ListTile(
//                 title: const Text('costa@example.com'),
//                 leading: Icon(
//                   Icons.contact_mail,
//                   color: Colors.blue[500],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//     Widget titleSection = Container(
//       padding: const EdgeInsets.all(32),
//       color: Colors.deepOrange,
//       child: Row(
//         children: [
//           Expanded(child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: const Text('NAMA KAMU',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Text(
//                 'SBY,INDO',
//                 style: TextStyle(
//                   color: Colors.blueAccent,
//                 ),
//               )
//             ],
//           ),
//           ),
//           Icon(
//             Icons.star,
//             color: Colors.black,
//           ),
//           const Text('411')
//         ],
//       ),
//     );
//     Color color = Theme.of(context).primaryColor;
//     Widget buttonSection = Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _bikinTombol(color, Icons.call,'PANGGIL'),
//         _bikinTombol(color, Icons.map, 'PETA'),
//         _bikinTombol(color, Icons.share, 'BAGIKAN'),
//       ],
//     );
//
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: ListView(
//         children: [
//           Image.asset(
//             'images/f.jpeg',
//             width: 600,
//             height: 400,
//             fit: BoxFit.cover,
//           ),
//           titleSection,
//           _buildCard(),
//           Container(
//             margin: EdgeInsets.only(top: 20),
//             child: buttonSection,
//           )
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
//
//   Column _bikinTombol(Color color, IconData icon, String judul) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(icon, color: color),
//         Container(
//           margin: const EdgeInsets.only(top: 8),
//           child: Text(
//               judul
//           ),
//         )
//       ],
//     );
//   }
// }