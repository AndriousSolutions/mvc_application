///
/// Copyright (C) 2020 Andrious Solutions
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///    http://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
///          Created  10 Feb 2020
///
///
import 'dart:ui' as ui
    show
        Paragraph,
        ParagraphBuilder,
        ParagraphConstraints,
        ParagraphStyle,
        TextStyle;

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart'
    show
        DiagnosticPropertiesBuilder,
        DiagnosticsTreeStyle,
        FlutterError,
        FlutterErrorDetails,
        FlutterExceptionHandler,
        InformationCollector,
        StringProperty;

import 'package:flutter/rendering.dart'
    show
        Color,
        DiagnosticPropertiesBuilder,
        EdgeInsets,
        FlutterError,
        Offset,
        Paint,
        PaintingContext,
        RenderBox,
        Size,
        StringProperty,
        TextAlign,
        TextDirection;

/// Define the type of function to handle errors.
typedef ReportErrorHandler = Future<void> Function(
    dynamic exception, StackTrace stack);

/// Your App's error handler.
class AppErrorHandler {
  /// Singleton Pattern with only one instance of this Error Handler.
  /// Optionally supply the Error handler, Builder, and Report routines.
  factory AppErrorHandler({
    FlutterExceptionHandler? handler,
    ErrorWidgetBuilder? builder,
    ReportErrorHandler? report,
    bool? allowNewHandlers,
  }) {
    _this ??= AppErrorHandler._(builder);

    /// Allows you to set an error handler more than once.
    final reassigned = set(handler: handler, builder: builder, report: report);

    // Allow for null. Simply allow new handles by default
    allowNewHandlers ??= true;

    // Once set to false, you can't assign different handlers anymore.
    // However, it's set to false only if one of the handlers was reassigned.
    if (!allowNewHandlers && reassigned) {
      _allowNewHandlers = false;
    }
    return _this!;
  }

  AppErrorHandler._(ErrorWidgetBuilder? builder) {
    // Record the current error handler.
    _oldOnError = FlutterError.onError;

    // Record the current Widget builder when a widget fails to build.
    _oldBuilder = ErrorWidget.builder;

    // At the start, define our own 'error building widget' widget if one is not provided.
    builder ??= errorDisplayWidget;

    ErrorWidget.builder = builder;

    FlutterError.onError = (FlutterErrorDetails details) {
      // Prevent an infinite loop and fall back to the original handler.
      if (_inHandler) {
        // An error in the Error Handler
        if (_onError != null && _oldOnError != null) {
          _onError = null;
          try {
            _oldOnError!(details);
          } catch (ex) {
            // intentionally left empty.
          }
        }
        return;
      }

      // If there's an error in the error handler, we want to know about it.
      _inHandler = true;

      final _handler = _onError ?? _oldOnError;

      if (_handler != null) {
        _handler(details);
        _inHandler = false;
      }
    };
    // Record the 'current' error handler.
    _flutterExceptionHandler = FlutterError.onError;
  }
  static AppErrorHandler? _this;
  static bool _allowNewHandlers = true;

  // FlutterExceptionHandler get oldOnError => _oldOnError;
  static FlutterExceptionHandler? _oldOnError;
  //
  // ErrorWidgetBuilder get oldBuilder => _oldBuilder;
  ErrorWidgetBuilder? _oldBuilder;

  static ReportErrorHandler? _errorReport;

  static bool _inHandler = false;

  /// Flag indicating the App has already executed.
  @Deprecated('A mutable static property is discouraged.')
  // Not certain why this is here in the first place.
  static bool ranApp = false;

  /// Return the current 'Flutter Exception Handler.'
  FlutterExceptionHandler? get flutterExceptionHandler =>
      _flutterExceptionHandler;
  static FlutterExceptionHandler? _flutterExceptionHandler;

  /// Return either the current and previous Error Handler.
  FlutterExceptionHandler? get onError => _onError ?? _oldOnError;
  static FlutterExceptionHandler? _onError;

  /// Set a handler and the report
  static bool set({
    FlutterExceptionHandler? handler,
    ErrorWidgetBuilder? builder,
    ReportErrorHandler? report,
  }) {
    // Once you're not allowed to reset the handlers, it can't be reversed.
    if (!_allowNewHandlers) {
      return false;
    }

    // Are you allowed to reset a handler?
    // Only if an item was passed to reset.
    var reset = false;

    if (handler != null) {
      // The default is to dump the error to the console. You can do more.
      _onError = handler;
      reset = true;
    }

    if (report != null) {
      _errorReport = report;
      reset = true;
    }

    if (builder != null) {
      // Change the widget presented when another widget fails to build.
      ErrorWidget.builder = builder;
      reset = true;
    }
    // Something was set;
    return reset;
  }

  /// Display the Error details in a widget.
  /// try..catch to ensure a widget is returned.
  Widget displayError(FlutterErrorDetails details) {
    Widget widget;
    try {
      widget = ErrorWidget.builder(details);
    } catch (ex) {
      widget = errorDisplayWidget(details);
    }
    return widget;
  }

  /// Return the original handlers.
  void dispose() {
    // Restore the error widget routine.
    if (_oldBuilder != null) {
      ErrorWidget.builder = _oldBuilder!;
    }
    // Return the original error routine.
    if (_oldOnError != null) {
      FlutterError.onError = _oldOnError;
    }
  }

  /// Determines if running in an IDE or in production.
  static bool get inDebugger {
    var inDebugMode = false;
    // assert is removed in production.
    assert(inDebugMode = true);
    return inDebugMode;
  }

  /// Report the error.
  Future<void> reportError(
    dynamic ex,
    StackTrace stack, {
    String? message,
    String? library,
    InformationCollector? informationCollector,
  }) async {
    if (_errorReport == null) {
      message ??= 'while attempting to execute your app';
      library ??= 'Your app';
      _debugReportException(
        ErrorSummary(message),
        ex,
        stack,
        library: library,
        informationCollector: informationCollector,
      );
    } else {
      await _errorReport!(ex, stack);
    }
  }

  /// Report the error in an isolate.
  void isolateError(dynamic ex, StackTrace stack) {
    reportError(
      ex,
      stack,
      message: 'while attempting to execute main()',
      library: 'likely main.dart',
    );
  }

  /// Report the error in a zone.
  void runZonedError(dynamic ex, StackTrace stack) {
    reportError(
      ex,
      stack,
      message: 'while attempting to execute runApp()',
      library: 'controller/app.dart',
    );
  }

  /// Display the error details.
  // This is a copy used in the Flutter Framework.
  FlutterErrorDetails _debugReportException(
    DiagnosticsNode context,
    dynamic exception,
    StackTrace stack, {
    String library = 'Flutter framework',
    InformationCollector? informationCollector,
  }) {
    final details = FlutterErrorDetails(
      exception: exception,
      stack: stack,
      library: library,
      context: context,
      informationCollector: informationCollector,
    );
    FlutterError.reportError(details);
    return details;
  }

  /// This class is intentionally doing things using the low-level
  /// primitives to avoid depending on any subsystems that may have ended
  /// up in an unstable state -- after all, this class is mainly used when
  /// things have gone wrong.
  static Widget errorDisplayWidget(FlutterErrorDetails details) {
    String message;
    try {
      message = 'ERROR\n\n${details.exception}\n\n';

      final stackTrace = details.stack.toString().split('\n');

      final length = stackTrace.length > 5 ? 5 : stackTrace.length;

      final buffer = StringBuffer()..write(message);
      for (var i = 0; i < length; i++) {
        buffer.write('${stackTrace[i]}\n');
      }
      message = buffer.toString();
    } catch (e) {
      message = 'Error';
    }

    final exception = details.exception;
    return DisplayErrorWidget(
        message: message, error: exception is Error ? exception : null);
  }
}

/// A low-level widget to present instead of the failed widget.
class DisplayErrorWidget extends LeafRenderObjectWidget {
  /// Supply an error message to display and or a Error object.
  DisplayErrorWidget({this.message = '', Error? error})
      : _error = error,
        super(key: UniqueKey());

  /// The message to display.
  final String message;
  final Error? _error;

  @override
  RenderBox createRenderObject(BuildContext context) =>
      _ErrorBox(_errorMessage());

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    if (_error == null || _error is! FlutterError) {
      properties.add(StringProperty('message', _errorMessage(), quoted: false));
    } else {
      final FlutterError _flutterError = _error as FlutterError;
      properties.add(_flutterError.toDiagnosticsNode(
          style: DiagnosticsTreeStyle.whitespace));
    }
  }

  // Compose an error message to be displayed.
  // An empty string if no message was provided.
  String _errorMessage() {
    String _message;
    if (message.isEmpty) {
      if (_error == null) {
        _message = '';
      } else {
        _message = _error.toString();
      }
    } else {
      _message = message;
    }
    return _message;
  }
}

class _ErrorBox extends RenderBox {
  ///
  /// A message can optionally be provided. If a message is provided, an attempt
  /// will be made to render the message when the box paints.
  _ErrorBox([this.message = '']) {
    try {
      if (message != '') {
        ///
        /// Generally, the much better way to draw text in a RenderObject is to
        /// use the TextPainter class. If you're looking for code to crib from,
        /// see the paragraph.dart file and the RenderParagraph class.
        final builder = ui.ParagraphBuilder(paragraphStyle)
          ..pushStyle(textStyle)
          ..addText(message);
        _paragraph = builder.build();
      }
    } catch (error) {
      // Intentionally left empty.
    }
  }

  /// The message to attempt to display at paint time.
  final String message;

  ui.Paragraph? _paragraph;

  @override
  double computeMaxIntrinsicWidth(double height) {
    return 100000;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return 100000;
  }

  @override
  bool get sizedByParent => true;

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void performResize() {
    size = constraints.constrain(const Size(100000, 100000));
  }

  /// The distance to place around the text.
  ///
  /// This is intended to ensure that if the [RenderBox] is placed at the top left
  /// of the screen, under the system's status bar, the error text is still visible in
  /// the area below the status bar.
  ///
  /// The padding is ignored if the error box is smaller than the padding.
  ///
  /// See also:
  ///
  ///  * [minimumWidth], which controls how wide the box must be before the
  //     horizontal padding is applied.
  static EdgeInsets padding = const EdgeInsets.fromLTRB(34, 96, 34, 12);

  /// The width below which the horizontal padding is not applied.
  ///
  /// If the left and right padding would reduce the available width to less than
  /// this value, then the text is rendered flush with the left edge.
  static double minimumWidth = 200;

  /// The color to use when painting the background of [RenderBox] objects.
  /// a red from a light gray.
  static Color backgroundColor = _initBackgroundColor();

  /// Ligt gray in production; Red in development.
  static Color _initBackgroundColor() {
    var result = const Color(0xF0C0C0C0);
    assert(() {
      result = const Color(0xF0900000);
      return true;
    }());
    return result;
  }

  /// The text style to use when painting [RenderBox] objects.
  /// a dark gray sans-serif font.
  static ui.TextStyle textStyle = _initTextStyle();

  /// Black text in production; Yellow in development.
  static ui.TextStyle _initTextStyle() {
    var result = ui.TextStyle(
      color: const Color(0xFF303030),
      fontFamily: 'sans-serif',
      fontSize: 18,
    );
    assert(() {
      result = ui.TextStyle(
        color: const Color(0xFFFFFF66),
        fontFamily: 'monospace',
        fontSize: 14,
        fontWeight: FontWeight.bold,
      );
      return true;
    }());
    return result;
  }

  /// The paragraph style to use when painting [RenderBox] objects.
  static ui.ParagraphStyle paragraphStyle = ui.ParagraphStyle(
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.left,
  );

  @override
  void paint(PaintingContext context, Offset offset) {
    try {
      context.canvas.drawRect(offset & size, Paint()..color = backgroundColor);
      if (_paragraph != null) {
        var width = size.width;
        var left = 0.0;
        var top = 0.0;
        if (width > padding.left + minimumWidth + padding.right) {
          width -= padding.left + padding.right;
          left += padding.left;
        }
        _paragraph!.layout(ui.ParagraphConstraints(width: width));
        if (size.height > padding.top + _paragraph!.height + padding.bottom) {
          top += padding.top;
        }
        context.canvas.drawParagraph(_paragraph!, offset + Offset(left, top));
      }
    } catch (ex) {
      // Intentionally left empty.
    }
  }
}
