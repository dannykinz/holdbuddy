import 'deadline_category.dart';
import 'deadline_status.dart';

class Deadline {
  Deadline({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.dueAt,
    required this.status,
    List<int> stops = const [],
    List<int> disabledStops = const [],
    this.doneAt,
  }) : stops = List.unmodifiable(stops),
       disabledStops = List.unmodifiable(disabledStops);
  final String id;
  final String userId;
  final String title;
  final DeadlineCategory category;
  final DateTime dueAt;
  final DeadlineStatus status;
  final List<int> stops;
  final List<int> disabledStops;
  final DateTime? doneAt;

  Deadline copyWith({
    String? id,
    String? userId,
    String? title,
    DeadlineCategory? category,
    DateTime? dueAt,
    DeadlineStatus? status,
    List<int>? stops,
    List<int>? disabledStops,
    DateTime? doneAt,
  }) => Deadline(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    category: category ?? this.category,
    dueAt: dueAt ?? this.dueAt,
    status: status ?? this.status,
    stops: stops ?? this.stops,
    disabledStops: disabledStops ?? this.disabledStops,
    doneAt: doneAt ?? this.doneAt,
  );
}
