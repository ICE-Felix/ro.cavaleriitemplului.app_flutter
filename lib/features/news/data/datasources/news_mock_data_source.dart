import '../models/news_model.dart';

class NewsMockDataSource {
  static List<NewsModel> getMockNews() {
    return [
      NewsModel(
        id: 1,
        title: 'Săptămâna Jocurilor cu MindHub la Artar',
        content:
            'MindHub Bucuresti Unirii organizează o săptămână dedicată jocurilor educative pentru copii. Evenimentul va avea loc în perioada 16-22 iunie și va include activități interactive pentru dezvoltarea creativității și gândirii logice.',
        summary:
            'MindHub organizează o săptămână de jocuri educative pentru copii în perioada 16-22 iunie.',
        imageUrl:
            'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=800&auto=format&fit=crop',
        author: 'Ana Popescu',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        category: 'General',
        source: 'MindHub București Unirii',
        views: 245,
        tags: ['educație', 'copii', 'jocuri', 'MindHub'],
      ),
      NewsModel(
        id: 2,
        title: 'Copiii mănâncă gratuit la Buongiorno Italian Victoriei',
        content:
            'Restaurantul Buongiorno Italian din Calea Victoriei oferă mese gratuite pentru copii în fiecare weekend. Inițiativa face parte din programul de responsabilitate socială al companiei.',
        summary:
            'Buongiorno Italian oferă mese gratuite pentru copii în weekenduri.',
        imageUrl:
            'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=800&auto=format&fit=crop',
        author: 'Maria Ionescu',
        publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
        category: 'Oferte Speciale',
        source: 'Buongiorno Italian Victoriei',
        views: 189,
        tags: ['familie', 'copii', 'restaurant', 'gratuit'],
      ),
      NewsModel(
        id: 3,
        title: 'Reducere peste reducere? Da, de la Funlandia!',
        content:
            'Funlandia anunță o nouă campanie de reduceri cu discount-uri de până la 50% pentru toate activitățile din parcul de distracții. Oferta este valabilă până la sfârșitul lunii.',
        summary:
            'Funlandia oferă reduceri de până la 50% pentru toate activitățile.',
        imageUrl:
            'https://images.unsplash.com/photo-1545558014-8692077e9b5c?w=800&auto=format&fit=crop',
        author: 'Andrei Muresan',
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
        category: 'Oferte Speciale',
        source: 'Funlandia',
        views: 567,
        tags: ['divertisment', 'reduceri', 'parc', 'copii'],
      ),
      NewsModel(
        id: 4,
        title:
            'Fișă GRATUITĂ 12 întrebări de adresat copiilor la final de an școlar',
        content:
            'Specialiștii în educație au pregătit o listă cu 12 întrebări esențiale pe care părinții ar trebui să le adreseze copiilor la sfârșitul anului școlar pentru a evalua progresul și a plănui vacanța.',
        summary:
            'Lista gratuită cu 12 întrebări pentru evaluarea copiilor la sfârșitul anului școlar.',
        imageUrl:
            'https://images.unsplash.com/photo-1497486751825-1233686d5d80?w=800',
        author: 'Dr. Elena Vasile',
        publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
        category: 'Oferte Speciale',
        source: 'Funlandia',
        views: 423,
        tags: ['educație', 'părinți', 'copii', 'școală'],
      ),
      NewsModel(
        id: 5,
        title:
            'Grupa Montessori la Heidi by ETOS Academy Brașov – Ultimele locuri pentru 2025!',
        content:
            'ETOS Academy din Brașov anunță că mai sunt disponibile ultimele locuri pentru grupa Montessori de la Heidi. Înscrierile pentru anul 2025 se apropie de final.',
        summary:
            'Ultimele locuri disponibile pentru grupa Montessori de la Heidi by ETOS Academy Brașov.',
        imageUrl:
            'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=800',
        author: 'Cristina Moldovan',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        category: 'General',
        source: 'Creșa și Grădinița Heidi by ETOS',
        views: 312,
        tags: ['Montessori', 'educație', 'Brașov', 'înscrieri'],
      ),
      NewsModel(
        id: 6,
        title: 'Ateliere de dezvoltare personală pentru mame',
        content:
            'Un nou program de ateliere dedicate mamelor care doresc să își dezvolte abilitățile parentale și să găsească un echilibru între viața profesională și cea de familie.',
        summary: 'Ateliere de dezvoltare personală pentru mame moderne.',
        imageUrl:
            'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=800',
        author: 'Laura Petrescu',
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        category: 'General',
        source: 'Centrul de Dezvoltare Parentală',
        views: 278,
        tags: ['parenting', 'mame', 'dezvoltare', 'ateliere'],
      ),
      NewsModel(
        id: 7,
        title: 'Tabăra de vară pentru copii 2024 - Înscrieri deschise',
        content:
            'Începând cu luna iulie, sunt deschise înscrierile pentru tabăra de vară destinată copiilor cu vârste între 6 și 14 ani. Programul include activități sportive, creative și educaționale.',
        summary: 'Înscrieri deschise pentru tabăra de vară 2024 pentru copii.',
        imageUrl:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
        author: 'Mihai Georgescu',
        publishedAt: DateTime.now().subtract(const Duration(days: 3)),
        category: 'Oferte Speciale',
        source: 'Tabăra Aventura',
        views: 445,
        tags: ['tabără', 'vară', 'copii', 'activități'],
      ),
      NewsModel(
        id: 8,
        title: 'Concurs de desen pentru cei mici',
        content:
            'Primăria Sectorului 1 organizează un concurs de desen cu tema "Orașul meu de vis" pentru copiii cu vârste între 4 și 12 ani. Premiile includ materiale de artă și excursii.',
        summary:
            'Concurs de desen "Orașul meu de vis" pentru copii organizat de Primăria Sectorului 1.',
        imageUrl:
            'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=800',
        author: 'Ioana Radu',
        publishedAt: DateTime.now().subtract(const Duration(days: 4)),
        category: 'General',
        source: 'Primăria Sectorului 1',
        views: 523,
        tags: ['concurs', 'desen', 'copii', 'artă'],
      ),
      NewsModel(
        id: 9,
        title: 'Nouă locație de joacă interactivă în Bucuresti',
        content:
            'În zona Pipera s-a deschis o nouă locație de joacă interactivă pentru copii, cu tehnologie de ultimă generație și activități educaționale inovatoare.',
        summary:
            'Nouă locație de joacă interactivă cu tehnologie avansată în Pipera.',
        imageUrl:
            'https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=800',
        author: 'Bogdan Stancu',
        publishedAt: DateTime.now().subtract(const Duration(days: 5)),
        category: 'General',
        source: 'PlayTech Kids',
        views: 367,
        tags: ['joacă', 'interactiv', 'tehnologie', 'Pipera'],
      ),
      NewsModel(
        id: 10,
        title: 'Workshop gratuit: Cum să comunici eficient cu copilul tău',
        content:
            'Psihologii specializați în dezvoltarea copilului oferă un workshop gratuit pentru părinți despre tehnicile de comunicare eficientă cu copiii de toate vârstele.',
        summary:
            'Workshop gratuit pentru părinți despre comunicarea eficientă cu copiii.',
        imageUrl:
            'https://images.unsplash.com/photo-1491438590914-bc09fcaaf77a?w=800',
        author: 'Dr. Alina Popescu',
        publishedAt: DateTime.now().subtract(const Duration(days: 6)),
        category: 'Oferte Speciale',
        source: 'Centrul de Psihologie Infantilă',
        views: 289,
        tags: ['workshop', 'comunicare', 'părinți', 'psihologie'],
      ),
      NewsModel(
        id: 11,
        title: 'Consiliere psihologică gratuită pentru părinți',
        content:
            'Centrul de Dezvoltare Parentală oferă sesiuni gratuite de consiliere psihologică pentru părinții care doresc să își îmbunătățească relația cu copiii și să gestioneze mai bine provocările parentale.',
        summary: 'Sesiuni gratuite de consiliere psihologică pentru părinți.',
        imageUrl: '', // Empty image to show placeholder
        author: 'Dr. Mihai Stoica',
        publishedAt: DateTime.now().subtract(const Duration(days: 7)),
        category: 'General',
        source: 'Centrul de Dezvoltare Parentală',
        views: 156,
        tags: ['consiliere', 'psihologie', 'părinți', 'gratuit'],
      ),
      NewsModel(
        id: 12,
        title: 'Cursuri de yoga pentru mamici și bebeluși',
        content:
            'Studio Zen din centrul Bucureștiului introduce un nou program de yoga dedicat mamicilor cu bebeluși. Cursurile sunt adaptate pentru toate nivelurile și ajută la relaxare și întărirea legăturii mama-copil.',
        summary: 'Cursuri de yoga adaptate pentru mamici și bebeluși.',
        imageUrl: '', // Empty image to show placeholder
        author: 'Elena Yoga',
        publishedAt: DateTime.now().subtract(const Duration(days: 8)),
        category: 'General',
        source: 'Studio Zen',
        views: 234,
        tags: ['yoga', 'mamici', 'bebeluși', 'relaxare'],
      ),
      NewsModel(
        id: 13,
        title: 'Program special de reduceri pentru cărți pentru copii',
        content:
            'Librăria Cărturești lansează o campanie specială cu reduceri de până la 40% pentru toate cărțile destinate copiilor. Campania durează până la sfârșitul lunii.',
        summary:
            'Reduceri de până la 40% pentru cărți pentru copii la Cărturești.',
        imageUrl: '', // Empty image to show placeholder
        author: 'Librăria Cărturești',
        publishedAt: DateTime.now().subtract(const Duration(days: 9)),
        category: 'Oferte Speciale',
        source: 'Cărturești',
        views: 378,
        tags: ['cărți', 'copii', 'reduceri', 'lectură'],
      ),
      NewsModel(
        id: 14,
        title: 'Atelier creativitate și artă pentru copii',
        content:
            'Casa de Cultură organizează un atelier de creativitate și artă pentru copiii cu vârste între 5 și 12 ani. Copiii vor învăța tehnici de pictură, desenat și lucru manual.',
        summary: 'Atelier de creativitate și artă pentru copii între 5-12 ani.',
        imageUrl:
            'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=800&auto=format&fit=crop',
        author: 'Casa de Cultură',
        publishedAt: DateTime.now().subtract(const Duration(days: 10)),
        category: 'General',
        source: 'Casa de Cultură Sector 2',
        views: 445,
        tags: ['artă', 'creativitate', 'copii', 'atelier'],
      ),
      NewsModel(
        id: 15,
        title: 'Seară de povești pentru cei mici',
        content:
            'Biblioteca Centrală organizează în fiecare vineri seara o sesiune de povești pentru copii. Evenimentul este gratuit și încurajează dragostea pentru lectură de la o vârstă frageda.',
        summary: 'Sesiuni gratuite de povești pentru copii în fiecare vineri.',
        imageUrl: '', // Empty image to show placeholder
        author: 'Biblioteca Centrală',
        publishedAt: DateTime.now().subtract(const Duration(days: 11)),
        category: 'General',
        source: 'Biblioteca Centrală',
        views: 167,
        tags: ['povești', 'copii', 'lectură', 'gratuit'],
      ),
    ];
  }

  static List<String> getMockCategories() {
    return ['General', 'Oferte Speciale'];
  }

  static List<NewsModel> searchMockNews(String query) {
    final allNews = getMockNews();
    return allNews.where((news) {
      return news.title.toLowerCase().contains(query.toLowerCase()) ||
          news.content.toLowerCase().contains(query.toLowerCase()) ||
          news.summary.toLowerCase().contains(query.toLowerCase()) ||
          news.category.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  static List<NewsModel> getMockNewsByCategory(String category) {
    final allNews = getMockNews();
    return allNews.where((news) => news.category == category).toList();
  }
}
