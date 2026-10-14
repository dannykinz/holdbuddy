import '../../contract/domain/study_contract.dart';
import 'plan_status.dart';

class StudyPlan {
  StudyPlan({
    required this.id,
    required this.userId,
    required this.title,
    required this.totalUnits,
    required this.unitName,
    required this.unitsDone,
    required this.startDate,
    required this.targetDate,
    required this.status,
    required this.contract,
    required List<String> witnessIds,
  }) : witnessIds = List.unmodifiable(witnessIds);

  final String id;
  final String userId;
  final String title;
  final int totalUnits;
  final String unitName;
  final int unitsDone;
  final DateTime startDate;
  final DateTime targetDate;
  final PlanStatus status;
  final StudyContract contract;
  final List<String> witnessIds;

  StudyPlan copyWith({
    String? id,
    String? userId,
    String? title,
    int? totalUnits,
    String? unitName,
    int? unitsDone,
    DateTime? startDate,
    DateTime? targetDate,
    PlanStatus? status,
    StudyContract? contract,
    List<String>? witnessIds,
  }) => StudyPlan(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    totalUnits: totalUnits ?? this.totalUnits,
    unitName: unitName ?? this.unitName,
    unitsDone: unitsDone ?? this.unitsDone,
    startDate: startDate ?? this.startDate,
    targetDate: targetDate ?? this.targetDate,
    status: status ?? this.status,
    contract: contract ?? this.contract,
    witnessIds: witnessIds ?? this.witnessIds,
  );
}
