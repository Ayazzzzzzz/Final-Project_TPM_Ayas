import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ta_mobile_ayas/data/aot_event.dart';
import 'package:ta_mobile_ayas/models/event_item_model.dart';
import 'package:ta_mobile_ayas/pages/event_map_page.dart';
import 'package:timezone/timezone.dart' as tz;

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<EventItem> _events = [];

  String _selectedTargetTimeZoneKey = 'WIB';

  final Map<String, String> _targetTimeZones = {
    'WIB': 'Asia/Jakarta',
    'WITA': 'Asia/Makassar', 
    'WIT': 'Asia/Jayapura', 
    'Jepang': 'Asia/Tokyo',
    'London':
        'Europe/London', 
    'Local': 'Local', 
  };

  @override
  void initState() {
    super.initState();
    _events = getDummyAotEvents();
    _events.sort((a, b) => a.eventTimeUtc.compareTo(b.eventTimeUtc));
  }

  String _formatDateTime(DateTime utcTime, String timeZoneKeyName) {
    try {
      String timeZoneIdentifier;
      if (timeZoneKeyName == 'Local') {
        // Konversi ke waktu lokal perangkat
        final localTime = utcTime.toLocal();
        return DateFormat('HH:mm, E dd MMM yyyy', 'id_ID').format(localTime) +
            " (Lokal Anda)";
      } else {
        timeZoneIdentifier = _targetTimeZones[timeZoneKeyName]!;
      }

      final location = tz.getLocation(timeZoneIdentifier);
      final zonedTime = tz.TZDateTime.from(utcTime, location);
      return DateFormat('HH:mm, E dd MMM yyyy', 'id_ID').format(zonedTime) +
          " ($timeZoneKeyName)";
    } catch (e) {
      print("Error formatting time for $timeZoneKeyName: $e");
      return DateFormat('HH:mm, dd MMM yyyy', 'id_ID')
              .format(utcTime.toLocal()) +
          " (Error - Local)";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedTargetTimeZoneKey,
              items: _targetTimeZones.keys.map((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(key,
                      style: TextStyle(
                          color: theme.colorScheme
                              .onSurface)), 
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null && mounted) {
                  setState(() {
                    _selectedTargetTimeZoneKey = newValue;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Convert Schedule To:',
                labelStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide:
                      BorderSide(color: theme.colorScheme.outline, width: 0.8),
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              dropdownColor: theme.colorScheme.surfaceVariant,
            ),
          ),
          Expanded(
            // ListView.builder harus di dalam Expanded
            child: _events.isEmpty
                ? const Center(child: Text("Tidak ada jadwal acara saat ini."))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                        12.0, 0, 12.0, 12.0), 
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (event.imageUrl != null &&
                                  event.imageUrl!.isNotEmpty)
                                ClipRRect(
                              
                                  child: Image.network(
                                    event.imageUrl!,
                                    height:
                                        180, 
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        height: 180,
                                        color: theme.colorScheme.surfaceVariant,
                                        child: Center(
                                            child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        )),
                                      );
                                    },
                                    errorBuilder: (context, error,
                                            stackTrace) =>
                                        Container(
                                            height: 180,
                                            color: theme
                                                .colorScheme.surfaceVariant
                                                .withOpacity(0.5),
                                            child: Center(
                                                child: Icon(
                                                    Icons.event_busy_outlined,
                                                    size: 50,
                                                    color: Colors.grey[700]))),
                                  ),
                                ),

                              const SizedBox(height: 12),
                              Text(event.title,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'NotoSerif')),
                              const SizedBox(height: 6),
                              Text(
                                event.description, 
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Original Schedule: ${event.originalTimeZoneLabel}",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[500]),
                              ),
                              const Divider(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EventMapPage(event: event),
                                      ),
                                    );
                                  },
                                  label:
                                      const Text("Lihat di Peta"), 
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.9),
                                    foregroundColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),

                              Row(
                                children: [
                                  Icon(Icons.access_time_filled_rounded,
                                      color: theme.colorScheme.primary,
                                      size: 20),
                                  const SizedBox(width: 8),
                                  Text("Converted Schedule:",
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _formatDateTime(event.eventTimeUtc,
                                    _selectedTargetTimeZoneKey), 
                                style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.secondary),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
