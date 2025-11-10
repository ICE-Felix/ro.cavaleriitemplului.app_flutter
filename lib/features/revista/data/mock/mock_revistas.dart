import '../../domain/entities/revista_entity.dart';

/// Mock data for revistas (library/magazine publications)
class MockRevistas {
  static final List<RevistaEntity> revistas = [
    RevistaEntity(
      id: '1',
      title: 'Cavalerii Templului - Nr. 1/2025',
      description:
          'Număr special dedicat istoriei ordinului și valorilor masonice. Conține articole despre simbolismul masonic, ritualuri și tradiții.',
      imageUrl:
          'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400',
      pdfUrl: 'mock_pdf_url_1',
      publishedAt: DateTime(2025, 1, 15),
      pageCount: 48,
      issueNumber: 'Nr. 1/2025',
    ),
    RevistaEntity(
      id: '2',
      title: 'Luminile Orientului - Ediția de Iarnă 2024',
      description:
          'Explorarea filosofiei și eticii masonice. Articole despre îmbunătățirea morală și spirituală a membrilor.',
      imageUrl:
          'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400',
      pdfUrl: 'mock_pdf_url_2',
      publishedAt: DateTime(2024, 12, 20),
      pageCount: 56,
      issueNumber: 'Ediția de Iarnă 2024',
    ),
    RevistaEntity(
      id: '3',
      title: 'Magia Ritualurilor - Nr. 12/2024',
      description:
          'Ghid complet pentru ceremoniile și ritualurile masonice tradiționale. Include interpretări și semnificații profunde.',
      imageUrl:
          'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400',
      pdfUrl: 'mock_pdf_url_3',
      publishedAt: DateTime(2024, 11, 10),
      pageCount: 64,
      issueNumber: 'Nr. 12/2024',
    ),
    RevistaEntity(
      id: '4',
      title: 'Arhitectura Sacră - Ediție Specială',
      description:
          'Studiu aprofundat al simbolismului geometric în masonerie. Conexiuni între geometrie sacră și spiritualitate.',
      imageUrl:
          'https://images.unsplash.com/photo-1519682337058-a94d519337bc?w=400',
      pdfUrl: 'mock_pdf_url_4',
      publishedAt: DateTime(2024, 10, 5),
      pageCount: 72,
      issueNumber: 'Ediție Specială 2024',
    ),
    RevistaEntity(
      id: '5',
      title: 'Frăția și Solidaritatea - Nr. 9/2024',
      description:
          'Discuții despre valorile fundamentale ale ordinului: frăția, caritatea și ajutorul mutual între membrii lojei.',
      imageUrl:
          'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=400',
      pdfUrl: 'mock_pdf_url_5',
      publishedAt: DateTime(2024, 9, 15),
      pageCount: 40,
      issueNumber: 'Nr. 9/2024',
    ),
    RevistaEntity(
      id: '6',
      title: 'Călătoria Inițiatică - Nr. 8/2024',
      description:
          'Îndrumări pentru noii membri și reflecții despre progresul spiritual în cadrul ordinului.',
      imageUrl:
          'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=400',
      pdfUrl: 'mock_pdf_url_6',
      publishedAt: DateTime(2024, 8, 20),
      pageCount: 52,
      issueNumber: 'Nr. 8/2024',
    ),
    RevistaEntity(
      id: '7',
      title: 'Simboluri și Semnificații - Nr. 7/2024',
      description:
          'Decodificarea simbolurilor masonice și importanța lor în ritualurile tradiționale. Analiză detaliată a iconografiei.',
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      pdfUrl: 'mock_pdf_url_7',
      publishedAt: DateTime(2024, 7, 10),
      pageCount: 60,
      issueNumber: 'Nr. 7/2024',
    ),
    RevistaEntity(
      id: '8',
      title: 'Istoria Ordinului - Volum Aniversar',
      description:
          'Retrospectivă completă a istoriei Cavalerilor Templului din România. De la origini până în prezent.',
      imageUrl:
          'https://images.unsplash.com/photo-1516979187457-637abb4f9353?w=400',
      pdfUrl: 'mock_pdf_url_8',
      publishedAt: DateTime(2024, 6, 1),
      pageCount: 96,
      issueNumber: 'Volum Aniversar 2024',
    ),
    RevistaEntity(
      id: '9',
      title: 'Învățăminte Ezoterice - Nr. 5/2024',
      description:
          'Studii despre tradițiile ezoterice și misterele ascunse ale masoneriei. Pentru membrii avansați.',
      imageUrl:
          'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=400',
      pdfUrl: 'mock_pdf_url_9',
      publishedAt: DateTime(2024, 5, 15),
      pageCount: 68,
      issueNumber: 'Nr. 5/2024',
    ),
    RevistaEntity(
      id: '10',
      title: 'Arta și Cultura Masonică - Nr. 4/2024',
      description:
          'Explorarea influenței masoneriei în artă, literatură și cultură. Contribuții ale francmasonilor celebri.',
      imageUrl:
          'https://images.unsplash.com/photo-1506880018603-83d5b814b5a6?w=400',
      pdfUrl: 'mock_pdf_url_10',
      publishedAt: DateTime(2024, 4, 20),
      pageCount: 44,
      issueNumber: 'Nr. 4/2024',
    ),
    RevistaEntity(
      id: '11',
      title: 'Filosofia Luminilor - Nr. 3/2024',
      description:
          'Conexiunea între Epoca Luminilor și principiile masonice moderne. Studii filosofice aprofundate.',
      imageUrl:
          'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=400',
      pdfUrl: 'mock_pdf_url_11',
      publishedAt: DateTime(2024, 3, 10),
      pageCount: 58,
      issueNumber: 'Nr. 3/2024',
    ),
    RevistaEntity(
      id: '12',
      title: 'Tradiții și Modernitate - Nr. 2/2024',
      description:
          'Echilibrul între respectarea tradițiilor seculare și adaptarea la societatea contemporană.',
      imageUrl:
          'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=400',
      pdfUrl: 'mock_pdf_url_12',
      publishedAt: DateTime(2024, 2, 5),
      pageCount: 50,
      issueNumber: 'Nr. 2/2024',
    ),
  ];

  /// Get paginated revistas
  static List<RevistaEntity> getPaginatedRevistas({
    int page = 1,
    int pageSize = 10,
  }) {
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex >= revistas.length) {
      return [];
    }

    return revistas.sublist(
      startIndex,
      endIndex > revistas.length ? revistas.length : endIndex,
    );
  }

  /// Get revista by ID
  static RevistaEntity? getRevistaById(String id) {
    try {
      return revistas.firstWhere((revista) => revista.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search revistas by title or description
  static List<RevistaEntity> searchRevistas(String query) {
    if (query.isEmpty) return revistas;

    final lowerQuery = query.toLowerCase();
    return revistas.where((revista) {
      return revista.title.toLowerCase().contains(lowerQuery) ||
          revista.description.toLowerCase().contains(lowerQuery) ||
          revista.issueNumber.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get total number of revistas
  static int get totalCount => revistas.length;

  /// Check if there are more revistas to load
  static bool hasMoreRevistas({required int currentCount}) {
    return currentCount < revistas.length;
  }
}
