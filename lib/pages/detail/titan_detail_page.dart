import 'package:flutter/material.dart';
import 'package:ta_mobile_ayas/models/titan_model.dart';
import 'package:ta_mobile_ayas/services/api_service.dart';

class TitanDetailPage extends StatefulWidget {
  final Titan titan;

  const TitanDetailPage({super.key, required this.titan});

  @override
  State<TitanDetailPage> createState() => _TitanDetailPageState();
}

class _TitanDetailPageState extends State<TitanDetailPage> {
  final ApiService _apiService = ApiService();
  late Future<Titan> _titanDetailFuture;

  @override
  void initState() {
    super.initState();
    _titanDetailFuture = _apiService.getTitanById(widget.titan.id);
  }

  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String? value) {
    final theme = Theme.of(context);
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.secondary),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(value,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildChipList(
      BuildContext context, IconData icon, String label, List<String> items) {
    final theme = Theme.of(context);
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, IconData icon, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 10),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
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
      body: FutureBuilder<Titan>(
        future: _titanDetailFuture,
        builder: (context, snapshot) {
          final titanData = snapshot.hasData ? snapshot.data! : widget.titan;

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
                    titanData.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
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
                        tag: 'titan-${titanData.id}', // Tag unik untuk Titan
                        child: Image.network(
                          titanData.displayImage,
                          fit: BoxFit.cover,
                          color: Colors.black.withOpacity(0.4),
                          colorBlendMode: BlendMode.darken,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.network(
                            'https://picsum.photos/seed/titan_${titanData.id}/400/600',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.shield_moon_outlined,
                                    size: 150, color: Colors.grey),
                          ),
                        ),
                      ),
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
                              child: Text("Error: ${snapshot.error}",
                                  textAlign: TextAlign.center)))
                      : SliverList(
                          delegate: SliverChildListDelegate([
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionTitle(context,
                                      Icons.info_outline, "Titan Details"),
                                  _buildInfoCard(children: [
                                    _buildInfoRow(context, Icons.height,
                                        "Height", titanData.height),
                                    _buildInfoRow(
                                        context,
                                        Icons.shield_outlined,
                                        "Allegiance",
                                        titanData.allegiance is List
                                            ? (titanData.allegiance as List)
                                                .join(', ')
                                            : titanData.allegiance?.toString()),
                                  ]),
                                  if (titanData.abilities.isNotEmpty)
                                    _buildSectionTitle(context,
                                        Icons.flash_on_outlined, "Abilities"),
                                  if (titanData.abilities.isNotEmpty)
                                    _buildInfoCard(children: [
                                      _buildChipList(
                                          context,
                                          Icons.star_outline,
                                          "Known Abilities",
                                          titanData.abilities),
                                    ]),
                                  _buildSectionTitle(
                                      context,
                                      Icons.person_pin_circle_outlined,
                                      "Inheritors"),
                                  _buildInfoCard(children: [
                                    _buildInfoRow(
                                        context,
                                        Icons.person_outline,
                                        "Current",
                                        titanData.currentInheritor
                                            ?.split('/')
                                            .last), // Menampilkan ID karakter
                                    if (titanData.formerInheritors.isNotEmpty)
                                      _buildChipList(
                                          context,
                                          Icons.history_edu_outlined,
                                          "Former",
                                          titanData.formerInheritors
                                              .map((url) =>
                                                  "ID: ${url.split('/').last}")
                                              .toList()),
                                  ]),
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
