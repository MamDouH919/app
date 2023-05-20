class CoursesResponse {
  String id;
  String title;
  String description;
  String minAge;
  String maxAge;
  String photo;

  CoursesResponse(
      {required this.id,
        required this.title,
        required this.description,
        required this.minAge,
        required this.maxAge,
        required this.photo});

  factory CoursesResponse.fromJson(Map<String, dynamic> json) {
    return CoursesResponse(
      id: json['id'].toString(),
      title: json['title'].toString(),
      description: json['description'].toString(),
      minAge: json['min_age'].toString(),
      maxAge: json['max_age'].toString(),
      photo: json['photo'].toString(),
    );
  }
}
