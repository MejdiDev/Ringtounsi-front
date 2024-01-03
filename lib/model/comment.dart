class Comment {
  int? id; // Make id nullable if it can be null
  late int userId; // Use 'late' if you initialize it later
  late int coachId;
  late DateTime createdAt;
  late String comment;

  Comment({
    this.id,
    required this.userId, // Use the 'required' modifier
    required this.coachId,
    required this.createdAt,
    required this.comment,
    
  });

  // Factory method, toJson, and fromJson remain the same

  // Méthode pour créer une instance de User à partir d'une Map
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      userId: json['userId'],
      coachId: json['coachId'],
      createdAt: DateTime.parse(json['createdAt']),
      comment: json['comment'],
     
    );
  }

  // Méthode pour convertir l'instance de User en une Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'coachId': coachId,
      'createdAt': createdAt.toIso8601String(),
      'comment': comment,
      
    };
  }
}
