import 'package:share_plus/share_plus.dart';

class ShareUtil {
  static Future<void> shareMeal({required String title, required String? youtubeUrl}) async {
    final String text = 'Check out this recipe: $title\n\nWatch the video: $youtubeUrl';
    await Share.share(text);
  }
}
