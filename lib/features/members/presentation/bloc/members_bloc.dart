import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/members_repository.dart';
import 'members_event.dart';
import 'members_state.dart';

class MembersBloc extends Bloc<MembersEvent, MembersState> {
  final MembersRepository repository;

  MembersBloc({required this.repository}) : super(const MembersInitial()) {
    on<LoadAllMembers>(_onLoadAllMembers);
    on<LoadImportantMembers>(_onLoadImportantMembers);
    on<LoadFavoriteMembers>(_onLoadFavoriteMembers);
    on<LoadMemberById>(_onLoadMemberById);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<Set<String>> _getFavoriteIds() async {
    final favoriteMembers = await repository.getFavoriteMembers();
    return favoriteMembers.map((m) => m.id).toSet();
  }

  Future<void> _onLoadAllMembers(
    LoadAllMembers event,
    Emitter<MembersState> emit,
  ) async {
    emit(const MembersLoading());
    try {
      final members = await repository.getMembers();
      final favoriteIds = await _getFavoriteIds();
      emit(MembersLoaded(members, favoriteIds: favoriteIds));
    } catch (e) {
      emit(MembersError(e.toString()));
    }
  }

  Future<void> _onLoadImportantMembers(
    LoadImportantMembers event,
    Emitter<MembersState> emit,
  ) async {
    emit(const MembersLoading());
    try {
      final members = await repository.getImportantMembers();
      final favoriteIds = await _getFavoriteIds();
      emit(MembersLoaded(members, favoriteIds: favoriteIds));
    } catch (e) {
      emit(MembersError(e.toString()));
    }
  }

  Future<void> _onLoadFavoriteMembers(
    LoadFavoriteMembers event,
    Emitter<MembersState> emit,
  ) async {
    emit(const MembersLoading());
    try {
      final members = await repository.getFavoriteMembers();
      final favoriteIds = await _getFavoriteIds();
      emit(MembersLoaded(members, favoriteIds: favoriteIds));
    } catch (e) {
      emit(MembersError(e.toString()));
    }
  }

  Future<void> _onLoadMemberById(
    LoadMemberById event,
    Emitter<MembersState> emit,
  ) async {
    emit(const MembersLoading());
    try {
      final member = await repository.getMemberById(event.id);
      emit(MemberDetailsLoaded(member));
    } catch (e) {
      emit(MembersError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<MembersState> emit,
  ) async {
    final currentState = state;
    if (currentState is MembersLoaded) {
      try {
        await repository.toggleFavorite(event.memberId);
        final favoriteIds = await _getFavoriteIds();
        emit(currentState.copyWith(favoriteIds: favoriteIds));
      } catch (e) {
        // Silently fail for favorite toggle
      }
    }
  }
}
