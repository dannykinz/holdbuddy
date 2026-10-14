import '../../material/domain/linked_material.dart';

class ContractDraft {
  ContractDraft({
    required this.title,
    required this.totalUnits,
    required this.unitName,
    required List<int> days,
    required this.startMinute,
    required this.sessionMinutes,
    required this.unitsPerSession,
    required this.message,
    required this.witnessName,
    required this.witnessContact,
    required this.startDate,
    this.material,
    this.withoutWitness = false,
  }) : days = List.unmodifiable(days);

  final String title;
  final int totalUnits;
  final String unitName;
  final List<int> days;
  final int startMinute;
  final int sessionMinutes;
  final int unitsPerSession;
  final String message;
  final String witnessName;
  final String witnessContact;
  final DateTime startDate;
  final LinkedMaterial? material;
  final bool withoutWitness;

  bool get scopeValid =>
      title.trim().isNotEmpty && totalUnits > 0 && unitName.trim().isNotEmpty;
  bool get rhythmValid =>
      days.isNotEmpty &&
      startMinute >= 0 &&
      startMinute < 1440 &&
      sessionMinutes > 0 &&
      unitsPerSession > 0;
  bool get canCommit => scopeValid && rhythmValid && message.trim().isNotEmpty;

  ContractDraft copyWith({
    String? title,
    int? totalUnits,
    String? unitName,
    List<int>? days,
    int? startMinute,
    int? sessionMinutes,
    int? unitsPerSession,
    String? message,
    String? witnessName,
    String? witnessContact,
    LinkedMaterial? material,
    bool clearMaterial = false,
    bool? withoutWitness,
  }) => ContractDraft(
    title: title ?? this.title,
    totalUnits: totalUnits ?? this.totalUnits,
    unitName: unitName ?? this.unitName,
    days: days ?? this.days,
    startMinute: startMinute ?? this.startMinute,
    sessionMinutes: sessionMinutes ?? this.sessionMinutes,
    unitsPerSession: unitsPerSession ?? this.unitsPerSession,
    message: message ?? this.message,
    witnessName: witnessName ?? this.witnessName,
    witnessContact: witnessContact ?? this.witnessContact,
    startDate: startDate,
    material: clearMaterial ? null : material ?? this.material,
    withoutWitness: withoutWitness ?? this.withoutWitness,
  );
}
