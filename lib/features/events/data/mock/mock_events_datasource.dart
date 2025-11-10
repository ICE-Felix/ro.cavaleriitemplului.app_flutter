import 'package:app/features/events/data/events_datasource.dart';
import 'package:app/features/events/data/model/events_search_responce.dart';
import 'package:app/features/events/domain/model/events.dart';
import 'package:app/features/events/domain/model/events_type.dart';

class MockEventsDatasource implements EventsDatasource {
  // Mock event types
  final List<EventType> _eventTypes = [
    const EventType(
      id: '1',
      name: 'Ceremonii',
      isActive: true,
      createdAt: '2025-01-01T00:00:00Z',
    ),
    const EventType(
      id: '2',
      name: 'Tradiții',
      isActive: true,
      createdAt: '2025-01-01T00:00:00Z',
    ),
    const EventType(
      id: '3',
      name: 'Educație',
      isActive: true,
      createdAt: '2025-01-01T00:00:00Z',
    ),
    const EventType(
      id: '4',
      name: 'Social',
      isActive: true,
      createdAt: '2025-01-01T00:00:00Z',
    ),
    const EventType(
      id: '5',
      name: 'Caritate',
      isActive: true,
      createdAt: '2025-01-01T00:00:00Z',
    ),
  ];

  // Mock events focused on November 2025
  final List<Event> _mockEvents = [
    Event(
      id: '1',
      createdAt: '2025-11-01T00:00:00Z',
      title: 'Ținută Rituală R.L. Cavalerii Templului nr.126',
      description: '''<p>Vă invităm la Ținuta Rituală a Respctabilei Loji Cavalerii Templului nr.126, Or.București.</p>
<p><strong>Program:</strong></p>
<ul>
<li>19:00 - Deschiderea lucrărilor</li>
<li>19:15 - Ritual masonic</li>
<li>21:00 - Închiderea lucrărilor</li>
<li>21:30 - Agapă fraternă</li>
</ul>
<p>Confirmări obligatorii până la 08.11.2025</p>''',
      eventTypeId: '1',
      venueId: 'venue_1',
      start: DateTime(2025, 11, 10, 19, 0).toIso8601String(),
      end: DateTime(2025, 11, 10, 22, 0).toIso8601String(),
      scheduleType: 'once',
      theme: 'Ritual Masonic',
      agenda: 'Deschidere - Ritual - Închidere - Agapă',
      price: '0',
      contactPerson: 'Secretar R.L. 126',
      phoneNo: '+40773822400',
      email: 'contact@cavaleriitemplului126.ro',
      capacity: '50',
      status: 'active',
      eventImageId: 'https://images.unsplash.com/photo-1519167758481-83f29da8c466?w=800',
      locationLatitude: '44.4268',
      locationLongitude: '26.1025',
      address: 'Strada Academiei nr. 28-30, București',
      eventTypeName: 'Ceremonii',
      venueName: 'Templul Odeon',
    ),
    Event(
      id: '2',
      createdAt: '2025-11-01T00:00:00Z',
      title: 'Ținuta Nr. 4 - R.L. Steaua României Nr.113',
      description: '''<p>Iubite Frate,</p>
<p>Te rog, primește invitația noastră la <strong>Ținuta Nr. 4</strong>, din 11/11/6025 A.L., a R.L. Steaua României, Nr.113, Or.București.</p>
<p><strong>Confirmări:</strong></p>
<ul>
<li>On-line la: <a href="https://forms.gle/5sAPPjSh7wcDoSLu7">https://forms.gle/5sAPPjSh7wcDoSLu7</a></li>
<li>Telefonic la: +40747760629 sau +40773822400</li>
</ul>
<p>Vă așteptăm cu drag la această ținută specială a lojii noastre.</p>''',
      eventTypeId: '1',
      venueId: 'venue_2',
      start: DateTime(2025, 11, 11, 18, 0).toIso8601String(),
      end: DateTime(2025, 11, 11, 21, 30).toIso8601String(),
      scheduleType: 'once',
      theme: 'Ținută Rituală Nr. 4',
      agenda: 'Ritual masonic - Lucrări administrative - Agapă',
      price: '0',
      contactPerson: 'Venerabil Maestru',
      phoneNo: '+40747760629',
      email: 'contact@stearomaniei113.ro',
      capacity: '45',
      status: 'active',
      eventImageId: 'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=800',
      locationLatitude: '44.4378',
      locationLongitude: '26.0965',
      address: 'Calea Victoriei nr. 155, București',
      eventTypeName: 'Ceremonii',
      venueName: 'Templul Steaua României',
    ),
    Event(
      id: '3',
      createdAt: '2025-11-02T00:00:00Z',
      title: 'Seară Educațională: Istoria Francmasoneriei în România',
      description: '''<p>Vă invităm la o seară educațională dedicată istoriei francmasoneriei în România.</p>
<p><strong>Programa:</strong></p>
<ul>
<li>Prezentare istoric - Prima Mare Lojă a României</li>
<li>Evoluția masoneriei în secolul XX</li>
<li>Renașterea post-1989</li>
<li>Sesiune Q&A</li>
</ul>
<p>Eveniment deschis pentru frați și invitați special.</p>''',
      eventTypeId: '3',
      venueId: 'venue_3',
      start: DateTime(2025, 11, 15, 18, 30).toIso8601String(),
      end: DateTime(2025, 11, 15, 21, 0).toIso8601String(),
      scheduleType: 'once',
      theme: 'Educație și Istorie',
      agenda: 'Prezentări - Discuții - Networking',
      price: '0',
      contactPerson: 'Frate Andrei Popescu',
      phoneNo: '+40721234567',
      email: 'educatie@masoneria.ro',
      capacity: '60',
      status: 'active',
      eventImageId: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800',
      locationLatitude: '44.4325',
      locationLongitude: '26.1039',
      address: 'Bulevardul Carol I nr. 45, București',
      eventTypeName: 'Educație',
      venueName: 'Sala de Conferințe Masonica',
    ),
    Event(
      id: '4',
      createdAt: '2025-11-03T00:00:00Z',
      title: 'Ceremonie de Inițiere',
      description: '''<p>Ceremonie specială de inițiere pentru noi candidați în ordinul masonic.</p>
<p>Eveniment privat, exclusiv pentru membrii lojii și candidații aprobați.</p>
<p><strong>Important:</strong> Participarea se face doar pe bază de invitație.</p>''',
      eventTypeId: '1',
      venueId: 'venue_1',
      start: DateTime(2025, 11, 17, 19, 0).toIso8601String(),
      end: DateTime(2025, 11, 17, 23, 0).toIso8601String(),
      scheduleType: 'once',
      theme: 'Inițiere în gradul de Ucenic',
      agenda: 'Pregătire - Ceremonia de Inițiere - Agapă',
      price: '0',
      contactPerson: 'Maestru de Ceremonii',
      phoneNo: '+40731456789',
      email: 'ceremonii@cavaleriitemplului126.ro',
      capacity: '40',
      status: 'active',
      eventImageId: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=800',
      locationLatitude: '44.4268',
      locationLongitude: '26.1025',
      address: 'Strada Academiei nr. 28-30, București',
      eventTypeName: 'Ceremonii',
      venueName: 'Templul Odeon',
    ),
    Event(
      id: '5',
      createdAt: '2025-11-04T00:00:00Z',
      title: 'Gală de Caritate Masonică',
      description: '''<p>Eveniment caritabil organizat de lojile masonice din București pentru susținerea copiilor defavorizați.</p>
<p><strong>Program:</strong></p>
<ul>
<li>19:00 - Cocktail de bun venit</li>
<li>20:00 - Cină festivă</li>
<li>21:00 - Licitație caritabilă</li>
<li>22:00 - Program artistic</li>
</ul>
<p>Fondurile strânse vor fi donate către fundații pentru copii.</p>''',
      eventTypeId: '5',
      venueId: 'venue_4',
      start: DateTime(2025, 11, 20, 19, 0).toIso8601String(),
      end: DateTime(2025, 11, 20, 23, 30).toIso8601String(),
      scheduleType: 'once',
      theme: 'Caritate și Filantropie',
      agenda: 'Cocktail - Cină - Licitație - Program artistic',
      price: '250',
      contactPerson: 'Comitetul de Caritate',
      phoneNo: '+40741987654',
      email: 'caritate@masoneria.ro',
      age: '18+',
      capacity: '120',
      status: 'active',
      eventImageId: 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=800',
      locationLatitude: '44.4458',
      locationLongitude: '26.0975',
      address: 'Șoseaua Kiseleff nr. 32, București',
      eventTypeName: 'Caritate',
      venueName: 'Grand Hotel Ballroom',
    ),
    Event(
      id: '6',
      createdAt: '2025-11-05T00:00:00Z',
      title: 'Seară Tradiții Masonice de Iarnă',
      description: '''<p>Celebrăm tradițiile masonice de iarnă într-o atmosferă caldă și fraternă.</p>
<p><strong>Activități:</strong></p>
<ul>
<li>Prezentare despre simbolistica de iarnă în masonerie</li>
<li>Moment muzical tradițional</li>
<li>Cină fraternă cu preparate tradiționale</li>
<li>Schimb de daruri simbolice</li>
</ul>
<p>Eveniment deschis pentru frați și familiile acestora.</p>''',
      eventTypeId: '2',
      venueId: 'venue_2',
      start: DateTime(2025, 11, 22, 18, 0).toIso8601String(),
      end: DateTime(2025, 11, 22, 22, 0).toIso8601String(),
      scheduleType: 'once',
      theme: 'Tradiții și Comunitate',
      agenda: 'Prezentare - Program muzical - Cină - Socializare',
      price: '80',
      contactPerson: 'Frate Ion Marinescu',
      phoneNo: '+40755123456',
      email: 'traditii@masoneria.ro',
      capacity: '70',
      status: 'active',
      eventImageId: 'https://images.unsplash.com/photo-1511578314322-379afb476865?w=800',
      locationLatitude: '44.4378',
      locationLongitude: '26.0965',
      address: 'Calea Victoriei nr. 155, București',
      eventTypeName: 'Tradiții',
      venueName: 'Templul Steaua României',
    ),
    Event(
      id: '7',
      createdAt: '2025-11-06T00:00:00Z',
      title: 'Workshop: Simbolistica Masonică',
      description: '''<p>Workshop interactiv dedicat înțelegerii profunde a simbolurilor masonice.</p>
<p><strong>Subiecte abordate:</strong></p>
<ul>
<li>Compasul și echerul - semnificații și interpretări</li>
<li>Piatra brută și piatra cizelată</li>
<li>Simbolurile luminii în ritual</li>
<li>Exerciții practice de interpretare</li>
</ul>
<p>Workshop destinat ucenicilor și calfelor.</p>''',
      eventTypeId: '3',
      venueId: 'venue_3',
      start: DateTime(2025, 11, 24, 17, 0).toIso8601String(),
      end: DateTime(2025, 11, 24, 20, 30).toIso8601String(),
      scheduleType: 'once',
      theme: 'Educație Ezoterică',
      agenda: 'Introducere - Workshop interactiv - Discuții - Concluzii',
      price: '0',
      contactPerson: 'Frate Mihai Constantinescu',
      phoneNo: '+40766789012',
      email: 'workshop@masoneria.ro',
      capacity: '35',
      status: 'active',
      eventImageId: 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=800',
      locationLatitude: '44.4325',
      locationLongitude: '26.1039',
      address: 'Bulevardul Carol I nr. 45, București',
      eventTypeName: 'Educație',
      venueName: 'Sala de Conferințe Masonica',
    ),
    Event(
      id: '8',
      createdAt: '2025-11-07T00:00:00Z',
      title: 'Întâlnire Socială de Sfârșit de Lună',
      description: '''<p>Întâlnire informală pentru menținerea legăturilor frățești în afara cadrului ritual.</p>
<p><strong>Program:</strong></p>
<ul>
<li>Aperitiv și băuturi</li>
<li>Discuții libere și networking</li>
<li>Jocuri de societate</li>
<li>Planificarea activităților pentru decembrie</li>
</ul>
<p>Atmosferă relaxată, dresscode casual.</p>''',
      eventTypeId: '4',
      venueId: 'venue_5',
      start: DateTime(2025, 11, 28, 19, 30).toIso8601String(),
      end: DateTime(2025, 11, 28, 23, 0).toIso8601String(),
      scheduleType: 'once',
      theme: 'Socializare și Fraternitate',
      agenda: 'Aperitiv - Socializare - Jocuri - Planificare',
      price: '50',
      contactPerson: 'Frate Alexandru Dumitrescu',
      phoneNo: '+40778456123',
      email: 'social@masoneria.ro',
      capacity: '55',
      status: 'active',
      eventImageId: 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800',
      locationLatitude: '44.4298',
      locationLongitude: '26.1085',
      address: 'Strada Franceza nr. 12, București',
      eventTypeName: 'Social',
      venueName: 'Club Masonic București',
    ),
  ];

  @override
  Future<EventsSearchResponse> getEventsSearch({
    required String? eventTypeId,
    required int page,
    required int limit,
    required String date,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    print('🔍 MockEventsDatasource: Searching events');
    print('   - Event Type ID: $eventTypeId');
    print('   - Page: $page');
    print('   - Limit: $limit');
    print('   - Date: $date');
    print('   - Total mock events: ${_mockEvents.length}');

    // Filter events by event type if provided
    List<Event> filteredEvents = _mockEvents;
    if (eventTypeId != null && eventTypeId.isNotEmpty) {
      filteredEvents = _mockEvents
          .where((event) => event.eventTypeId == eventTypeId)
          .toList();
      print('   - After type filter: ${filteredEvents.length} events');
    }

    // Filter by date if provided (events on the same day)
    if (date.isNotEmpty) {
      final filterDate = DateTime.parse(date);
      print('   - Filter date parsed: $filterDate');
      filteredEvents = filteredEvents.where((event) {
        final eventStart = DateTime.parse(event.start);
        final matches = eventStart.year == filterDate.year &&
            eventStart.month == filterDate.month &&
            eventStart.day == filterDate.day;
        if (matches) {
          print('   ✓ Event matched: ${event.title} on ${event.start}');
        }
        return matches;
      }).toList();
      print('   - After date filter: ${filteredEvents.length} events');
    }

    // Sort by start date
    filteredEvents.sort((a, b) {
      final aStart = DateTime.parse(a.start);
      final bStart = DateTime.parse(b.start);
      return aStart.compareTo(bStart);
    });

    // Calculate pagination
    final total = filteredEvents.length;
    final offset = (page - 1) * limit;
    final endIndex = (offset + limit).clamp(0, total);
    final paginatedEvents = filteredEvents.sublist(
      offset.clamp(0, total),
      endIndex,
    );

    final totalPages = (total / limit).ceil();
    final hasNext = page < totalPages;
    final hasPrevious = page > 1;

    return EventsSearchResponse(
      data: paginatedEvents,
      meta: Meta(
        pagination: Pagination(
          total: total,
          limit: limit,
          offset: offset,
          page: page,
          totalPages: totalPages,
          hasNext: hasNext,
          hasPrevious: hasPrevious,
        ),
        filters: {
          if (eventTypeId != null) 'event_type_id': eventTypeId,
          'date': date,
        },
      ),
    );
  }

  @override
  Future<List<EventType>> getEventTypes() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _eventTypes;
  }

  @override
  Future<Event> getEventById(String eventId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      return _mockEvents.firstWhere((event) => event.id == eventId);
    } catch (e) {
      throw Exception('Event with id $eventId not found');
    }
  }
}
