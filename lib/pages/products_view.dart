import 'package:flutter/material.dart';
import 'package:front_end_gestor/Util/Constants.dart';
import 'package:front_end_gestor/components/atoms/superScanner.dart';

class ProductsView extends StatelessWidget {
  static const routeName = productsRoute;
  const ProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //  ch/ Replace with your product listing UI
      child: MyScanner(),
    );
  }
}
