import 'package:flutter/material.dart';
import 'package:front_end_gestor/src/Values/ResponsiveApp.dart';

class EdgeInsetsApp {
  //Todo
  EdgeInsets? allSmallEdgeInsets;
  EdgeInsets? allMediumEdgeInsets;
  EdgeInsets? allLargeEdgeInsets;
  EdgeInsets? allExLargeEdgeInsets;
  //Vertical
  EdgeInsets? vrtSmallEdgeInsets;
  EdgeInsets? vrtMediumEdgeInsets;
  EdgeInsets? vrtLargeEdgeInsets;
  EdgeInsets? vrtExLargeEdgeInsets;
  // Horizontal
  EdgeInsets? hrzMediumEdgeInsets;
  EdgeInsets? hrzSmallEdgeInsets;
  EdgeInsets? hrzLargeEdgeInsets;

  //Solo derecha, izquierda, arriba y abajo SMALL
  EdgeInsets? onlySmallTopEdgeInsets;
  EdgeInsets? onlySmallBottomEdgeInsets;
  EdgeInsets? onlySmallRightEdgeInsets;
  EdgeInsets? onlySmallLeftEdgeInsets;

  //Solo derecha, izquierda, arriba y abajo MEDIUM
  EdgeInsets? onlyMediumTopEdgeInsets;
  EdgeInsets? onlyMediumBottomEdgeInsets;
  EdgeInsets? onlyMediumRightEdgeInsets;
  EdgeInsets? onlyMediumLeftEdgeInsets;

  //Solo derecha, izquierda, arriba y abajo LARGE
  EdgeInsets? onlyLargeTopEdgeInsets;
  EdgeInsets? onlyLargeBottomEdgeInsets;
  EdgeInsets? onlyLargeRightEdgeInsets;
  EdgeInsets? onlyLargeLeftEdgeInsets;

  EdgeInsets? onlyExLargeTopEdgeInsets;

  final ResponsiveApp _responsiveApp;

  EdgeInsetsApp(this._responsiveApp) {
    //Padding
    double smallHeightEdgeInsets = _responsiveApp.setHeight(5);
    double smallWidthEdgeInsets = _responsiveApp.setWidth(5);

    double mediumHeightEdgeInsets = _responsiveApp.setHeight(10);
    double mediumWidthEdgeInsets = _responsiveApp.setWidth(10);

    double largeHeightEdgeInsets = _responsiveApp.setHeight(20);
    double largeWidthEdgeInsets = _responsiveApp.setWidth(20);

    double largeExHeightEdgeInsets = _responsiveApp.setHeight(100);
    double largeExWidthEdgeInsets = _responsiveApp.setWidth(100);
    //Todo
    allSmallEdgeInsets = EdgeInsets.symmetric(
        vertical: smallHeightEdgeInsets, horizontal: smallWidthEdgeInsets);
    allMediumEdgeInsets = EdgeInsets.symmetric(
        vertical: mediumHeightEdgeInsets, horizontal: mediumWidthEdgeInsets);
    allLargeEdgeInsets = EdgeInsets.symmetric(
        vertical: largeHeightEdgeInsets, horizontal: largeWidthEdgeInsets);

    allExLargeEdgeInsets = EdgeInsets.symmetric(
        vertical: largeExHeightEdgeInsets, horizontal: largeExWidthEdgeInsets);

    //Vertical
    vrtSmallEdgeInsets = EdgeInsets.symmetric(vertical: smallHeightEdgeInsets);
    vrtMediumEdgeInsets =
        EdgeInsets.symmetric(vertical: mediumHeightEdgeInsets);
    vrtLargeEdgeInsets = EdgeInsets.symmetric(vertical: largeHeightEdgeInsets);
    vrtExLargeEdgeInsets =
        EdgeInsets.symmetric(vertical: largeExHeightEdgeInsets);

    // Horizontal
    hrzMediumEdgeInsets =
        EdgeInsets.symmetric(horizontal: mediumWidthEdgeInsets);
    hrzSmallEdgeInsets = EdgeInsets.symmetric(horizontal: smallWidthEdgeInsets);
    hrzLargeEdgeInsets = EdgeInsets.symmetric(horizontal: largeWidthEdgeInsets);

    //Solo derecha, izquierda, arriba y abajo SMALL
    onlySmallTopEdgeInsets = EdgeInsets.only(top: smallHeightEdgeInsets);
    onlySmallBottomEdgeInsets = EdgeInsets.only(bottom: smallHeightEdgeInsets);
    onlySmallRightEdgeInsets = EdgeInsets.only(right: smallWidthEdgeInsets);
    onlySmallLeftEdgeInsets = EdgeInsets.only(left: smallWidthEdgeInsets);

    //Solo derecha, izquierda, arriba y abajo MEDIUM
    onlyMediumTopEdgeInsets = EdgeInsets.only(top: mediumHeightEdgeInsets);
    onlyMediumBottomEdgeInsets =
        EdgeInsets.only(bottom: mediumHeightEdgeInsets);
    onlyMediumRightEdgeInsets = EdgeInsets.only(right: mediumWidthEdgeInsets);
    onlyMediumLeftEdgeInsets = EdgeInsets.only(left: mediumWidthEdgeInsets);

    //Solo derecha, izquierda, arriba y abajo LARGE
    onlyLargeTopEdgeInsets = EdgeInsets.only(top: largeHeightEdgeInsets);
    onlyLargeBottomEdgeInsets = EdgeInsets.only(bottom: largeHeightEdgeInsets);
    onlyLargeRightEdgeInsets = EdgeInsets.only(right: largeWidthEdgeInsets);
    onlyLargeLeftEdgeInsets = EdgeInsets.only(left: largeWidthEdgeInsets);

    //Solo derecha, izquierda, arriba y abajo Exxlarge
    onlyExLargeTopEdgeInsets = EdgeInsets.only(top: largeExHeightEdgeInsets);
  }
}
