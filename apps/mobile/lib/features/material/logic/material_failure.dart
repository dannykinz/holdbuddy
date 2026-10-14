import 'package:flutter_riverpod/flutter_riverpod.dart';

class MaterialFailure extends Notifier<bool> {
  static final provider = NotifierProvider<MaterialFailure, bool>(
    MaterialFailure.new,
  );
  @override
  bool build() => false;
  void set(bool value) => state = value;
}
