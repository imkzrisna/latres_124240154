import 'package:flutter/material.dart';
import 'package:latres_mobile/pages/detail_page.dart';
import 'package:latres_mobile/services/tvmaze_service.dart';
import 'package:latres_mobile/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = TvmazeService.fetchShows();
  }

  void _retry() {
    setState(() => _future = TvmazeService.fetchShows());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skuy Nonton!'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppConst.primary),
            );
          }
          if (snap.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${snap.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                      onPressed: _retry, child: const Text('Coba lagi')),
                ],
              ),
            );
          }
          final shows = snap.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.62,
            ),
            itemCount: shows.length,
            itemBuilder: (context, i) => _ShowCard(show: shows[i]),
          );
        },
      ),
    );
  }
}

class _ShowCard extends StatelessWidget {
  final Map<String, dynamic> show;
  const _ShowCard({required this.show});

  @override
  Widget build(BuildContext context) {
    final img = TvmazeService.imageOf(show);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPage(id: show['id'] as int),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: AppConst.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: img.isEmpty
                    ? const Center(child: Icon(Icons.movie, size: 40))
                    : Image.network(
                        img,
                        fit: BoxFit.cover,
                        loadingBuilder: (c, child, p) => p == null
                            ? child
                            : const Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppConst.primary)),
                        errorBuilder: (c, e, s) =>
                            const Center(child: Icon(Icons.broken_image)),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      show['name'] ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(TvmazeService.ratingOf(show),
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
