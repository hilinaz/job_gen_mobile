class HtmlParser {
  static String parse(String htmlString) {
    String text = htmlString;

    // Replace <br> and <br/> with newlines
    text = text.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');

    // Replace list items with bullet points
    text = text.replaceAllMapped(
      RegExp(r'<li[^>]*>(.*?)<\/li>', caseSensitive: false, dotAll: true),
      (match) => "• ${match.group(1)?.trim()}\n",
    );

    // Replace paragraphs with newlines
    text = text.replaceAllMapped(
      RegExp(r'<p[^>]*>(.*?)<\/p>', caseSensitive: false, dotAll: true),
      (match) => "\n${match.group(1)?.trim()}\n",
    );

    // Replace headers with uppercase text
    text = text.replaceAllMapped(
      RegExp(
        r'<h[1-6][^>]*>(.*?)<\/h[1-6]>',
        caseSensitive: false,
        dotAll: true,
      ),
      (match) => "\n${match.group(1)?.toUpperCase()}\n",
    );

    // Remove all other HTML tags
    text = text.replaceAll(RegExp(r'<[^>]+>'), '');

    // Decode basic HTML entities
    text = text.replaceAll('&nbsp;', ' ');
    text = text.replaceAll('&amp;', '&');
    text = text.replaceAll('&lt;', '<');
    text = text.replaceAll('&gt;', '>');
    text = text.replaceAll('&quot;', '"');
    text = text.replaceAll('&#39;', "'");

    // Trim extra spaces
    return text.trim();
  }
}
