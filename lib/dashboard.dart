import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laza/cart_screen.dart';
import 'package:laza/components/colors.dart';
import 'package:laza/components/drawer.dart';
import 'package:laza/home_screen.dart';
import 'package:laza/my_cards_screen.dart';
import 'package:laza/wishlist_screen.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

var dashboardScaffoldKey = GlobalKey<ScaffoldState>();

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final pageController = PageController();
  int selectedIndex = 0;
  bool pop = false;

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: WillPopScope(
        onWillPop: () async {
          if (Platform.isIOS) return true;
          if (pop) return true;
          Fluttertoast.showToast(msg: 'Press again to exit');
          pop = true;
          Timer(const Duration(seconds: 2), () => pop = false);
          return false;
        },
        child: Scaffold(
          key: dashboardScaffoldKey,
          drawer: DrawerWidget(user: currentUser),
          body: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const HomeScreen(),
              const WishlistScreen(),
              const CartScreen(),
              const MyCardsScreen(),
            ],
          ),
          bottomNavigationBar: SlidingClippedNavBar(
            selectedIndex: selectedIndex,
            onButtonPressed: (index) {
              setState(() => selectedIndex = index);
              pageController.jumpToPage(index);
            },
            barItems: [
              BarItem(icon: Icons.home, title: 'Home'),
              BarItem(icon: Icons.favorite, title: 'Wishlist'),
              BarItem(icon: Icons.shopping_bag, title: 'Cart'),
              BarItem(icon: Icons.credit_card, title: 'Cards'),
            ],
            activeColor: ColorConstant.primary,
          ),
        ),
      ),
    );
  }
}
