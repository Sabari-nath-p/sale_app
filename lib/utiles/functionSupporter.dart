StringtoFormate(String s) {
  return "${s[0]}${s.substring(1, s.length).toLowerCase()}";
}

String ToFixed(var value, {int decimal = 2}) {
  double val = double.parse(value.toString()).toDouble();
  if (val % 10 != 0) {
    return double.parse(value.toStringAsFixed(decimal)).toString();
  } else
    return double.parse(value.toString()).toString() + "0";
}
