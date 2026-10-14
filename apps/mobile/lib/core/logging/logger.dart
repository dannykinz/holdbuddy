import 'dart:developer' as developer;

void logError(Object error, StackTrace stackTrace) => developer.log(
  'Holdbuddy error',
  name: 'holdbuddy',
  level: 1000,
  error: error,
  stackTrace: stackTrace,
);
