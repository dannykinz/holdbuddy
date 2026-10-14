class Learner {
  const Learner({
    required this.id,
    required this.displayName,
    required this.studying,
    this.email = '',
    this.avatar = '',
  });

  final String id;
  final String displayName;
  final String studying;
  final String email;
  final String avatar;

  Learner copyWith({
    String? id,
    String? displayName,
    String? studying,
    String? email,
    String? avatar,
  }) => Learner(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    studying: studying ?? this.studying,
    email: email ?? this.email,
    avatar: avatar ?? this.avatar,
  );
}
