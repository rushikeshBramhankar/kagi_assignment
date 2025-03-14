// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:kagi_assignment/news_details.dart';

// class NewsListScreen extends StatefulWidget {
//   final String file;
//   NewsListScreen({required this.file});

//   @override
//   _NewsListScreenState createState() => _NewsListScreenState();
// }

// class _NewsListScreenState extends State<NewsListScreen> {
//   List<dynamic> newsList = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchNews();
//   }

//   Future<void> fetchNews() async {
//     final response =
//         await http.get(Uri.parse('https://kite.kagi.com/${widget.file}'));

//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = json.decode(response.body);
//       setState(() {
//         newsList = data['clusters'] ?? [];
//       });
//     } else {
//       print("Error: Failed to fetch news, Status Code: ${response.statusCode}");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.file.replaceAll('.json', ''))),
//       body: newsList.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: newsList.length,
//               itemBuilder: (context, index) {
//                 var news = newsList[index];
//                 return Card(
//                   margin: EdgeInsets.all(10),
//                   child: ListTile(
//                     title: Text(news['title'],
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold)),
//                     subtitle:
//                         Text(news['short_summary'] ?? "No summary available"),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => NewsDetailScreen(news: news),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
