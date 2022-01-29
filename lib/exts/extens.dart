/// Округлит координату вида 123.1234567890123 к виду 123.12345
extension RoundCoordToDouble on double {
  double roundCoordinate() {
    const double _round = 100000;
    double _newVal = this;
    _newVal = (this * _round).roundToDouble() / _round;

    return _newVal;
  }
}
