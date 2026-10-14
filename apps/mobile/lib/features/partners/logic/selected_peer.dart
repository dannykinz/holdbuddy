import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedPeer extends Notifier<String> {
  static final provider = NotifierProvider<SelectedPeer, String>(
    SelectedPeer.new,
  );
  @override
  String build() => 'elvis';
  void select(String id) => state = id;
}
