import 'package:flutter/material.dart';
import 'package:tezos/Screens/MainScreen.dart';

class WidgetBottomNav extends StatelessWidget {
  const WidgetBottomNav({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Mainscreen.selectedIndex,
        builder: (BuildContext ctx, int, _) {
          return BottomNavigationBar(
            backgroundColor: Colors.black,
            selectedItemColor: Colors.grey,
            unselectedItemColor: Colors.white,
            onTap: (value) {
              Mainscreen.selectedIndex.value = value;
            },
            currentIndex: Mainscreen.selectedIndex.value,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money_sharp), label: 'Earn'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category_rounded), label: 'Cart'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
          );
        });
  }
}
