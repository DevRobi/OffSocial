// all the blacklisted packages (constantly changing list!)

library offsocial.globals;

List facebookPackageNames = ['com.facebook.katana', 'com.facebook.lite'];

List pinterestPackageNames = ['com.pinterest'];

List redditPackageNames = [
  'com.reddit.frontpage',
  'com.rubenmayayo.reddit',
  'com.onelouder.baconreader',
  'ml.docilealligator.infinityforreddit',
  'o.o.joey'
];

List instagramPackageNames = [
  'com.instagram.android',
  'com.instagram.lite',
  'com.instalike.instagram'
];

List twitterPackageNames = ['com.twitter.android'];

List tumblrPackageNames = ['com.tumblr'];

List twitchPackageNames = ['tv.twitch.android.app']; // bug

List tiktokPackageNames = [
  'com.zhiliaoapp.musically',
  'com.ss.android.ugc.trill',
  'com.ss.android.ugc.trill.tiktok'
];

List youtubePackageNames = [
  'com.google.android.youtube',
  'com.vanced.android.youtube',
  'org.schabi.newpipe'
];

List snapchatPackageNames = [
  'com.snapchat.android',
  'com.snapchat.android.wearable'
];

List imgurPackageNames = ['com.imgur.mobile', 'com.imgur.android'];

// final list containing everything above
List allPackageNames = facebookPackageNames +
    pinterestPackageNames +
    redditPackageNames +
    instagramPackageNames +
    twitterPackageNames +
    tumblrPackageNames +
    twitchPackageNames +
    tiktokPackageNames +
    youtubePackageNames +
    snapchatPackageNames +
    imgurPackageNames;
