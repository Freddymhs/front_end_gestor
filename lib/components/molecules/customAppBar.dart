import 'package:flutter/material.dart';
import 'package:front_end_gestor/Util/Constants.dart';
import 'package:front_end_gestor/Util/SizingInfo.dart';
import 'package:front_end_gestor/supabase.dart';

class MyCustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyCustomAppBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyCustomAppBarState createState() => _MyCustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyCustomAppBarState extends State<MyCustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: ModalRoute.of(context)?.canPop == true
          ? BackButton()
          : IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
      actions: <Widget>[
        _buildTextButton(context, 'User Name', 'Welcome', isMobile(context)),
        _buildTextButton(context, 'Role', 'its your role', false),
        _buildIconButton(context),
        _buildPopupMenuButton(context),
      ],
    );
  }
}

Widget _buildTextButton(
  BuildContext context,
  String label,
  String message,
  bool hide,
) {
  if (hide == true) return const SizedBox.shrink();
  return TextButton(
    onPressed: () {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message))); // Call the function to get the message
    },
    child: Text(label),
  );
}

Widget _buildIconButton(BuildContext context) {
  return IconButton(
    icon: const Icon(Icons.add_alert),
    tooltip: showNotifications,
    onPressed: () {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(showNotifications)));
    },
  );
}

Widget _buildPopupMenuButton(BuildContext context) {
  return PopupMenuButton<int>(
    tooltip: showOptions,
    onSelected: (value) {
      if (value == 0) {
        Navigator.pushNamed(
          context,
          settingsRoute,
        );
      }
      if (value == 1) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text(goodByeMessage)));
        signOutGoogle();
      }
    },
    itemBuilder: (context) => [
      const PopupMenuItem<int>(value: 0, child: Text(configurations)),
      const PopupMenuItem<int>(value: 1, child: Text(signOut)),
    ],
  );
}
