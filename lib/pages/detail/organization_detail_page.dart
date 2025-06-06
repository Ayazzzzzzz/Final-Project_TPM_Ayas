// lib/pages/detail/organization_detail_page.dart

import 'package:flutter/material.dart';
import 'package:ta_mobile_ayas/models/organization_model.dart';

class OrganizationDetailPage extends StatelessWidget {
  final Organization organization;

  const OrganizationDetailPage({super.key, required this.organization});

  // Helper widget (bisa dipindahkan ke file terpisah)
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
            children: items.map((item) {
              // Cek apakah item adalah URL, jika ya, tampilkan bagian terakhir (ID)
              String displayItem = item;
              if (item.startsWith('http')) {
                displayItem = "ID: ${item.split('/').last}";
              }
              return Chip(
                label: Text(displayItem),
                backgroundColor: theme.colorScheme.secondaryContainer,
                labelStyle: TextStyle(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w500),
              );
            }).toList(),
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
      body: CustomScrollView(
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
                organization.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  shadows: [
                    Shadow(
                        blurRadius: 2.0, color: Colors.black.withOpacity(0.5))
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'organization-${organization.id}', // Tag unik
                    child: Image.network(
                      organization.displayImage,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.4),
                      colorBlendMode: BlendMode.darken,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.network(
                        'https://picsum.photos/seed/org_${organization.id}/400/600',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.corporate_fare_outlined,
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
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(
                          context, Icons.info_outline, "Organization Details"),
                      _buildInfoCard(children: [
                        _buildInfoRow(context, Icons.flag_outlined,
                            "Affiliation", organization.affiliation),
                        _buildInfoRow(
                            context,
                            Icons.movie_creation_outlined,
                            "Debut Episode",
                            organization.debut
                                ?.split('/')
                                .last), // Menampilkan ID episode
                      ]),
                      if (organization.occupations.isNotEmpty)
                        _buildSectionTitle(context, Icons.work_history_outlined,
                            "Occupations"),
                      if (organization.occupations.isNotEmpty)
                        _buildInfoCard(children: [
                          _buildChipList(context, Icons.label_outline,
                              "Known Occupations", organization.occupations),
                        ]),
                      if (organization.notableMembers.isNotEmpty)
                        _buildSectionTitle(context, Icons.groups_2_outlined,
                            "Notable Members"),
                      if (organization.notableMembers.isNotEmpty)
                        _buildInfoCard(children: [
                          _buildChipList(context, Icons.person_pin_outlined,
                              "Current Members", organization.notableMembers),
                        ]),
                      if (organization.notableFormerMembers.isNotEmpty)
                        _buildSectionTitle(
                            context,
                            Icons.history_toggle_off_outlined,
                            "Former Members"),
                      if (organization.notableFormerMembers.isNotEmpty)
                        _buildInfoCard(children: [
                          _buildChipList(
                              context,
                              Icons.person_off_outlined,
                              "Past Members",
                              organization.notableFormerMembers),
                        ]),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
