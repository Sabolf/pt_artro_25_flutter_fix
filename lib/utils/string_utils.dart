import 'package:html/parser.dart' show parse;
import 'package:html_unescape/html_unescape.dart';

String removeHtmlTags(String htmlString) {
  // First, unescape any HTML entities like &amp;
  final unescapedString = HtmlUnescape().convert(htmlString);

  // Then, parse the unescaped string as HTML and extract the text
  final document = parse(unescapedString);
  final String parsedString = parse(document.body?.text).documentElement!.text;

  return parsedString;
}