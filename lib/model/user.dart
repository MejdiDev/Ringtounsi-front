class User {
  int? id;
  late String nom;
  late String prenom;
  late String email;
  late String password;
  late DateTime dateInscription;
  late String role;
  late String status;
  late String token;

  var bio;
  var adresse;
  var grade;
  var numTel;

  // Add this field to store the auth token

  User({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    required this.dateInscription,
    required this.role,
    required this.status,
    required this.token,
    bio,
    adresse,
    numTel,
    grade
  });

  factory User.fromJson(Map<String, dynamic> json) {
      print('JSON Response: $json'); // Add this line for debugging

    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      password: json['token'] ?? '',
       dateInscription: DateTime.parse(json['date_inscription']),
      role: json['role'],
      status: json['status'],
      bio: json["bio"],
      adresse: json["adresse"],
      numTel: json["numTel"],
      grade: json["grade"],
      token: json["token"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'password': password,
      'date_inscription': dateInscription.toIso8601String(),
      'role': role,
      'bio': bio,
      'grade': grade,
      'numTel': numTel,
      'adresse': adresse,
      
// Include the auth token in the JSON representation
    };
  }
}
