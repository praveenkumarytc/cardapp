import 'package:cardapp/auth/login_page.dart';
import 'package:cardapp/dashboard/qrpage.dart';
import 'package:cardapp/main.dart';
import 'package:cardapp/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Hive/hive_methods.dart';
import '../model/user_model.dart';
import 'profilepage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _tabs = [
    const QRCodeScannerTab(),
    const ProfileTab(),
  ];

  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  UserModel? _userModel;
  Future<void> getUserData() async {
    _userModel = await HiveMethods.getUser();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade900,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Card-App'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.notifications),
        //     onPressed: () {
        //       // Handle notification icon tap
        //     },
        //   ),
        // ],
      ),
      drawer: Drawer(
        backgroundColor: primaryColor,
        shadowColor: primaryColor2,
        surfaceTintColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _userModel == null
                ? const SizedBox.shrink()
                : UserAccountsDrawerHeader(
                    accountName: Text(_userModel!.name),
                    accountEmail: Text(_userModel!.email),
                    currentAccountPicture: CircleAvatar(
                      child: Text(_userModel!.name.split('')[0].toUpperCase()),
                    ),
                  ),
            // ListTile(
            //   leading: const Icon(Icons.info),
            //   title: const Text('About Us'),
            //   onTap: () {
            //     // Handle About Us tap
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.phone),
            //   title: const Text('Contact'),
            //   onTap: () {
            //     // Handle Contact tap
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(isEditPage: true),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Account'),
              onTap: () {
                HiveMethods.deleteUser();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SplashPage(),
                  ),
                  (route) => false,
                );
                // Handle Logout tap
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // RotatedBox(
          //   quarterTurns: 1,
          //   child: Container(
          //     color: Colors.black,
          //     height: double.infinity,
          //     width: double.infinity,
          //     child: Image.network(
          //       "https://2.bp.blogspot.com/-MM4ERxB2Ffg/V_NMZrVGKhI/AAAAAAAA_9Y/iLxwyMb70b4LDYdTwX61d_cnVcmjAaM2gCLcB/s1600/1%2B%25281%2529.gif",
          //       // fit: BoxFit.fill,
          //     ),
          //   ),
          // ),
          // Container(
          //   color: Colors.grey.shade700,
          //   height: double.infinity,
          //   width: double.infinity,
          // ),
          _tabs[_currentIndex]
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.white, width: .2))),
        child: BottomNavigationBar(
          elevation: 2,
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner_outlined),
              label: 'Scan Qr',
            ),
          ],
        ),
      ),
    );
  }
}
