import 'package:flutter/material.dart';

class BackAppBar extends StatefulWidget implements PreferredSizeWidget {
  String? title;

  BackAppBar({Key? key, this.title}) : super(key: key);

  @override
  State<BackAppBar> createState() => _BackAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}

class _BackAppBarState extends State<BackAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title!,
        style: const TextStyle(
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          size: 30,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Back',
            style: Theme.of(context).textTheme.button,
          ),
        )
      ],
    );
  }
}
