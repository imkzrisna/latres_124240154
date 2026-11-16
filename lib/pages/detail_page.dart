import 'package:flutter/material.dart';
import 'package:latres_mobile/services/favorite_service.dart';
import 'package:latres_mobile/services/tvmaze_service.dart';
import 'package:latres_mobile/utils/constants.dart';

class DetailPage extends StatefulWidget {
  final int id;
  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = TvmazeService.fetchDetail(widget.id);
  }

  String _stripHtml(String? html) {
    if (html == null || html.isEmpty) return 'Tidak ada ringkasan.';
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppConst.primary));
          }
          if (snap.hasError) {
            return Center(child: Text('${snap.error}'));
          }
          final show = snap.data!;
          final img = TvmazeService.imageOriginalOf(show);
          final genres = (show['genres'] as List?)?.cast<String>() ?? [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (img.isNotEmpty)
                  Image.network(
                    img,
                    width: double.infinity,
                    height: 420,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const SizedBox(
                        height: 420,
                        child: Center(child: Icon(Icons.broken_image))),
                  )
                else
                  const SizedBox(
                      height: 300, child: Center(child: Icon(Icons.movie))),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(show['name'] ?? '-',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(TvmazeService.ratingOf(show)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        genres.isEmpty ? '-' : genres.join(', '),
                        style: const TextStyle(color: Colors.white54),
                      ),
                      const SizedBox(height: 16),
                      ValueListenableBuilder(
                        valueListenable: FavoriteService.listenable(),
                        builder: (context, _, _) {
                          final fav = FavoriteService.isFavorite(widget.id);
                          return SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: fav
                                    ? AppConst.card
                                    : AppConst.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => FavoriteService.toggle(show),
                              icon: Icon(fav
                                  ? Icons.favorite
                                  : Icons.favorite_border),
                              label: Text(fav
                                  ? 'Hapus dari Favorit'
                                  : 'Tambah ke Favorit'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text('Overview',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(_stripHtml(show['summary'] as String?),
                          style: const TextStyle(
                              color: Colors.white70, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
