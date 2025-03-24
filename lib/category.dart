import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kagi_assignment/news_details.dart';
import 'package:kagi_assignment/onthisday.dart';

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
          print('Loaded categories: $categories');
        });
      }
    } else {
      print(
          "Error: Failed to fetch categories, Status Code: ${response.statusCode}");
    }
  }

  Future<void> fetchNews(String file) async {
    setState(() {
      newsList = [];
    });

    final response = await http.get(Uri.parse('https://kite.kagi.com/$file'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        if (file == 'onthisday.json') {
          newsList = data['events'] ?? [];
          print("Loaded ${newsList.length} On This Day events");
        } else {
          newsList = data['clusters'] ?? [];
          print("Loaded ${newsList.length} news clusters");
        }
      });
    } else {
      print("Error: Failed to fetch news, Status Code: ${response.statusCode}");
    }
  }

  String _stripHtml(String htmlString) {
    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"');
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
            Text(
              'Kite News',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 0, 5, 0),
              child: Row(
                children: categories.map((category) {
                  final isSelected = selectedCategory == category['name'];
                  return GestureDetector(
                    onTap: () {
                      print('Selected category: ${category['name']}');
                      setState(() {
                        selectedCategory = category['name']!;
                      });
                      fetchNews(category['file']!);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
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
          ),
          Divider(
            color: Colors.grey[200],
            indent: 8,
            endIndent: 8,
          ),
          Expanded(
            child: newsList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      var news = newsList[index];
                      bool isOnThisDay =
                          selectedCategory.replaceAll(' ', '').toLowerCase() ==
                              'onthisday';
                      print('Building item $index - isOnThisDay: $isOnThisDay');
                      print('News data: $news');

                      String title = isOnThisDay
                          ? 'On This Day in ${news['year'] ?? "History"}'
                          : news['title'] ?? "No Title";

                      String summary = isOnThisDay
                          ? _stripHtml(news['content'] ?? 'Historical event')
                          : news['short_summary'] ?? "No summary available";

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            if (isOnThisDay) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OnThisDayScreen(event: news),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewsDetailScreen(news: news),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  summary,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
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
