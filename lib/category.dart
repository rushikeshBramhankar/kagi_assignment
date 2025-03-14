import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kagi_assignment/news_details.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, String>> categories = [];
  String selectedCategory = 'World';
  List<dynamic> newsList = [];
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchNews('world.json');

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0.2, -0.2),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchCategories() async {
    final response =
        await http.get(Uri.parse('https://kite.kagi.com/kite.json'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('categories')) {
        setState(() {
          categories = List<Map<String, String>>.from(
            data['categories'].map(
              (cat) => {
                "name": cat["name"]?.toString() ?? '',
                "file": cat["file"]?.toString() ?? '',
              },
            ),
          );
        });
      }
    } else {
      print(
          "Error: Failed to fetch categories, Status Code: ${response.statusCode}");
    }
  }

  Future<void> fetchNews(String file) async {
    final response = await http.get(Uri.parse('https://kite.kagi.com/$file'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        newsList = data['clusters'] ?? [];
      });
    } else {
      print("Error: Failed to fetch news, Status Code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            SlideTransition(
              position: _animation,
              child: Container(
                height: 40,
                width: 50,
                child: SvgPicture.network(
                    'https://kite.kagi.com/static/svg/kite.svg'),
              ),
            ),
            SizedBox(width: 10),
            Text('Kite News', style: TextStyle(color: Colors.black)),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Category Section
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final isSelected = selectedCategory == category['name'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category['name']!;
                    });
                    fetchNews(category['file']!);
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: Text(
                      category['name'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          Divider(
            color: Colors.grey[200],
            indent: 8,
            endIndent: 8,
          ),

          // News List Section
          Expanded(
            child: newsList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      var news = newsList[index];
                      return Card(
                        color: Colors.white,
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(news['title'],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              news['short_summary'] ?? "No summary available"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewsDetailScreen(news: news),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
