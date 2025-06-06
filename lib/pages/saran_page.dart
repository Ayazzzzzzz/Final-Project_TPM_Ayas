// lib/pages/saran_page.dart

import 'package:flutter/material.dart';

class SaranPage extends StatelessWidget {
  const SaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Helper widget untuk membuat baris info (agar tidak berulang)
    Widget _buildInfoRow(IconData icon, String title, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.secondary),
            const SizedBox(width: 16),
            Text('$title:', style: TextStyle(color: Colors.grey[400])),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    // Helper widget untuk poin feedback
    Widget _buildFeedbackPoint(String text) {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle_outline,
                size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BAGIAN 1: INFORMASI MATA KULIAH ---
            SizedBox(
              height: 24,
            ),
            Text(
              "Detail Evaluasi",
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.class_outlined, "Mata Kuliah",
                        "Teknologi & Pemrograman Mobile"),
                    _buildInfoRow(
                        Icons.qr_code_scanner_outlined, "Kode MK", "IF-404"),
                    _buildInfoRow(
                        Icons.person_pin_outlined, "Dosen", "Tim Dosen Mobile"),
                    _buildInfoRow(Icons.calendar_today_outlined, "Semester",
                        "Genap 2024/2025"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- BAGIAN 2: PENILAIAN & KESAN POSITIF ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.thumb_up_alt_outlined,
                            color: theme.colorScheme.primary, size: 24),
                        const SizedBox(width: 12),
                        Text("Kesan Positif",
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildFeedbackPoint(
                        "Materi relevan dengan industri (Flutter)."),
                    _buildFeedbackPoint(
                        "Memberikan wawasan mendalam tentang state management."),
                    _buildFeedbackPoint(
                        "Studi kasus yang menarik dan menantang."),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Penilaian Keseluruhan:",
                            style: theme.textTheme.bodyLarge),
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              color: index < 4
                                  ? theme.colorScheme.secondary
                                  : Colors.grey[700],
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- BAGIAN 3: SARAN UNTUK PERBAIKAN ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline,
                            color: theme.colorScheme.secondary, size: 24),
                        const SizedBox(width: 12),
                        Text("Saran untuk Perbaikan",
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildFeedbackPoint(
                        "Tambahkan sesi workshop atau live coding untuk studi kasus end-to-end."),
                    _buildFeedbackPoint(
                        "Perbanyak contoh implementasi pada arsitektur yang berbeda (e.g., BLoC vs Riverpod)."),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
