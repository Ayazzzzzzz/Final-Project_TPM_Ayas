// lib/pages/saran_page.dart

import 'package:flutter/material.dart';

class SaranPage extends StatelessWidget {
  const SaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget _buildInfoRow(IconData icon, String title, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.secondary),
            const SizedBox(width: 16),
            // Penyesuaian lebar agar lebih fleksibel
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
            const SizedBox(height: 24),
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
                        "Tek. & P Mobile IF-A"),
                    _buildInfoRow(
                        Icons.qr_code_scanner_outlined, "Kode MK", "123210472"),
                    _buildInfoRow(Icons.person_pin_outlined, "Dosen",
                        "Bagus M.Akbar S.ST., M.Kom."),
                    _buildInfoRow(Icons.calendar_today_outlined, "Semester",
                        "Genap 2024/2025"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

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
                        "Memberikan teori yang sangat insightful"),
                    _buildFeedbackPoint(
                        "Tugas menantang dan memberi banyak pelajaran baru"),
                    _buildFeedbackPoint(
                        "Selalu mengabari ketika kelas ditiadakan serta mulai dan selesai tepat waktu"),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Penilaian Keseluruhan:",
                            style: theme.textTheme.bodyLarge),
                        // Representasi 4.5 Bintang
                        Row(
                          children: [
                            Icon(Icons.star,
                                color: theme.colorScheme.secondary),
                            Icon(Icons.star,
                                color: theme.colorScheme.secondary),
                            Icon(Icons.star,
                                color: theme.colorScheme.secondary),
                            Icon(Icons.star,
                                color: theme.colorScheme.secondary),
                            Icon(Icons.star_half,
                                color: theme.colorScheme.secondary),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

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
                        "Sesi live coding dengan bimbingan langsung akan sangat meningkatkan kemampuan mahasiswa"),
                    _buildFeedbackPoint(
                        "Memberi lebih banyak contoh program untuk melengkapi teori"),
                    _buildFeedbackPoint(
                        "Memberi tema berbeda-beda untuk tugas akhir di setiap kelas agar tidak terjadi overlap tema yang serupa"),
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
