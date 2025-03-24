import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/widgets.dart';

class NewsDetailScreen extends StatelessWidget {
  final Map<String, dynamic> news;

  const NewsDetailScreen({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildText(news['title'], 24, FontWeight.w500),
              const SizedBox(height: 10),
              _buildText(news['short_summary'], 15, FontWeight.normal),
              const SizedBox(height: 10),
              _buildLocation(news['location']),
              _buildImageWithCaption(news['articles']?[0]['image'],
                  news['articles']?[0]['image_caption']),
              const SizedBox(height: 20),
              _buildQuote(news['quote'], news['quote_author']),
              _buildTalking('Talking Points', news['talking_points']),
              _buildPerspectives(news['perspectives']),
              _buildTimeline('Timeline', news['timeline']),
              _buildSection('Did you know', news['did_you_know']),
              _buildRelatedArticles(news['articles']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(String? text, double size, FontWeight weight) {
    return Text(
      text ?? 'No data available',
      style: TextStyle(fontSize: size, fontWeight: weight),
    );
  }

  Widget _buildTimeline(String title, dynamic content) {
    if (content == null || (content is List && content.isEmpty))
      return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildText(title, 20, FontWeight.bold), // Larger Title Font
        const SizedBox(height: 10),
        if (content is List)
          Column(
            children: List.generate(content.length, (index) {
              List<String> parts = content[index].split(":: ");
              String date = parts.length > 1 ? parts[0] : "";
              String event = parts.length > 1 ? parts[1] : parts[0];

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Numbered Circle with Space
                  Column(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (index != content.length - 1)
                        Container(
                          margin: const EdgeInsets.only(
                              top: 5), // Space between number and line
                          width: 3, // Vertical Line Thickness
                          height: 40, // Line Length
                          color: Colors.blue, // Blue Vertical Line
                        ),
                    ],
                  ),
                  const SizedBox(
                      width: 16), // More space between number and content
                  // Timeline Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (date.isNotEmpty)
                          Text(
                            date,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 18, // Increased Font Size
                            ),
                          ),
                        const SizedBox(
                            height: 4), // Space between date and event
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 10),
                          child: Text(
                            event,
                            // Justified Event Text
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          )
        else
          Text(content),
      ],
    );
  }

  Widget _buildTalking(String title, dynamic content) {
    if (content == null || (content is List && content.isEmpty))
      return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildText(title, 20, FontWeight.bold), // Increased Title Font Size
        const SizedBox(height: 15),
        if (content is List)
          Column(
            children: List.generate(content.length, (index) {
              List<String> parts = content[index].split(": ");
              String heading = parts.length > 1 ? parts[0] : "";
              String description = parts.length > 1 ? parts[1] : parts[0];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Circular Number Container
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 240, 175, 77),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (heading.isNotEmpty)
                              Text(
                                heading,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18, // Increased Font Size
                                ),
                              ),
                            Text(description),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  if (index != content.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,
                      ),
                    ),
                ],
              );
            }),
          )
        else
          Text(content),
      ],
    );
  }

  Widget _buildSection(String title, dynamic content) {
    if (content == null || (content is List && content.isEmpty)) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.lightBlue[50],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildText(title, 18, FontWeight.bold),
              const SizedBox(height: 10),
              if (content is List)
                ...content.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text('• $item'),
                    ))
              else
                Text(content.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuote(String? quote, String? author) {
    if (quote == null) return Container();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.lightBlue[50],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            '“$quote”\n\n- ${author ?? 'Unknown'}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildPerspectives(List<dynamic>? perspectives) {
    if (perspectives == null || perspectives.isEmpty) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildText('Perspectives', 18, FontWeight.bold),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 15, 5),
            child: Row(
              children: perspectives.map((perspective) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(12),
                  width: 250,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildText(
                        perspective['text'],
                        16,
                        FontWeight.normal,
                      ),
                      const SizedBox(height: 8),
                      if (perspective['sources'] != null)
                        ...perspective['sources'].map<Widget>((source) {
                          return _buildLink(source['name'], source['url']);
                        }).toList(),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageWithCaption(String? imageUrl, String? caption) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return SizedBox.shrink();
    }

    try {
      Uri uri = Uri.parse(imageUrl);
      if (!uri.hasScheme) {
        return SizedBox.shrink();
      }
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          if (caption != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                caption,
                style:
                    const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      );
    } catch (e) {
      return SizedBox.shrink();
    }
  }

  Widget _buildLocation(String? location) {
    if (location == null || location.isEmpty) return Container();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: Colors.black,
          ),
          const SizedBox(width: 5),
          Text(
            location,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedArticles(List<dynamic>? articles) {
    if (articles == null || articles.isEmpty) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        _buildText('Related Articles', 18, FontWeight.bold),
        ...articles.map(
          (article) {
            final imageUrl = article['image'] as String?;
            final title = article['title'] as String?;
            final link = article['link'] as String?;

            if (title == null || link == null) {
              return SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageWithCaption(imageUrl, article['image_caption']),
                _buildLink(title, link),
              ],
            );
          },
        ).toList(),
      ],
    );
  }

  Widget _buildLink(String text, String url) {
    final Uri uri = Uri.parse(url);

    return GestureDetector(
      onTap: () async {
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          throw 'Could not launch $url';
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.blue,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
