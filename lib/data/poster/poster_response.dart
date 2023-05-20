class PosterResponse {
  String id;
  String type;
  String posterPic;
  String title;
  String acceptBtn;
  String rejectBtn;
  String details;
  String classes;
  String rejectBtnState;
  String courseId;
  String clevelTitle;
  String nlevelTitle;
  String minAge;
  String maxAge;
  String userPosterId;

  PosterResponse(
      {required this.id,
      required this.type,
      required this.posterPic,
      required this.title,
      required this.acceptBtn,
      required this.rejectBtn,
      required this.details,
      required this.classes,
      required this.rejectBtnState,
      required this.courseId,
      required this.clevelTitle,
      required this.nlevelTitle,
      required this.minAge,
      required this.maxAge,
      required this.userPosterId});

  factory PosterResponse.fromJson(Map<String, dynamic> json) {
    return PosterResponse(
      id: json['id'].toString(),
      type: json['type'].toString(),
      posterPic: json['poster_pic'].toString(),
      title: json['title'].toString(),
      acceptBtn: json['accept_btn'].toString(),
      rejectBtn: json['reject_btn'].toString(),
      details: json['details'].toString(),
      classes: json['classes'].toString(),
      rejectBtnState: json['reject_btn_state']!.toString(),
      courseId: json['course_id']!.toString(),
      clevelTitle: json['clevel_title']!.toString(),
      nlevelTitle: json['nlevel_title']!.toString(),
      minAge: json['min_age']!.toString(),
      maxAge: json['max_age']!.toString(),
      userPosterId: json['user_poster_id']!.toString(),
    );
  }
}
