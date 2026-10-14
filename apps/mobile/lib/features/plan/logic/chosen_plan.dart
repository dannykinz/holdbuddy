import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChosenPlan extends Notifier<String?> {
  static final provider = NotifierProvider<ChosenPlan, String?>(ChosenPlan.new);
  @override
  String? build() => null;
  void select(String id) => state = id;
}
