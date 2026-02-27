import 'package:shared_preferences/shared_preferences.dart';
import '../members/data/models/member_model.dart';
import '../members/domain/repositories/members_repository.dart';

class BirthdayPopupService {
  static const _dismissedDateKey = 'birthday_popup_dismissed_date';

  final SharedPreferences _prefs;
  final MembersRepository _membersRepository;

  BirthdayPopupService({
    required SharedPreferences prefs,
    required MembersRepository membersRepository,
  })  : _prefs = prefs,
        _membersRepository = membersRepository;

  /// Returns birthday members if popup should be shown, null otherwise.
  Future<List<MemberModel>?> checkAndGetBirthdays() async {
    final today = DateTime.now().toIso8601String().split('T').first;
    final dismissedDate = _prefs.getString(_dismissedDateKey);

    if (dismissedDate == today) {
      return null;
    }

    try {
      final birthdays = await _membersRepository.getTodayBirthdays();
      if (birthdays.isEmpty) return null;
      return birthdays;
    } catch (_) {
      return null;
    }
  }

  Future<void> dismissForToday() async {
    final today = DateTime.now().toIso8601String().split('T').first;
    await _prefs.setString(_dismissedDateKey, today);
  }
}
