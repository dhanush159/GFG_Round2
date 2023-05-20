import 'package:agri_easy/providers/chats_provider.dart';
import 'package:agri_easy/providers/models_provider.dart';
import 'package:agri_easy/screens/chat_screen.dart';
import 'package:agri_easy/screens/home_screen.dart';
import 'package:agri_easy/screens/homepage.dart';
import 'package:agri_easy/screens/img_upload.dart';
import 'package:agri_easy/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:side_navigation/side_navigation.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'AgriEasy';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int index = 0;

  final screens = [
    const Homepage(),
    const HomeScreen(),
    const ImageUpload(),
    const ChatScreen(),
    const ProductScreen()
  ];

  @override
  Widget build(BuildContext context) {
    // final items = [
    //   const Icon(Icons.home, size: 40),
    //   const Icon(Icons.cloud, size: 40),
    //   const Icon(Icons.camera, size: 40),
    //   const Icon(Icons.chat, size: 40),
    //   const Icon(Icons.shopping_cart, size: 40),
    // ];
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ModelsProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ChatProvider(),
          ),
        ],
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 70, 130, 2),
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: Row(children: [
            /// Pretty similar to the BottomNavigationBar!
            SideNavigationBar(
              theme: SideNavigationBarTheme(
                backgroundColor: Colors.grey[850],
                togglerTheme: SideNavigationBarTogglerTheme.standard(),
                itemTheme: SideNavigationBarItemTheme.standard(),
                dividerTheme: SideNavigationBarDividerTheme.standard(),
              ),
              header: SideNavigationBarHeader(
                  image: Image.asset(
                      "../android/app/src/main/res/mipmap-hdpi/ic_launcher.png",
                      height: 50,
                      width: 50),
                  title: const Text('AgriEasy',
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                          color: Colors.white54,
                          fontSize: 30,
                          letterSpacing: 2)),
                  subtitle: const Text('')),
              selectedIndex: index,
              items: const [
                SideNavigationBarItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                ),
                SideNavigationBarItem(
                  icon: Icons.cloud,
                  label: 'Weather',
                ),
                SideNavigationBarItem(
                  icon: Icons.camera_sharp,
                  label: 'Detect',
                ),
                SideNavigationBarItem(
                  icon: Icons.chat_bubble,
                  label: 'Chat',
                ),
                SideNavigationBarItem(
                  icon: Icons.shopping_cart,
                  label: 'Products',
                ),
              ],
              onTap: (index) {
                setState(() {
                  this.index = index;
                });
              },
            ),

            /// Make it take the rest of the available width
            Expanded(child: screens[index]),
            // bottomNavigationBar: CurvedNavigationBar(
            //   animationDuration: const Duration(milliseconds: 300),
            //   height: 50,
            //   backgroundColor: Colors.transparent,
            //   index: index,
            //   items: items,
            //   color: const Color.fromARGB(255, 215, 213, 213),
            //   buttonBackgroundColor: const Color.fromARGB(255, 153, 249, 153),
            //   onTap: (index) {
            //     setState(() {
            //       this.index = index;
            //     });
            //   },
            // ),
            // body: screens[index],
          ]),
        ));
  }
}
