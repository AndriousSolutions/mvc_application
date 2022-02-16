///
/// Author Tim Rijckaert   https://github.com/timrijckaert
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
///          Created  Sep 27, 2019
///
///

import 'dart:math' show min;

import 'package:flutter/material.dart'
    show
        ScrollMetrics,
        ScrollPhysics,
        ScrollPosition,
        ScrollSpringSimulation,
        Simulation,
        Tolerance;

/// A 'Snapping' Scrolling Physics
class SnappingListScrollPhysics extends ScrollPhysics {
  /// Supply the intended width of the items scrolled.
  /// Optionally supply a 'parent' Physics object to encompass.
  const SnappingListScrollPhysics({
    required this.itemWidth,
    ScrollPhysics? parent,
  }) : super(parent: parent);

  /// Supply the intended width of the items scrolled.
  final double itemWidth;

  @override
  SnappingListScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      SnappingListScrollPhysics(
        parent: buildParent(ancestor),
        itemWidth: itemWidth,
      );

  double _getItem(ScrollPosition position) => (position.pixels) / itemWidth;

  double _getPixels(ScrollPosition position, double item) =>
      min(item * itemWidth, position.maxScrollExtent);

  double _getTargetPixels(
      ScrollPosition position, Tolerance tolerance, double velocity) {
    var item = _getItem(position);
    if (velocity < -tolerance.velocity) {
      item -= 0.5;
    } else if (velocity > tolerance.velocity) {
      item += 0.5;
    }
    return _getPixels(position, item.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final tolerance = this.tolerance;
    final target =
        _getTargetPixels(position as ScrollPosition, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}

/////
/////
///// Author: Norris Duncan      https://github.com/norrisduncan
/////
/////
//class CustomSnappingScrollPhysicsForTheControlPanelHousing extends ScrollPhysics {
//  final List<double> stoppingPoints;
//  final SpringDescription springDescription = SpringDescription(mass: 100.0, damping: .2, stiffness: 50.0);
//
//  @override
//  CustomSnappingScrollPhysicsForTheControlPanelHousing({@required this.stoppingPoints, ScrollPhysics parent})
//      : super(parent: parent) {
//    stoppingPoints.sort();
//  }
//
//  @override
//  CustomSnappingScrollPhysicsForTheControlPanelHousing applyTo(ScrollPhysics ancestor) {
//    return new CustomSnappingScrollPhysicsForTheControlPanelHousing(
//        stoppingPoints: stoppingPoints, parent: buildParent(ancestor));
//  }
//
//  @override
//  Simulation createBallisticSimulation(ScrollMetrics scrollMetrics, double velocity) {
//    double targetStoppingPoint = _getTargetStoppingPointPixels(scrollMetrics.pixels, velocity, 0.0003, stoppingPoints);
//
//    return ScrollSpringSimulation(springDescription, scrollMetrics.pixels, targetStoppingPoint, velocity,
//        tolerance: Tolerance(velocity: .00003, distance: .003));
//  }
//
//  double _getTargetStoppingPointPixels(
//      double initialPosition, double velocity, double drag, List<double> stoppingPoints) {
//    double endPointBeforeSnappingIsCalculated =
//        initialPosition + (-velocity / math.log(drag)).clamp(stoppingPoints[0], stoppingPoints.last);
//    if (stoppingPoints.contains(endPointBeforeSnappingIsCalculated)) {
//      return endPointBeforeSnappingIsCalculated;
//    }
//    if (endPointBeforeSnappingIsCalculated > stoppingPoints.last) {
//      return stoppingPoints.last;
//    }
//    for (int i = 0; i < stoppingPoints.length; i++) {
//      if (endPointBeforeSnappingIsCalculated < stoppingPoints[i] &&
//          endPointBeforeSnappingIsCalculated < stoppingPoints[i] - (stoppingPoints[i] - stoppingPoints[i - 1]) / 2) {
//        double stoppingPoint = stoppingPoints[i - 1];
//        debugPrint(stoppingPoint.toString());
//        return stoppingPoint;
//      } else if (endPointBeforeSnappingIsCalculated < stoppingPoints[i] &&
//          endPointBeforeSnappingIsCalculated > stoppingPoints[i] - (stoppingPoints[i] - stoppingPoints[i - 1]) / 2) {
//        double stoppingPoint = stoppingPoints[i];
//        debugPrint(stoppingPoint.toString());
//        return stoppingPoint;
//      }
//    }
//    throw Error.safeToString('Failed finding a new scroll simulation endpoint for this scroll animation');
//  }
//}
