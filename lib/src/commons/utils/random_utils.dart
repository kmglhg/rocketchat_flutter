
import 'dart:math';

class RandomUtils {
  RandomUtils._();

  static String id({length = 17}) {
    Random r = Random();

    String text = '';
    String possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    for (int i = 0; i < length; i += 1) {
      text += possible[r.nextInt(possible.length)];
    }

    return text;
  }

}
