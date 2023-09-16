StringtoFormate(String s) {
  return "${s[0]}${s.substring(1, s.length).toLowerCase()}";
}

String ToFixed(var value, {int decimal = 2}) {
  return double.parse(value.toStringAsFixed(decimal)).toString();
}
