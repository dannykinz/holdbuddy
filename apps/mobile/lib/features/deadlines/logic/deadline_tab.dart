import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/deadline_status.dart';

class DeadlineTab extends Notifier<DeadlineStatus> {
  static final provider = NotifierProvider<DeadlineTab, DeadlineStatus>(
    DeadlineTab.new,
  );
  @override
  DeadlineStatus build() => DeadlineStatus.upcoming;
  void select(DeadlineStatus status) => state = status;
}
