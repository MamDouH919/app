class KidResponse {
  String id;
  String name;
  String birthDate;
  String religion;
  String photo;
  KidResponse({required this.id, required this.name, required this.birthDate, required this.religion, required this.photo});

  factory KidResponse.fromJson(Map<String, dynamic> json) {
    return KidResponse(
      id: json['id'].toString(),
      name: json['name'].toString(),
      birthDate: json['birthdate'].toString(),
      religion: json['religion'].toString(),
      photo: json['photo'].toString(),
    );
  }
}
