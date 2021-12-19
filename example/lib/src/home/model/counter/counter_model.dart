/// Model

class CounterModel {
  factory CounterModel({bool? useDouble}) =>
      _this ??= CounterModel._(useDouble);
  CounterModel._(bool? useDouble) {
    _useDouble = useDouble ?? false;
    _integer = 0;
    _double = 0;
  }
  static CounterModel? _this;
  bool _useDouble = false;
  late int _integer;
  late double _double;

  String get data => _useDouble ? _double.toStringAsFixed(2) : '$_integer';

  void onPressed() => _useDouble ? _double = _double + 0.01 : _integer++;
}

// class CounterModel {
//   int _counter = 0;
//
//   String get data => '$_counter';
//
//   void onPressed() => _counter++;
// }

// class CounterModel {
//   double _counter = 6.00;
//
//   String get data => _counter.toStringAsFixed(2);
//
//   void onPressed() => _counter = _counter + 0.01;
// }
