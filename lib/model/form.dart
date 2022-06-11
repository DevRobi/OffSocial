/// FeedbackForm is a data class which stores data fields of Feedback.
class FeedbackForm {
  String deviceId;
  String version;
  String score;
  String facebook;
  String instagram;
  String pinterest;
  String reddit;
  String snapchat;
  String tiktok;
  String tumblr;
  String twitch;
  String twitter;
  String youtube;
  String dayindex;
  String timestamp;
  String allowance;

  FeedbackForm(
      this.deviceId,
      this.version,
      this.score,
      this.facebook,
      this.instagram,
      this.pinterest,
      this.reddit,
      this.snapchat,
      this.tiktok,
      this.tumblr,
      this.twitch,
      this.twitter,
      this.youtube,
      this.dayindex,
      this.timestamp,
      this.allowance);

  factory FeedbackForm.fromJson(dynamic json) {
    return FeedbackForm(
      "${json['deviceId']}",
      "${json['version']}",
      "${json['score']}",
      "${json['facebook']}",
      "${json['instagram']}",
      "${json['pinterest']}",
      "${json['reddit']}",
      "${json['snapchat']}",
      "${json['tiktok']}",
      "${json['tumblr']}",
      "${json['twitch']}",
      "${json['twitter']}",
      "${json['youtube']}",
      "${json['dayindex']}",
      "${json['timestamp']}",
      "${json['allowance']}",
    );
  }

  // Method to make GET parameters.
  Map toJson() => {
        'deviceId': deviceId,
        'version': version,
        'score': score,
        'facebook': facebook,
        'instagram': instagram,
        'pinterest': pinterest,
        'reddit': reddit,
        'snapchat': snapchat,
        'tiktok': tiktok,
        'tumblr': tumblr,
        'twitch': twitch,
        'twitter': twitter,
        'youtube': youtube,
        'dayindex': dayindex,
        'timestamp': timestamp,
        'allowance': allowance
      };
}
