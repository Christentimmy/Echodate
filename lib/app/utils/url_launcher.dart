import 'package:url_launcher/url_launcher.dart';

Future<void> urlLauncher(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.inAppWebView); // Opens in an external browser
  } else {
    throw 'Could not launch $url';
  }
}
