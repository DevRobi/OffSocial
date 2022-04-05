/// FeedbackForm is a data class which stores data fields of Feedback.
class FeedbackForm {
  String name;
  String version;
  String totalusage;

  FeedbackForm(this.name, this.version, this.totalusage);

  factory FeedbackForm.fromJson(dynamic json) {
    return FeedbackForm(
      "${json['name']}",
      "${json['version']}",
      "${json['totalusage']}",
    );
  }

  // Method to make GET parameters.
  Map toJson() => {'name': name, 'version': version, 'totalusage': totalusage};
}
