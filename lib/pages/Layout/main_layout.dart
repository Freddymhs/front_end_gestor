import 'package:flutter/material.dart';
import 'package:front_end_gestor/Util/SizingInfo.dart';
import 'package:front_end_gestor/components/molecules/customAppBar.dart';
import 'package:front_end_gestor/components/molecules/customFooter.dart';
import 'package:front_end_gestor/components/molecules/customNavigationBar.dart';

class BaseLayout extends StatefulWidget {
  final Widget child;
  const BaseLayout({super.key, this.child = const SizedBox()});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyCustomAppBar(),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: isMobile(context)
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: widget.child,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: widget.child,
            ),
      bottomSheet: isMobile(context) ? null : const Footer(),
      bottomNavigationBar:
          isMobile(context) ? const MyCustomBottomNavigationBar() : null,
    );
  }
}
