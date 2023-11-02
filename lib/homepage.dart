// import 'package:flutter/material.dart';

// import 'flipcardgame.dart';
// import 'data.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListView.builder(
//           itemCount: _list.length,
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (BuildContext context) => _list[index].goto,
//                     ));
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Stack(
//                   children: [
//                     Container(
//                       height: 100,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                           color: _list[index].primarycolor,
//                           borderRadius: BorderRadius.circular(30),
//                           boxShadow: const [
//                             BoxShadow(
//                                 blurRadius: 4,
//                                 color: Colors.black45,
//                                 spreadRadius: 0.5,
//                                 offset: Offset(3, 4))
//                           ]),
//                     ),
//                     Container(
//                       height: 90,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                           color: _list[index].secomdarycolor,
//                           borderRadius: BorderRadius.circular(30),
//                           boxShadow: const [
//                             BoxShadow(
//                                 blurRadius: 4,
//                                 color: Colors.black12,
//                                 spreadRadius: 0.3,
//                                 offset: Offset(
//                                   5,
//                                   3,
//                                 ))
//                           ]),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Center(
//                               child: Text(
//                             _list[index].name,
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 30,
//                                 fontWeight: FontWeight.bold,
//                                 shadows: [
//                                   Shadow(
//                                     color: Colors.black26,
//                                     blurRadius: 2,
//                                     offset: Offset(1, 2),
//                                   ),
//                                   Shadow(
//                                       color: Colors.green,
//                                       blurRadius: 2,
//                                       offset: Offset(0.5, 2))
//                                 ]),
//                           )),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: genratestar(_list[index].noOfstar),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   List<Widget> genratestar(int no) {
//     List<Widget> icons = [];
//     for (int i = 0; i < no; i++) {
//       icons.insert(
//           i,
//           const Icon(
//             Icons.star,
//             color: Colors.yellow,
//           ));
//     }
//     return icons;
//   }
// }

// class Details {
//   final String name;
//   final Color primarycolor;
//   final Color secomdarycolor;
//   final Widget goto;
//   final int noOfstar;

//   Details(
//       {required this.name,
//       required this.primarycolor,
//       required this.secomdarycolor,
//       required this.noOfstar,
//       required this.goto});
// }

// List<Details> _list = [
//   Details(
//       name: "EASY",
//       primarycolor: Colors.green,
//       secomdarycolor: Colors.green[300]!,
//       noOfstar: 1,
//       goto: FlipCardGane(Level.Easy)),
//   Details(
//       name: "MEDIUM",
//       primarycolor: Colors.orange,
//       secomdarycolor: Colors.orange[300]!,
//       noOfstar: 2,
//       goto: FlipCardGane(Level.Medium)),
//   Details(
//       name: "HARD",
//       primarycolor: Colors.red,
//       secomdarycolor: Colors.red[300]!,
//       noOfstar: 3,
//       goto: FlipCardGane(Level.Hard))
// ];
