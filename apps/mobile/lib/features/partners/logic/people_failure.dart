import 'package:flutter_riverpod/flutter_riverpod.dart';

class PeopleFailure extends Notifier<bool> {
  static final provider = NotifierProvider<PeopleFailure, bool>(
    PeopleFailure.new,
  );
  @override
  bool build() => false;
  void set(bool value) => state = value;
}
