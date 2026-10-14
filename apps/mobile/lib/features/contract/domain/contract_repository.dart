import 'contract_draft.dart';

abstract interface class ContractRepository {
  ContractDraft get draft;
  DateTime estimateFinish(ContractDraft draft);
  void saveDraft(ContractDraft draft);
  void commit(ContractDraft draft);
}
