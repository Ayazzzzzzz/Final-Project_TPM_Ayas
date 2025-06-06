// lib/pages/detail/character_detail_page.dart

import 'package:flutter/material.dart';
import 'package:ta_mobile_ayas/data/character_quotes.dart';
import 'package:ta_mobile_ayas/models/character_model.dart';
import 'package:ta_mobile_ayas/services/api_service.dart'; // <-- IMPORT DATA KUTIPAN
import '../../utils/notification_helper.dart';

class CharacterDetailPage extends StatefulWidget {
  final Character character;

  const CharacterDetailPage({super.key, required this.character});

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  final ApiService _apiService = ApiService();
  late Future<Character> _characterDetailFuture;
  bool _notificationShownForThisInstance =
      false; // Flag untuk instance halaman ini

  @override
  void initState() {
    super.initState();
    _characterDetailFuture = _apiService.getCharacterById(widget.character.id);

    _characterDetailFuture.then((detailedCharacter) {
      if (mounted && !_notificationShownForThisInstance) {
        _triggerQuoteNotification(detailedCharacter);
        _notificationShownForThisInstance = true;
      }
    }).catchError((error) {
      debugPrint(
          "Detail Page: Failed to load character details for notification: $error");
    });
  }

  void _triggerQuoteNotification(Character character) async {
    String quote = getQuoteByCharacterName(character.name);

    // Beri jeda agar tidak terlalu instan
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      await NotificationHelper.showCharacterQuoteNotification(
          character.name, quote);
      debugPrint(
          "Notification for ${character.name} triggered with quote: $quote");
    }
  }

  // Helper: Judul Seksi dengan Ikon
  Widget _buildSectionTitle(BuildContext context, IconData icon, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 10),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Baris Info (Label: Nilai)
  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String? value) {
    final theme = Theme.of(context);
    if (value == null || value.isEmpty || value.toLowerCase() == 'n/a')
      return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.secondary),
          const SizedBox(width: 12),
          SizedBox(
            width: 100, // Lebar tetap untuk label agar rapi
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Daftar sebagai Chip
  Widget _buildChipList(
      BuildContext context, IconData icon, String label, List<String> items) {
    final theme = Theme.of(context);
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.secondary),
              const SizedBox(width: 12),
              Text(
                '$label:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 6.0,
            children: items
                .map((item) => Chip(
                      label: Text(item),
                      backgroundColor: theme.colorScheme.secondaryContainer,
                      labelStyle: TextStyle(
                          color: theme.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w500),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  // Helper: Kartu Informasi
  Widget _buildInfoCard({required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder<Character>(
        future: _characterDetailFuture,
        builder: (context, snapshot) {
          final characterData =
              snapshot.hasData ? snapshot.data! : widget.character;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 350.0,
                pinned: true,
                stretch: true,
                backgroundColor: theme.colorScheme.surface,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: Text(
                    characterData.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme
                          .onSurface, // Agar kontras dengan gradient
                      shadows: [
                        Shadow(
                            blurRadius: 2.0,
                            color: Colors.black.withOpacity(0.5))
                      ],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'character-${characterData.id}',
                        child: Image.network(
                          characterData.displayImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.network(
                            'https://picsum.photos/seed/${characterData.id}/400/600',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image_rounded,
                                    size: 150, color: Colors.grey),
                          ),
                        ),
                      ),
                      // Gradient overlay untuk keterbacaan teks judul
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.2),
                              Colors.black.withOpacity(0.8),
                            ],
                            stops: const [0.5, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData
                  ? const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()))
                  : snapshot.hasError
                      ? SliverFillRemaining(
                          child: Center(
                              child: Text(
                          "Error: ${snapshot.error}",
                          textAlign: TextAlign.center,
                        )))
                      : SliverList(
                          delegate: SliverChildListDelegate([
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionTitle(
                                      context, Icons.badge_outlined, "Profile"),
                                  _buildInfoCard(
                                    children: [
                                      _buildInfoRow(
                                          context,
                                          Icons.person_outline,
                                          "Gender",
                                          characterData.gender),
                                      _buildInfoRow(
                                          context,
                                          Icons.cake_outlined,
                                          "Age",
                                          characterData.age?.toString()),
                                      _buildInfoRow(
                                          context,
                                          Icons.height_outlined,
                                          "Height",
                                          characterData.height),
                                      _buildInfoRow(
                                          context,
                                          Icons.healing_outlined,
                                          "Status",
                                          characterData.status),
                                      _buildInfoRow(
                                          context,
                                          Icons.work_outline,
                                          "Occupation",
                                          characterData.occupation),
                                      _buildChipList(
                                          context,
                                          Icons.biotech_outlined,
                                          "Species",
                                          characterData.species),
                                    ],
                                  ),
                                  _buildSectionTitle(
                                      context, Icons.map_outlined, "Origins"),
                                  _buildInfoCard(
                                    children: [
                                      _buildInfoRow(
                                          context,
                                          Icons.public_outlined,
                                          "Birthplace",
                                          characterData.birthplace),
                                      _buildInfoRow(
                                          context,
                                          Icons.home_work_outlined,
                                          "Residence",
                                          characterData.residence),
                                    ],
                                  ),
                                  if (characterData.alias.isNotEmpty) ...[
                                    _buildSectionTitle(
                                        context,
                                        Icons.theater_comedy_outlined,
                                        "Aliases"),
                                    _buildInfoCard(children: [
                                      _buildChipList(
                                          context,
                                          Icons.label_important_outline,
                                          "Known as",
                                          characterData.alias)
                                    ]),
                                  ],
                                  if (characterData.roles.isNotEmpty) ...[
                                    _buildSectionTitle(context,
                                        Icons.star_outline_rounded, "Roles"),
                                    _buildInfoCard(children: [
                                      _buildChipList(
                                          context,
                                          Icons.verified_user_outlined,
                                          "Key Roles",
                                          characterData.roles)
                                    ]),
                                  ],
                                  if (characterData.relatives.isNotEmpty) ...[
                                    _buildSectionTitle(
                                        context,
                                        Icons.family_restroom_outlined,
                                        "Family Relations"),
                                    ...characterData.relatives
                                        .map((relativeGroup) =>
                                            _buildInfoCard(children: [
                                              Text(relativeGroup.family,
                                                  style: theme
                                                      .textTheme.titleMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                              const SizedBox(height: 4),
                                              Text(relativeGroup.members
                                                  .join(', ')),
                                            ]))
                                        .toList()
                                  ],
                                  if (characterData.groups.isNotEmpty) ...[
                                    _buildSectionTitle(
                                        context,
                                        Icons.group_work_outlined,
                                        "Affiliations"),
                                    ...characterData.groups
                                        .map((groupAff) => Card(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6.0),
                                              child: ExpansionTile(
                                                leading: Icon(
                                                    Icons.shield_outlined,
                                                    color: theme
                                                        .colorScheme.secondary),
                                                title: Text(groupAff.name,
                                                    style: theme
                                                        .textTheme.titleMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                backgroundColor: theme
                                                    .colorScheme.surfaceVariant
                                                    .withOpacity(0.3),
                                                collapsedBackgroundColor: theme
                                                    .colorScheme.surfaceVariant
                                                    .withOpacity(0.3),
                                                childrenPadding:
                                                    const EdgeInsets.only(
                                                        left: 16,
                                                        right: 16,
                                                        bottom: 8),
                                                children:
                                                    groupAff.subGroups
                                                            .isNotEmpty
                                                        ? groupAff.subGroups
                                                            .map(
                                                                (subGroup) =>
                                                                    ListTile(
                                                                      title: Text(
                                                                          subGroup,
                                                                          style: theme
                                                                              .textTheme
                                                                              .bodyMedium),
                                                                      leading: const SizedBox(
                                                                          width:
                                                                              16,
                                                                          child: Icon(
                                                                              Icons.subdirectory_arrow_right,
                                                                              size: 18)),
                                                                      dense:
                                                                          true,
                                                                    ))
                                                            .toList()
                                                        : [
                                                            const ListTile(
                                                                title: Text(
                                                                    "No sub-groups",
                                                                    style: TextStyle(
                                                                        fontStyle:
                                                                            FontStyle.italic)))
                                                          ],
                                              ),
                                            ))
                                        .toList()
                                  ],
                                  if (characterData.episodes.isNotEmpty) ...[
                                    _buildSectionTitle(context,
                                        Icons.tv_outlined, "Appearances"),
                                    _buildInfoCard(children: [
                                      _buildInfoRow(
                                          context,
                                          Icons.play_circle_outline,
                                          "Appears In",
                                          "${characterData.episodes.length} episodes (data from API)")
                                    ]),
                                  ]
                                ],
                              ),
                            )
                          ]),
                        ),
            ],
          );
        },
      ),
    );
  }
}
