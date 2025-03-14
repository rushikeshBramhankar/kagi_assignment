import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatelessWidget {
  final Map<String, dynamic> news;

  const NewsDetailScreen({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news['title'] ?? 'News Details'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(news['articles'][0]['image']),
            const SizedBox(height: 10),
            Text(
              news['title'] ?? 'No title',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              news['short_summary'] ?? 'No summary available',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildSection('Did you know', news['did_you_know']),
            _buildQuote(news['quote'], news['quote_author']),
            _buildSection('Talking Points', news['talking_points']),
            _buildPerspectives(news['perspectives']),
            _buildSection('Timeline', news['timeline']),
            _buildSection('User Action Items', news['user_action_items']),
            _buildSection(
                'Scientific Significance', news['scientific_significance']),
            _buildRelatedArticles(news['articles']),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    return imageUrl != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl, fit: BoxFit.cover),
          )
        : const Placeholder(fallbackHeight: 200);
  }

  Widget _buildSection(String title, dynamic content) {
    if (content == null || (content is List && content.isEmpty))
      return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
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

  Widget _buildQuote(String? quote, String? author) {
    if (quote == null) return Container();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        '“$quote”\n\n- ${author ?? 'Unknown'}',
        style: const TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _buildPerspectives(List<dynamic>? perspectives) {
    if (perspectives == null || perspectives.isEmpty) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('Perspectives',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...perspectives.map((perspective) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(perspective['text'] ?? ''),
                ...?perspective['sources']?.map<Widget>(
                    (source) => _buildLink(source['name'], source['url'])),
              ],
            )),
      ],
    );
  }

  Widget _buildRelatedArticles(List<dynamic>? articles) {
    if (articles == null || articles.isEmpty) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text('Related Articles',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...articles
            .map((article) => _buildLink(article['title'], article['link'])),
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
