class Request {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String status; // Pending, Approved, Declined, In Progress, Resolved
  final DateTime createdAt;

  Request({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.status = 'Pending',
    required this.createdAt,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
