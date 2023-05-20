class JobResponse {
  String id;
  String startTime;
  String endTime;
  String fullTime;
  String partTime;
  String date;
  String salary;
  String state;
  String title;
  String description;
  String skills;
  String branchName;
  String branchId;
  String jobId;

  JobResponse(
      {required this.id,
      required this.startTime,
      required this.endTime,
      required this.fullTime,
      required this.partTime,
      required this.date,
      required this.salary,
      required this.state,
      required this.title,
      required this.description,
      required this.skills,
      required this.branchName,
      required this.branchId,
      required this.jobId});

  factory JobResponse.fromJson(Map<String, dynamic> json) {
    return JobResponse(
      id: json['id'].toString(),
      startTime: json['start_time'].toString(),
      endTime: json['end_time'].toString(),
      fullTime: json['full_time'].toString(),
      partTime: json['part_time'].toString(),
      date: json['date'].toString(),
      salary: json['salary'].toString(),
      state: json['state'].toString(),
      title: json['title'].toString(),
      description: json['description'].toString(),
      skills: json['skills']!.toString(),
      branchName: json['branch_name'].toString(),
      branchId: json['branch_id'].toString(),
      jobId: json['job_id'].toString(),
    );
  }
}
