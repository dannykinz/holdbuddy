import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlanChangeFailure extends Notifier<bool> {
  @override
  bool build() => false;
  void set(bool failed) => state = failed;
}
