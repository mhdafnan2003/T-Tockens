import 'package:flutter/material.dart';

class WidgetAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WidgetAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(onPressed: (){}, icon: const Icon(Icons.menu,color: Colors.white,)),
      title: const Text(
        'Tezos',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
      actions:  [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}