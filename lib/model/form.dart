/// FeedbackForm is a data class which stores data fields of Feedback.
class FeedbackForm {
  String name;
  String version;
  String discord;
  

  FeedbackForm(this.name, this.version, this.discord);

  factory FeedbackForm.fromJson(dynamic json) {
    return FeedbackForm("${json['name']}", "${json['version']}",
        "${json['discord']}",);
  }

  // Method to make GET parameters.
  Map toJson() => {
        'name': name,
        'version': version,
        'discord': discord
      };
}

