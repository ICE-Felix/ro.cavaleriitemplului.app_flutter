import 'package:app/features/news/domain/entities/news_entity.dart';

class MockNews {
  static List<NewsEntity> getMockNews({String? category}) {
    final allNews = _getAllNews();

    if (category == null || category.isEmpty) {
      return allNews;
    }

    return allNews.where((news) => news.category == category).toList();
  }

  static List<NewsEntity> searchNews(String query, {String? category}) {
    final news = getMockNews(category: category);

    if (query.isEmpty) return news;

    final lowerQuery = query.toLowerCase();
    return news.where((article) {
      return article.title.toLowerCase().contains(lowerQuery) ||
          article.content.toLowerCase().contains(lowerQuery) ||
          article.summary.toLowerCase().contains(lowerQuery) ||
          article.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  static NewsEntity? getNewsById(String id) {
    try {
      return _getAllNews().firstWhere((news) => news.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<NewsEntity> _getAllNews() {
    return [
      NewsEntity(
        id: '1',
        title: 'Adunarea Generală Anuală - Convocare',
        content: '''
Stimați Frați Cavaleri,

Cu bucurie vă anunțăm convocarea Adunării Generale Anuale a Lojei noastre, care va avea loc în data de 15 decembrie 2025, ora 18:00, la sediul lojei.

Ordinea de zi:
1. Deschiderea oficială și verificarea cvorumului
2. Raportul de activitate pe anul 2025
3. Raportul financiar și aprobarea bugetului
4. Alegerea noilor oficiali pentru mandatul 2026-2027
5. Prezentarea planului de activități pentru anul 2026
6. Diverse și închiderea lucrărilor

Prezența dumneavoastră este esențială pentru buna desfășurare a lucrărilor. În cazul în care nu puteți participa, vă rugăm să anunțați Secretarul Lojei.

Fratern,
Venerabilul Maestru
        ''',
        summary: 'Convocarea Adunării Generale Anuale pentru data de 15 decembrie 2025, cu ordinea de zi completă și detalii organizatorice.',
        imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800',
        author: 'Secretarul Lojei',
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        category: 'Anunțuri',
        source: 'Loja R.L. 126 C.T.',
        views: 145,
        tags: ['Adunare Generală', 'Convocări', 'Evenimente 2025'],
      ),
      NewsEntity(
        id: '2',
        title: 'Istoria Francmasoneriei în România',
        content: '''
Francmasoneria are o istorie bogată și complexă în România, care începe în a doua jumătate a secolului al XVIII-lea. Prima lojă masonică documentată pe teritoriul românesc a fost înființată la Brașov în 1749.

În secolul al XIX-lea, francmasoneria românească a cunoscut o dezvoltare semnificativă, multe personalități marcante ale epocii fiind membri ai diferitelor loje. Printre aceștia se numără Ion C. Brătianu, C.A. Rosetti, Nicolae Bălcescu și mulți alții care au contribuit la construirea României moderne.

Perioada interbelică a reprezentat vârful dezvoltării masoneriei românești, cu peste 10.000 de membri activi și numeroase loje răspândite în toate orașele importante ale țării. Această perioadă a fost urmată de suprimarea brutală a activității masonice în timpul regimului comunist.

După 1989, francmasoneria românească a renăscut, reluându-și activitatea în spirit democratic și modern, păstrând însă tradițiile și valorile fundamentale ale ordinului.
        ''',
        summary: 'O trecere în revistă a istoriei francmasoneriei pe teritoriul românesc, de la primele loje din secolul XVIII până în zilele noastre.',
        imageUrl: 'https://images.unsplash.com/photo-1461360370896-922624d12aa1?w=800',
        author: 'Fr. Historian',
        publishedAt: DateTime.now().subtract(const Duration(days: 5)),
        category: 'Istorie',
        source: 'Marele Orient al României',
        views: 287,
        tags: ['Istorie', 'România', 'Tradiție'],
      ),
      NewsEntity(
        id: '3',
        title: 'Simbolistica Scării lui Iacob',
        content: '''
Scara lui Iacob este unul dintre cele mai profunde simboluri masonice, reprezentând calea spirituală pe care fiecare mason trebuie să o parcurgă în căutarea luminii și a cunoașterii.

Conform tradiției biblice, Iacob a visat o scară care lega pământul de cer, pe care îngerii urcau și coborau. În masonerie, această scară simbolizează progresul spiritual și moral al omului, cele trei trepte principale reprezentând Credința, Speranța și Caritatea.

Fiecare treaptă a scării reprezintă o virtute sau o realizare pe care masonul trebuie să o dobândească în călătoria sa. Baza scării este fermă pe pământ, reprezentând rădăcinile noastre în realitatea materială, în timp ce vârful atinge cerul, simbolizând aspirațiile noastre spirituale.

Scara lui Iacob ne învață că drumul către perfecțiune este unul gradual, care necesită efort constant, perseverență și dedicare. Fiecare treaptă urcată ne aduce mai aproape de lumină și înțelegere.
        ''',
        summary: 'Explorarea profundă a semnificației și simbolismului Scării lui Iacob în tradițiile masonice.',
        imageUrl: 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800',
        author: 'Fr. Symbolicus',
        publishedAt: DateTime.now().subtract(const Duration(days: 7)),
        category: 'Simbolistică',
        source: 'Biblioteca Masonică',
        views: 312,
        tags: ['Simboluri', 'Spiritualitate', 'Tradiție'],
      ),
      NewsEntity(
        id: '4',
        title: 'Eveniment Caritabil - Succes Deplin',
        content: '''
Dragă Frați,

Cu mare bucurie vă anunțăm că evenimentul caritabil organizat de loja noastră în data de 25 noiembrie a fost un succes deplin. Datorită generozității și implicării dumneavoastră, am reușit să strângem suma de 25.000 lei, care va fi destinată susținerii copiilor defavorizați din județul nostru.

Evenimentul a reunit peste 150 de participanți, dintre care membri ai lojei, familiile acestora și prieteni ai ordinului. Atmosfera a fost una caldă și prietenoasă, cu momente muzicale și artistice care au încântat audiența.

Fondurile strânse vor fi utilizate pentru:
- Achiziționarea de rechizite școlare pentru 50 de copii
- Susținerea a 10 burse de merit pentru elevi
- Renovarea unei săli de clasă într-o școală rurală
- Achiziționarea de echipamente IT pentru un centru educațional

Mulțumim tuturor celor care au contribuit la succesul acestui eveniment și care au demonstrat că spiritul masonic de frăție și caritate este viu și puternic în comunitatea noastră.
        ''',
        summary: 'Raportul evenimentului caritabil organizat de lojă, care a strâns 25.000 lei pentru susținerea copiilor defavorizați.',
        imageUrl: 'https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=800',
        author: 'Comisia de Caritate',
        publishedAt: DateTime.now().subtract(const Duration(days: 10)),
        category: 'Evenimente',
        source: 'Loja R.L. 126 C.T.',
        views: 198,
        tags: ['Caritate', 'Evenimente', 'Comunitate'],
      ),
      NewsEntity(
        id: '5',
        title: 'Filosofia Masonică și Iluminismul',
        content: '''
Relația dintre francmasonerie și Iluminism este profundă și complexă, cele două mișcări împletindu-se în secolul al XVIII-lea într-un mod care a marcat profund istoria culturală și intelectuală europeană.

Iluminismul, cu accentul său pe rațiune, cunoaștere și progres, a găsit în francmasonerie un cadru ideal pentru dezvoltarea și răspândirea ideilor sale. Multe dintre marile personalități ale Iluminismului au fost masoni, iar lojile masonice au devenit centre de dezbatere intelectuală și promovare a valorilor iluministe.

Valorile comune ale celor două mișcări includ:
- Credința în puterea rațiunii umane
- Promovarea educației și cunoașterii
- Toleranța religioasă și libertatea de gândire
- Perfectibilitatea umană și progresul social
- Fraternitatea universală

Francmasoneria a oferit un spațiu protejat unde ideile iluministe puteau fi discutate liber, departe de cenzura și restricțiile impuse de autoritățile politice și religioase ale vremii. Astfel, lojile masonice au jucat un rol crucial în răspândirea ideilor care au stat la baza revoluțiilor democratice și a progresului social din secolele următoare.
        ''',
        summary: 'Analiza relației profunde dintre francmasonerie și mișcarea iluministă din secolul al XVIII-lea.',
        imageUrl: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=800',
        author: 'Fr. Philosophus',
        publishedAt: DateTime.now().subtract(const Duration(days: 14)),
        category: 'Filosofie',
        source: 'Academia Masonică',
        views: 256,
        tags: ['Filosofie', 'Iluminism', 'Istorie'],
      ),
      NewsEntity(
        id: '6',
        title: 'Ritual de Inițiere - Noi Candidați',
        content: '''
Stimați Frați Cavaleri,

Cu bucurie vă anunțăm că în data de 5 decembrie 2025, ora 19:00, va avea loc un ritual de inițiere pentru primirea a doi noi candidați în sânul lojei noastre.

Cei doi profani care și-au exprimat dorința de a deveni membri ai familiei noastre masonice au trecut cu succes prin perioada de pregătire și au demonstrat că înțeleg și împărtășesc valorile și principiile ordinului nostru.

Programul serii:
- 18:30 - Sosirea fraților și pregătirea templului
- 19:00 - Deschiderea ritualică a lucrărilor
- 19:15 - Începerea ceremoniei de inițiere
- 21:30 - Închiderea lucrărilor și agapă fraternă

Prezența dumneavoastră la acest moment solemn și important este esențială. Vă rugăm să confirmați participarea până în data de 3 decembrie.

Ținuta: complet rituală
Invitați: doar frați masoni cu cotizația la zi

Cu frăție,
Venerabilul Maestru
        ''',
        summary: 'Anunțul ritualului de inițiere pentru doi noi candidați, programat pentru data de 5 decembrie 2025.',
        imageUrl: 'https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=800',
        author: 'Venerabilul Maestru',
        publishedAt: DateTime.now().subtract(const Duration(days: 18)),
        category: 'Anunțuri',
        source: 'Loja R.L. 126 C.T.',
        views: 223,
        tags: ['Ritual', 'Inițiere', 'Evenimente'],
      ),
      NewsEntity(
        id: '7',
        title: 'Marile Mistere ale Templului lui Solomon',
        content: '''
Templul lui Solomon ocupă un loc central în simbolistica și ritualistica masonică, fiind considerat archetipul perfecțiunii spirituale și arhitecturale.

Conform tradiției biblice, Templul a fost construit în Ierusalim de regele Solomon în secolul al X-lea î.Hr., cu ajutorul arhitectului Hiram din Tir. Structura sa magnifică și simbolismul său profund au inspirat generații de masoni.

În masonerie, Templul lui Solomon reprezintă:
- Templul spiritual interior pe care fiecare mason trebuie să-l construiască în sine
- Perfecțiunea divină și armoniile universale
- Unitatea dintre lumea materială și cea spirituală
- Căutarea constantă a luminii și adevărului

Cele trei trepte ale intrării simbolizează calea de trei grade prin care trece masonul în evoluția sa spirituală. Cele două coloane, Boaz și Jachin, reprezintă dualitățile fundamentale ale existenței: forța și stabilitatea, activul și pasivul, masculinul și femininul.

Studiul simbolismului Templului lui Solomon rămâne una dintre cele mai profunde și mai complexe teme ale studiilor masonice, oferind永續 perspective noi și înțelesuri mai profunde celor care îl cercetează cu seriozitate și dedicare.
        ''',
        summary: 'Explorarea semnificației profunde a Templului lui Solomon în simbolistica și practica masonică.',
        imageUrl: 'https://images.unsplash.com/photo-1549055118-7dfbe87f4463?w=800',
        author: 'Fr. Historicus',
        publishedAt: DateTime.now().subtract(const Duration(days: 21)),
        category: 'Simbolistică',
        source: 'Institutul de Studii Masonice',
        views: 389,
        tags: ['Templu', 'Solomon', 'Simboluri', 'Istorie'],
      ),
      NewsEntity(
        id: '8',
        title: 'Conferință: Masoneria în Secolul XXI',
        content: '''
Dragă Frați,

Loja noastră are onoarea de a organiza o conferință specială dedicată temei "Masoneria în Secolul XXI - Tradiție și Modernitate", care va avea loc în data de 20 decembrie 2025, ora 18:00, în sala de conferințe a hotelului Continental.

Conferința va aborda următoarele subiecte:
1. Relevanța valorilor masonice în societatea contemporană
2. Adaptarea ritualurilor tradiționale la nevoile moderne
3. Masoneria și tehnologia - oportunități și provocări
4. Atragerea și educarea tinerilor masoni
5. Rolul lojilor în comunitatea modernă

Invitați speciali:
- M.W. Marele Maestru al Marelui Orient al României
- Prof. Dr. Ion Popescu - specialist în istorie masonică
- Fr. Alexandru Dumitrescu - președinte al Fundației Masonice
- Fr. Maria Ionescu - reprezentant al Masoneriei de Adopție

Conferința este deschisă atât membrilor ordinului, cât și profanilor interesați de subiect. Participarea este gratuită, dar înscrierea este obligatorie până în data de 15 decembrie.

Pentru înscrieri și informații suplimentare, contactați Secretarul Lojei.
        ''',
        summary: 'Anunțul conferinței "Masoneria în Secolul XXI" care va avea loc pe 20 decembrie, cu invitați speciali și teme relevante.',
        imageUrl: 'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=800',
        author: 'Comisia Culturală',
        publishedAt: DateTime.now().subtract(const Duration(days: 25)),
        category: 'Evenimente',
        source: 'Loja R.L. 126 C.T.',
        views: 176,
        tags: ['Conferință', 'Educație', 'Modernitate'],
      ),
      NewsEntity(
        id: '9',
        title: 'Virtutea Toleranței în Practica Masonică',
        content: '''
Toleranța este una dintre cele mai fundamentale virtuti masonice, un principiu care stă la baza întregii construcții morale și spirituale a ordinului nostru.

În lumea contemporană, marcată de diviziuni religioase, politice și culturale, mesajul masonic al toleranței capătă o relevanță deosebită. Francmasoneria învață că adevărul nu este monopolul unei singure doctrine, ci poate fi găsit în diverse forme și tradiții.

Toleranța masonică nu înseamnă indiferență sau relativism moral, ci recunoașterea demnității și dreptului fiecărui om de a-și urma propria cale spirituală. Este bazată pe convingerea profundă că diversitatea nu este o amenințare, ci o bogăție a umanității.

Practică zilnică a toleranței implică:
- Ascultarea activă și empatică
- Respectul pentru opinii diferite
- Căutarea punctelor comune, nu a dezbinării
- Combaterea prejudecăților și stereotipurilor
- Promovarea dialogului constructiv

În templu, masoni de diferite confesiuni religioase, orientări politice și origini sociale lucrează împreună în armonie, demonstrând că toleranța nu este doar un ideal abstract, ci o realitate trăită.
        ''',
        summary: 'Reflecție asupra importanței toleranței ca virtute fundamentală în practica și filosofia masonică.',
        imageUrl: 'https://images.unsplash.com/photo-1469571486292-0ba58a3f068b?w=800',
        author: 'Fr. Moralis',
        publishedAt: DateTime.now().subtract(const Duration(days: 28)),
        category: 'Filosofie',
        source: 'Revista Masonică',
        views: 294,
        tags: ['Virtuti', 'Toleranță', 'Filosofie'],
      ),
      NewsEntity(
        id: '10',
        title: 'Programul Educațional 2026',
        content: '''
Stimați Frați,

Cu plăcere vă prezentăm programul educațional al lojei pentru anul 2026, elaborat de Comisia de Educație Masonică.

Programul este structurat pe patru direcții principale:

1. Studii Ritualice (lunar)
- Analiza profundă a simbolurilor din ritual
- Practică și perfecționarea execuției ritualice
- Studiul variantelor ritualice din diferite jurisdicții

2. Istorie Masonică (bimestrial)
- Istoria francmasoneriei universale
- Masoneria în România
- Mari personalități masonice

3. Filosofie și Etică (trimestrial)
- Fundamentele filosofice ale masoneriei
- Etica masonică în practica cotidiană
- Masoneria și curentele filosofice contemporane

4. Dezvoltare Personală (lunar)
- Tehnici de meditație și introspecție
- Comunicare eficientă și leadership
- Echilibru între viața profesională și cea masonică

Toate sesiunile vor avea loc în prima duminică a lunii, ora 10:00, în sala de studiu a lojei. Prezența este obligatorie pentru ucenici și însoțitori, și recomandată pentru maeștri.

Materiale de studiu și bibliografia completă vor fi puse la dispoziție pe platforma educațională online a lojei.
        ''',
        summary: 'Prezentarea programului educațional complet pentru anul 2026, cu patru direcții de studiu pentru membrii lojei.',
        imageUrl: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=800',
        author: 'Comisia de Educație',
        publishedAt: DateTime.now().subtract(const Duration(days: 32)),
        category: 'Educație',
        source: 'Loja R.L. 126 C.T.',
        views: 267,
        tags: ['Educație', 'Program', 'Studii'],
      ),
      NewsEntity(
        id: '11',
        title: 'Simbolismul Ciocanului și Daltei',
        content: '''
Ciocanul și dalta sunt două dintre cele mai recunoscute simboluri masonice, reprezentând instrumentele fundamentale ale lucrării interioare pe care fiecare mason trebuie să o întreprindă.

Ciocanul simbolizează voința, forța activă care pune în mișcare schimbarea. Este instrumentul autorității și al disciplinei, folosit pentru a modela piatra brută a personalității noastre. În mâinile Venerabilului Maestru, ciocanul dirijează lucrările lojei și menține ordinea și armonia.

Dalta reprezintă discernământul, capacitatea de a face distincții fine și de a îndepărta cu precizie ceea ce este imperfect sau inutil. Este instrumentul rafinării și al perfecționării continue.

Împreună, cele două instrumente simbolizează:
- Echilibrul între forță și finețe
- Necesitatea atât a acțiunii hotărâte, cât și a judecății precise
- Procesul continuu de auto-îmbunătățire
- Transformarea pietrului brute în piatră cubică perfectă

În practica zilnică, masonul folosește "ciocanul" voinței pentru a-și depăși limitările și "dalta" discernământului pentru a-și rafina caractarul și comportamentul.
        ''',
        summary: 'Explorarea simbolismului profund al ciocanului și daltei ca instrumente fundamentale ale lucrării masonice.',
        imageUrl: 'https://images.unsplash.com/photo-1590856029826-c7a73a4447f6?w=800',
        author: 'Fr. Symbolicus',
        publishedAt: DateTime.now().subtract(const Duration(days: 35)),
        category: 'Simbolistică',
        source: 'Biblioteca Masonică',
        views: 341,
        tags: ['Simboluri', 'Instrumente', 'Filosofie'],
      ),
      NewsEntity(
        id: '12',
        title: 'Raport Anual de Activitate 2025',
        content: '''
Dragă Frați,

Vă prezentăm raportul anual de activitate al lojei pentru anul 2025, un an bogat în realizări și evenimente memorabile.

Activități ritualice:
- 24 de ședințe ritualice lunare
- 4 ceremonii de inițiere (8 noi frați)
- 3 ceremonii de trecere la gradul de însoțitor
- 2 ceremonii de ridicare la gradul de maestru
- 2 instalări de oficiali

Evenimente culturale și educaționale:
- 12 conferințe și prezentări
- 6 workshop-uri de studiu
- 3 vizite inter-loje
- 2 participări la evenimente internaționale

Activități caritabile:
- 4 campanii caritabile majore
- 50.000 lei strânși pentru cauze sociale
- Parteneriate cu 5 ONG-uri locale
- 200 de copii și familii asistate direct

Dezvoltare organizațională:
- Renovarea completă a sălii de ritual
- Achiziția unei noi biblioteci masonice (500 de volume)
- Implementarea platformei online pentru membrii
- Creșterea numărului de membri cu 15%

Raportul complet, cu detalii financiare și statistici, va fi prezentat la Adunarea Generală.
        ''',
        summary: 'Raportul detaliat al activităților lojei pe parcursul anului 2025, incluzând ritualuri, educație și caritate.',
        imageUrl: 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=800',
        author: 'Secretarul Lojei',
        publishedAt: DateTime.now().subtract(const Duration(days: 40)),
        category: 'Anunțuri',
        source: 'Loja R.L. 126 C.T.',
        views: 312,
        tags: ['Raport', 'Activitate', '2025'],
      ),
    ];
  }
}
