StringtoFormate(String s) {
  return "${s[0]}${s.substring(1, s.length).toLowerCase()}";
}

String ToFixed(var value, {int decimal = 2}) {
//  ////print(value);
  if (value != null) {
    double val = double.parse(value.toString()).toDouble();

    if (val % 10 != 0) {
      return double.parse(val.toStringAsFixed(decimal)).toString() + "0";
    } else
      return double.parse(value.toString()).toString() + "0";
  }
  return "0";
}
