class ProjectNote {
  final String id;
  final String text;
  final DateTime taskAt;
  final DateTime notifyAt;
  final bool done;

  ProjectNote({
    required this.id,
    required this.text,
    required this.taskAt,
    required this.notifyAt,
    required this.done,
  });

  factory ProjectNote.fromJson(Map<String, dynamic> json) => ProjectNote(
        id: json['id'] as String,
        text: json['text'] as String,
        taskAt: DateTime.parse(json['taskAt'] as String).toLocal(),
        notifyAt: DateTime.parse(json['notifyAt'] as String).toLocal(),
        done: json['done'] as bool,
      );
}
