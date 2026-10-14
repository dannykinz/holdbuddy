import '../../features/contract/domain/contract_draft.dart';
import '../../features/contract/domain/contract_repository.dart';

/// In-memory contract preview. Nothing is persisted and no invite is sent.
class FakeContractRepository implements ContractRepository {
  ContractDraft _draft = ContractDraft(
    title: 'Learning Dart',
    totalUnits: 24,
    unitName: 'Chapters',
    days: const [1, 3, 5],
    startMinute: 20 * 60,
    sessionMinutes: 45,
    unitsPerSession: 1,
    message:
        'Elvis, I missed my Dart session. Ask me when I’m doing the next one.',
    witnessName: 'Elvis',
    witnessContact: 'elvis@example.com',
    startDate: DateTime(2026, 10, 5),
  );

  ContractDraft? committedDraft;
  @override
  ContractDraft get draft => _draft;
  @override
  void saveDraft(ContractDraft draft) => _draft = draft;
  @override
  void commit(ContractDraft draft) => committedDraft = _draft = draft;

  @override
  DateTime estimateFinish(ContractDraft draft) {
    if (!draft.scopeValid || !draft.rhythmValid) return draft.startDate;
    final days = [...draft.days]..sort();
    final sessions = (draft.totalUnits / draft.unitsPerSession).ceil();
    final weeks = (sessions - 1) ~/ days.length;
    final weekday = days[(sessions - 1) % days.length];
    return draft.startDate.add(Duration(days: weeks * 7 + weekday - 1));
  }
}
