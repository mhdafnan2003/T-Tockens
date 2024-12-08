import 'package:flutter/material.dart';
import 'package:tezos/Screens/cart/screencart.dart';
import 'package:tezos/Screens/earn/screenearn.dart';
import 'package:tezos/Screens/home/screenhome.dart';
import 'package:tezos/Screens/profile/screenprofile.dart';
import 'package:tezos/Screens/search/screensearch.dart';
import 'package:tezos/Screens/widgets/WigetAppBar.dart';
import 'package:tezos/Screens/widgets/bottomnavigationbar.dart';

class Mainscreen extends StatelessWidget {
  Mainscreen({super.key});
  static ValueNotifier<int> selectedIndex = ValueNotifier(0);
  final List<Widget> pages = [
    const Screenhome(),
    const ScreenSearch(),
     Screenearn(),
    const Screencart(),
    const Screenprofile(),
  ];
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: selectedIndex, builder: (BuildContext ctx,int index,_){return Scaffold(
      appBar:index == 2 ?  null : const WidgetAppBar(),
      body: pages[index],
      bottomNavigationBar: const ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: WidgetBottomNav(),
      ),
      );
    });
  }
}
