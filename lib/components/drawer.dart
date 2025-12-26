import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laza/extensions/context_extension.dart';
import 'package:laza/intro_screen.dart';
import 'package:laza/theme.dart';
import 'package:provider/provider.dart';
import 'colors.dart';
import 'laza_icons.dart';

class DrawerWidget extends StatelessWidget {
  final User? user;

  const DrawerWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final String userName = user?.displayName ?? user?.email ?? 'Guest User';

    final String firstLetter =
        userName.isNotEmpty ? userName[0].toUpperCase() : 'G';

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 5),
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    onTap: () => Scaffold.of(context).closeDrawer(),
                    child: Ink(
                      width: 45,
                      height: 45,
                      decoration: ShapeDecoration(
                        color: context.theme.cardColor,
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(LazaIcons.menu_vertical),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),

                /// 👤 USER INFO (Dynamic)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        maxRadius: 24,
                        child: Text(firstLetter),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: context.bodyLargeW500,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              user != null ? 'Verified Profile' : 'Guest',
                              style: context.bodySmall
                                  ?.copyWith(color: ColorConstant.manatee),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30.0),

                /// 🌙 THEME
                Consumer<ThemeNotifier>(
                  builder: (context, themeNotifier, _) {
                    IconData iconData = Icons.brightness_auto_outlined;
                    switch (themeNotifier.themeMode) {
                      case ThemeMode.light:
                        iconData = LazaIcons.sun;
                        break;
                      case ThemeMode.dark:
                        iconData = Icons.dark_mode_outlined;
                        break;
                      case ThemeMode.system:
                        iconData = Icons.brightness_auto_outlined;
                        break;
                    }

                    return ListTile(
                      leading: Icon(iconData),
                      title: const Text('Appearance'),
                      onTap: () async {
                        final result = await showModalActionSheet<ThemeMode>(
                          context: context,
                          title: 'Choose app appearance',
                          actions: const [
                            SheetAction(
                                label: 'Automatic', key: ThemeMode.system),
                            SheetAction(label: 'Light', key: ThemeMode.light),
                            SheetAction(label: 'Dark', key: ThemeMode.dark),
                          ],
                        );
                        if (result != null) {
                          themeNotifier.toggleTheme(result);
                        }
                      },
                    );
                  },
                ),
              ],
            ),

            /// 🚪 LOGOUT
            ListTile(
              leading: const Icon(LazaIcons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () async {
                final result = await showOkCancelAlertDialog(
                  context: context,
                  title: 'Confirm Logout',
                  message: 'Are you sure you want to logout?',
                  okLabel: 'Logout',
                  isDestructiveAction: true,
                );

                if (result == OkCancelResult.ok && context.mounted) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const IntroductionScreen()),
                    (_) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
