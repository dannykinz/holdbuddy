import '../../features/plan/domain/plan_chapter.dart';
import '../../features/plan/domain/plan_view.dart';

/// Fixed chapter fixtures for the original Figma plan.
abstract final class FakePlanChapters {
  static const _names = [
    'Introduction',
    'Variables & types',
    'Operators',
    'Collections basics',
    'Control flow',
    'Functions',
    'Futures & async',
    'Streams',
    'Error handling',
    'Classes',
    'Constructors',
    'Inheritance',
    'Mixins',
    'Extensions',
    'Generics',
    'Collections',
    'Patterns',
    'Records',
    'Libraries',
    'Packages',
    'Testing',
    'Tooling',
    'Interoperability',
    'Final review',
  ];
  static const _days = [
    5,
    7,
    9,
    12,
    14,
    16,
    19,
    21,
    23,
    26,
    28,
    30,
    2,
    4,
    6,
    9,
    11,
    13,
    16,
    18,
    20,
    23,
    25,
    27,
  ];
  static const _normal = (
    [
      'Operators',
      'Collections',
      'Functions',
      'Futures & async',
      'Streams',
      'Error handling',
      'Packages',
    ],
    [9, 12, 16, 21, 23, 25, 28],
    4,
    10,
  );
  static const _paths = {
    PlanView.history: (
      [
        'Introduction',
        'Variables & types',
        'Control flow',
        'Operators',
        'Collections',
        'Functions',
        'Futures & async',
      ],
      [5, 7, 9, 9, 12, 16, 21],
      1,
      10,
    ),
    PlanView.complete: (
      [
        'Testing',
        'Isolates',
        'FFI',
        'Web',
        'CLI tools',
        'Publishing',
        'Finish line',
      ],
      [12, 14, 17, 19, 21, 22, 22],
      19,
      11,
    ),
  };
  static List<PlanChapter> chapters(PlanView view) {
    if (view == PlanView.firstWeek)
      return List.generate(
        _names.length,
        (index) => PlanChapter(
          number: index + 1,
          name: _names[index],
          date: DateTime(2026, index < 12 ? 10 : 11, _days[index], 20),
        ),
      );
    final (names, days, first, month) = _paths[view] ?? _normal;
    return List.generate(
      names.length,
      (index) => PlanChapter(
        number: view == PlanView.complete && index == 6 ? 0 : first + index,
        name: names[index],
        date: DateTime(2024, month, days[index], 20),
      ),
    );
  }
}
