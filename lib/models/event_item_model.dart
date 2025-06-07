class EventItem {
  final String id;
  final String title;
  final String description;
  final DateTime eventTimeUtc; 
  final String
      originalTimeZoneLabel; 
  final String? imageUrl; 
  final double? latitude;  
  final double? longitude; 

  EventItem({
    required this.id,
    required this.title,
    required this.description,
    required this.eventTimeUtc,
    required this.originalTimeZoneLabel,
    this.imageUrl,
    this.latitude,  
    this.longitude, 
  });
}
