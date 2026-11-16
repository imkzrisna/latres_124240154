import 'package:flutter/material.dart';
import 'package:latres_mobile/pages/detail_page.dart';
import 'package:latres_mobile/services/favorite_service.dart';
import 'package:latres_mobile/utils/constants.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Favorit'),
        backgroundColor: Colors.black,
      ),
      body: ValueListenableBuilder(
        valueListenable: FavoriteService.listenable(),
        builder: (context, _, _) {
          final favs = FavoriteService.getAll();
          if (favs.isEmpty) {
            return const Center(child: Text('Belum ada favorit'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: favs.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final s = favs[i];
              final img = (s['image'] ?? '') as String;
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(id: s['id'] as int),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppConst.card,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: img.isEmpty
                            ? const SizedBox(
                                width: 50,
                                height: 70,
                                child: Icon(Icons.movie))
                            : Image.network(img,
                                width: 50,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, st) => const SizedBox(
                                    width: 50,
                                    height: 70,
                                    child: Icon(Icons.broken_image))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s['name'] ?? '-',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 14, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text('${s['rating']}',
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: AppConst.primary),
                        onPressed: () =>
                            FavoriteService.remove(s['id'] as int),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
