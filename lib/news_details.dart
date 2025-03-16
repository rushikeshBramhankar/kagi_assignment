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
        _buildText(title, 18, FontWeight.bold),
        if (content is List)
          ...content.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('• $item'),
              ))
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
        _buildText(title, 18, FontWeight.bold),
        if (content is List)
          ...content.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('• $item'),
              ))
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
        ...perspectives.map((perspective) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildText(perspective['text'], 16, FontWeight.normal),
                ...?perspective['sources']?.map<Widget>(
                    (source) => _buildLink(source['name'], source['url'])),
              ],
            ))
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
            borderRadius: BorderRadius.circular(25),
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
          ),
          const SizedBox(width: 5),
          Text(location,
              style:
                  const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
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
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
