/// Model
class CounterModel {
  factory CounterModel() => _this ??= CounterModel._();
  CounterModel._() {
    _counter = 0;
  }
  static CounterModel? _this;
  late int _counter;

  String get data => '$_counter';

  void onPressed() => _counter++;
}
