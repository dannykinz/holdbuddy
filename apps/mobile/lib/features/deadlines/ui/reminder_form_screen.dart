import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_field.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../domain/deadline.dart';
import '../domain/deadline_category.dart';
import '../domain/deadline_schedule.dart';
import '../logic/deadline_controller.dart';
import 'widgets/deadline_calendar.dart';
import 'widgets/deadline_category_picker.dart';
import 'widgets/deadline_failure_notice.dart';
import 'widgets/deadline_schedule_preview.dart';

class ReminderFormScreen extends ConsumerStatefulWidget {
  const ReminderFormScreen({super.key, this.existing});
  final Deadline? existing;
  @override
  ConsumerState<ReminderFormScreen> createState() => _ReminderFormScreenState();
}

class _ReminderFormScreenState extends ConsumerState<ReminderFormScreen> {
  final _form = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.existing?.title ?? '');
  late DateTime _due =
      widget.existing?.dueAt ?? DeadlineSchedule.day(DateTime.now());
  late DeadlineCategory _category =
      widget.existing?.category ?? DeadlineCategory.school;
  late List<int> _stops =
      widget.existing?.stops ?? DeadlineSchedule.offsets(_due, DateTime.now());
  late List<int> _disabled = List.of(widget.existing?.disabledStops ?? []);
  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final state = ref.watch(DeadlineController.provider);
    return Form(
      key: _form,
      child: HbPageScaffold(
        topBar: const HbPageHeader(fallback: AppRoute.reminders),
        content: [
          HbHeading(
            title: widget.existing == null ? l.deadlineNew : l.deadlineEdit,
          ),
          HbField(
            label: l.deadlineWhatDue,
            controller: _title,
            enabled: !state.isLoading,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'[\x00-\x1F\x7F]')),
            ],
            validator: (value) =>
                (value ?? '').trim().isEmpty ? l.deadlineTitleRequired : null,
          ),
          DeadlineCategoryPicker(
            selected: _category,
            onSelected: (value) => setState(() => _category = value),
          ),
          DeadlineCalendar(selected: _due, onSelected: _chooseDate),
          DeadlineSchedulePreview(
            dueAt: _due,
            stops: _stops,
            disabled: _disabled,
            onToggle: _toggleStop,
          ),
          if (DeadlineSchedule.daysBetween(_due, DateTime.now()) < 0)
            Text(l.deadlinePastDate),
          if (state.hasError) const DeadlineFailureNotice(),
        ],
        actions: [
          HbButton(
            label: l.deadlineSave,
            loading: state.isLoading,
            onPressed: state.isLoading ? null : _save,
          ),
        ],
        footnote: HbPreviewNote(text: l.deadlinePreview),
      ),
    );
  }

  void _chooseDate(DateTime value) => setState(() {
    _due = value;
    _stops = DeadlineSchedule.offsets(value, DateTime.now());
    _disabled = [];
  });
  void _toggleStop(int offset) => setState(() {
    _disabled = _disabled.contains(offset)
        ? _disabled.where((item) => item != offset).toList()
        : [..._disabled, offset];
  });
  Future<void> _save() async {
    if (_form.currentState?.validate() != true ||
        DeadlineSchedule.daysBetween(_due, DateTime.now()) < 0)
      return;
    final saved = await ref
        .read(DeadlineController.provider.notifier)
        .save(
          title: _title.text,
          category: _category,
          dueAt: _due,
          stops: _stops,
          disabledStops: _disabled,
          existing: widget.existing,
        );
    if (!mounted || saved == null) return;
    if (widget.existing != null && context.canPop()) {
      context.pop();
      return;
    }
    context.pushReplacementNamed(AppRoute.reminderDetail.name, extra: saved.id);
  }
}
