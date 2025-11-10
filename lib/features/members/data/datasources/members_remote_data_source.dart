import '../models/member_model.dart';

abstract class MembersRemoteDataSource {
  Future<List<MemberModel>> getMembers();
  Future<List<MemberModel>> getImportantMembers();
  Future<MemberModel> getMemberById(String id);
}

class MembersRemoteDataSourceImpl implements MembersRemoteDataSource {
  MembersRemoteDataSourceImpl();

  // Hardcoded members data
  static final List<MemberModel> _allMembers = [
    // Important Members
    MemberModel(
      id: '1',
      name: 'Nicolae Popescu',
      title: 'Maestru Venerabil',
      position: 'Respectabila Loja 126 Cavalerii Templului',
      description: 'Conducător al Respectabilei Loji 126 Cavalerii Templului, dedicat valorilor frăției și spiritualității.',
      phoneNumber: '+40 722 123 456',
      email: 'nicolae.popescu@ct126.ro',
      imageUrl: null,
      isImportant: true,
      orderDisplay: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MemberModel(
      id: '2',
      name: 'Ion Marinescu',
      title: 'Prim-Supraveghetor',
      position: 'Respectabila Loja 126 Cavalerii Templului',
      description: 'Responsabil cu coordonarea activităților și menținerea ordinii în lojă.',
      phoneNumber: '+40 722 234 567',
      email: 'ion.marinescu@ct126.ro',
      imageUrl: null,
      isImportant: true,
      orderDisplay: 2,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MemberModel(
      id: '3',
      name: 'Andrei Constantin',
      title: 'Al Doilea Supraveghetor',
      position: 'Respectabila Loja 126 Cavalerii Templului',
      description: 'Asistent al Primului Supraveghetor, implicat în organizarea evenimentelor.',
      phoneNumber: '+40 722 345 678',
      email: 'andrei.constantin@ct126.ro',
      imageUrl: null,
      isImportant: true,
      orderDisplay: 3,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MemberModel(
      id: '4',
      name: 'Gabriel Ionescu',
      title: 'Secretar',
      position: 'Respectabila Loja 126 Cavalerii Templului',
      description: 'Responsabil cu documentația și evidența activităților lojei.',
      phoneNumber: '+40 722 456 789',
      email: 'gabriel.ionescu@ct126.ro',
      imageUrl: null,
      isImportant: true,
      orderDisplay: 4,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MemberModel(
      id: '5',
      name: 'Mihai Dumitrescu',
      title: 'Vistiernic',
      position: 'Respectabila Loja 126 Cavalerii Templului',
      description: 'Administrator financiar al lojei, gestionează fondurile și contribuțiile.',
      phoneNumber: '+40 722 567 890',
      email: 'mihai.dumitrescu@ct126.ro',
      imageUrl: null,
      isImportant: true,
      orderDisplay: 5,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    // Regular Members
    MemberModel(
      id: '6',
      name: 'Alexandru Popa',
      title: null,
      position: 'Membru',
      description: 'Membru activ al lojei, participant la toate ceremoniile și activitățile.',
      phoneNumber: '+40 722 678 901',
      email: 'alexandru.popa@ct126.ro',
      imageUrl: null,
      isImportant: false,
      orderDisplay: 6,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MemberModel(
      id: '7',
      name: 'Cristian Stan',
      title: null,
      position: 'Membru',
      description: 'Dedicat studierii și aplicării învățăturilor masonice în viața cotidiană.',
      phoneNumber: '+40 722 789 012',
      email: 'cristian.stan@ct126.ro',
      imageUrl: null,
      isImportant: false,
      orderDisplay: 7,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MemberModel(
      id: '8',
      name: 'Vlad Munteanu',
      title: null,
      position: 'Membru',
      description: 'Membru devoted, contribuie activ la proiectele caritabile ale lojei.',
      phoneNumber: '+40 722 890 123',
      email: 'vlad.munteanu@ct126.ro',
      imageUrl: null,
      isImportant: false,
      orderDisplay: 8,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MemberModel(
      id: '9',
      name: 'Radu Gheorghe',
      title: null,
      position: 'Membru',
      description: 'Implicat în organizarea evenimentelor culturale și educaționale.',
      phoneNumber: null,
      email: 'radu.gheorghe@ct126.ro',
      imageUrl: null,
      isImportant: false,
      orderDisplay: 9,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    MemberModel(
      id: '10',
      name: 'Stefan Vasile',
      title: null,
      position: 'Membru',
      description: 'Membru recent, în proces de învățare și integrare în comunitate.',
      phoneNumber: '+40 722 012 345',
      email: null,
      imageUrl: null,
      isImportant: false,
      orderDisplay: 10,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  Future<List<MemberModel>> getMembers() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return all members sorted by order_display
    final members = List<MemberModel>.from(_allMembers);
    members.sort((a, b) => a.orderDisplay.compareTo(b.orderDisplay));
    return members;
  }

  @override
  Future<List<MemberModel>> getImportantMembers() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return only important members sorted by order_display
    final importantMembers = _allMembers
        .where((member) => member.isImportant)
        .toList();
    importantMembers.sort((a, b) => a.orderDisplay.compareTo(b.orderDisplay));
    return importantMembers;
  }

  @override
  Future<MemberModel> getMemberById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _allMembers.firstWhere((member) => member.id == id);
    } catch (e) {
      throw Exception('Member with id $id not found');
    }
  }
}
