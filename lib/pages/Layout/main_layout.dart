import 'package:flutter/material.dart';
import 'package:front_end_gestor/Util/Constants.dart';
import 'package:front_end_gestor/Util/SizingInfo.dart';
import 'package:front_end_gestor/components/molecules/customAppBar.dart';
import 'package:front_end_gestor/components/molecules/customFooter.dart';
import 'package:front_end_gestor/components/molecules/customNavigationBar.dart';
import 'package:front_end_gestor/main.dart';
import 'package:front_end_gestor/pages/company_view.dart';
import 'package:provider/provider.dart';

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
    final userData = Provider.of<UserData>(context);
    print('help ${userData.companyName}');
    return Scaffold(
      appBar: const MyCustomAppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                // decoration: BoxDecoration(
                //   color: Colors.blue,
                // ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        '../../../assets/images/logo.png'), // Ruta a tu imagen
                  ),
                ),
                child: Text('${userData.companyName ?? "Company Name"}')),
            ListTile(
              title: const Text(panelManagementUsers),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompanyView(),
                  ),
                );
              },
            ),
            const ListTile(
              title: const Text('Scanner || Venta'),
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
