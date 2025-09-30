class Event {
  final String id;
  final String createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String title;
  final String description;
  final String eventTypeId;
  final String venueId;
  final String start;
  final String end;
  final String scheduleType;
  final String theme;
  final String agenda;
  final String price;
  final String contactPerson;
  final String phoneNo;
  final String email;
  final String? age;
  final String capacity;
  final String? status;
  final String? eventImageId;
  final String locationLatitude;
  final String locationLongitude;
  final String address;
  final String eventTypeName;
  final String venueName;

  const Event({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.title,
    required this.description,
    required this.eventTypeId,
    required this.venueId,
    required this.start,
    required this.end,
    required this.scheduleType,
    required this.theme,
    required this.agenda,
    required this.price,
    required this.contactPerson,
    required this.phoneNo,
    required this.email,
    this.age,
    required this.capacity,
    this.status,
    this.eventImageId,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.address,
    required this.eventTypeName,
    required this.venueName,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      eventTypeId: json['event_type_id'] as String? ?? '',
      venueId: json['venue_id'] as String? ?? '',
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
      scheduleType: json['schedule_type'] as String? ?? '',
      theme: json['theme'] as String? ?? '',
      agenda: json['agenda'] as String? ?? '',
      price: json['price'] as String? ?? '',
      contactPerson: json['contact_person'] as String? ?? '',
      phoneNo: json['phone_no'] as String? ?? '',
      email: json['email'] as String? ?? '',
      age: json['age'] as String?,
      capacity: json['capacity'] as String? ?? '',
      status: json['status'] as String?,
      eventImageId: json['event_image_id'] as String?,
      locationLatitude: json['location_latitude'] as String? ?? '',
      locationLongitude: json['location_longitude'] as String? ?? '',
      address: json['address'] as String? ?? '',
      eventTypeName: json['event_type_name'] as String? ?? '',
      venueName: json['venue_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'title': title,
      'description': description,
      'event_type_id': eventTypeId,
      'venue_id': venueId,
      'start': start,
      'end': end,
      'schedule_type': scheduleType,
      'theme': theme,
      'agenda': agenda,
      'price': price,
      'contact_person': contactPerson,
      'phone_no': phoneNo,
      'email': email,
      'age': age,
      'capacity': capacity,
      'status': status,
      'event_image_id': eventImageId,
      'location_latitude': locationLatitude,
      'location_longitude': locationLongitude,
      'address': address,
      'event_type_name': eventTypeName,
      'venue_name': venueName,
    };
  }
}
