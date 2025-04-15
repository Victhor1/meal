import 'package:url_launcher/url_launcher_string.dart';

class UrlLauncherUtil {
  static Future<void> launchYoutube(String videoUrl) async {
    final String url = videoUrl;
    if (!await launchUrlString(url)) {
      throw Exception('No se pudo abrir el video de YouTube');
    }
  }

  static Future<void> launchUrl(String urlString) async {
    if (!await launchUrlString(urlString)) {
      throw Exception('No se pudo abrir la URL');
    }
  }
}
