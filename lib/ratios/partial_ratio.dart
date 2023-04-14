import '../applicable.dart';
import '../diffutils/diff_utils.dart';

import 'dart:math';

class PartialRatio implements Applicable {
  @override
  int apply(String s1, String s2) {
    List<int> shorter;
    List<int> longer;

    if (s1.length < s2.length) {
      shorter = s1.runes.toList();
      longer = s2.runes.toList();
    } else {
      shorter = s2.runes.toList();
      longer = s1.runes.toList();
    }

    var matchingBlocks = DiffUtils.getMatchingBlocks(shorter, longer);

    var scores = <double>[];

    for (var mb in matchingBlocks) {
      var dist = mb.dpos! - mb.spos!;

      var longStart = dist > 0 ? dist : 0;
      var longEnd = longStart + shorter.length;

      if (longEnd > longer.length) longEnd = longer.length;

      var longSubstr = longer.sublist(longStart, longEnd);

      var ratio = DiffUtils.getRatio(shorter, longSubstr);

      if (ratio.isNaN) {
        continue;
      }

      if (ratio > 0.995) {
        return 100;
      } else {
        scores.add(ratio);
      }
    }

    return scores.isEmpty ? 0 : (100 * scores.reduce(max)).round();
  }
}
