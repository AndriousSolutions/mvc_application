// Copyright 2019 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by a Apache License, Version 2.0.
// The main directory contains that LICENSE file.

import 'package:mvc_application/view.dart';

/// A Spinner listing the available Locales.
class ISOSpinner extends StatefulWidget {
  const ISOSpinner({
    Key? key,
    this.initialItem,
    this.locale,
    required this.supportedLocales,
    required this.onSelectedItemChanged,
  }) : super(key: key);
  final Locale? locale;
  final int? initialItem;
  final List<Locale> supportedLocales;
  final Future<void> Function(int index) onSelectedItemChanged;

  @override
  State createState() => _SpinnerState();
}

class _SpinnerState extends State<ISOSpinner> {
  @override
  void initState() {
    super.initState();

    locales = widget.supportedLocales;

    int? index;

    if (widget.initialItem != null && widget.initialItem! > -1) {
      index = widget.initialItem!;
    } else if (widget.locale != null) {
      index = locales.indexOf(widget.locale!);
    }

    if (index == null || index < 0) {
      index = 0;
    }
    controller = FixedExtentScrollController(initialItem: index);
  }

  late List<Locale> locales;
  FixedExtentScrollController? controller;

  @override
  Widget build(BuildContext context) => Container(
      height: 100,
      child: CupertinoPicker.builder(
        itemExtent: 25, //height of each item
        childCount: locales.length,
        scrollController: controller,
        onSelectedItemChanged: widget.onSelectedItemChanged,
        itemBuilder: (BuildContext context, int index) => Text(
          locales[index].countryCode == null
              ? locales[index].languageCode
              : '${locales[index].languageCode}-${locales[index].countryCode}',
          style: const TextStyle(fontSize: 20),
        ),
      ));
}
