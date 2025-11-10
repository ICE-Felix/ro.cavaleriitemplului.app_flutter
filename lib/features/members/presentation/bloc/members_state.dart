import 'package:equatable/equatable.dart';
import '../../data/models/member_model.dart';

abstract class MembersState extends Equatable {
  const MembersState();

  @override
  List<Object?> get props => [];
}

class MembersInitial extends MembersState {
  const MembersInitial();
}

class MembersLoading extends MembersState {
  const MembersLoading();
}

class MembersLoaded extends MembersState {
  final List<MemberModel> members;
  final Set<String> favoriteIds;

  const MembersLoaded(this.members, {this.favoriteIds = const {}});

  @override
  List<Object?> get props => [members, favoriteIds];

  MembersLoaded copyWith({
    List<MemberModel>? members,
    Set<String>? favoriteIds,
  }) {
    return MembersLoaded(
      members ?? this.members,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}

class MemberDetailsLoaded extends MembersState {
  final MemberModel member;

  const MemberDetailsLoaded(this.member);

  @override
  List<Object?> get props => [member];
}

class MembersError extends MembersState {
  final String message;

  const MembersError(this.message);

  @override
  List<Object?> get props => [message];
}
