import 'package:flutter/material.dart';
import 'package:ta_mobile_ayas/models/character_model.dart';
import 'package:ta_mobile_ayas/models/organization_model.dart';
import 'package:ta_mobile_ayas/models/titan_model.dart';
import 'package:ta_mobile_ayas/pages/detail/character_detail_page.dart';
import 'package:ta_mobile_ayas/pages/detail/organization_detail_page.dart';
import 'package:ta_mobile_ayas/pages/detail/titan_detail_page.dart';

class DataGridCard extends StatelessWidget {
  final dynamic item; 

  const DataGridCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    String name = "Unknown";
    String imageUrl = "https://via.placeholder.com/200x300.png?text=No+Image";
    int id = 0;
    String heroTagPrefix = "item";

    if (item is Character) {
      name = (item as Character).name;
      if ((item as Character).img != null) {
        imageUrl = (item as Character).img!;
      } else {
        imageUrl = 'https://via.placeholder.com/350'; 
      }
      id = (item as Character).id;
      heroTagPrefix = "character";
    } else if (item is Titan) {
      name = (item as Titan).name;
      imageUrl = (item as Titan).img!;
      id = (item as Titan).id;
      heroTagPrefix = "titan";
    } else if (item is Organization) {
      name = (item as Organization).name;
      imageUrl = (item as Organization).img!;
      id = (item as Organization).id;
      heroTagPrefix = "organization";
    }

    return GestureDetector(
      onTap: () {
        if (item is Character) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CharacterDetailPage(character: item as Character),
            ),
          );
        } else if (item is Titan) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TitanDetailPage(titan: item as Titan),
            ),
          );
        } else if (item is Organization) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OrganizationDetailPage(organization: item as Organization),
            ),
          );
        }
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          child: Hero(
            tag: '$heroTagPrefix-$id',
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                // Fallback jika URL utama error, coba URL placeholder dari model
                String fallbackImageUrl =
                    'https://via.placeholder.com/200x300.png?text=Error';
                if (item is Character)
                  fallbackImageUrl = (item as Character).displayImage;
                else if (item is Titan)
                  fallbackImageUrl = (item as Titan).displayImage;
                else if (item is Organization)
                  fallbackImageUrl = (item as Organization).displayImage;

                return Image.network(
                  fallbackImageUrl, 
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => 
                          const Icon(Icons.broken_image,
                              size: 50, color: Colors.grey),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
