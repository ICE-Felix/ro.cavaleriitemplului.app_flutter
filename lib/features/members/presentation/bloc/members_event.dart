import 'package:equatable/equatable.dart';

abstract class MembersEvent extends Equatable {
  const MembersEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllMembers extends MembersEvent {
  const LoadAllMembers();
}

class LoadImportantMembers extends MembersEvent {
  const LoadImportantMembers();
}

class LoadFavoriteMembers extends MembersEvent {
  const LoadFavoriteMembers();
}

class LoadMemberById extends MembersEvent {
  final String id;

  const LoadMemberById(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleFavorite extends MembersEvent {
  final String memberId;

  const ToggleFavorite(this.memberId);

  @override
  List<Object?> get props => [memberId];
}
