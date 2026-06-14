import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'screens/copilot_screen.dart';
import 'screens/scan_screen.dart';

void main() {
  runApp(const ForgeMindApp());
}

class ForgeMindApp extends StatelessWidget {
  const ForgeMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ForgeMind AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Deep charcoal
        primaryColor: const Color(0xFF2979FF), // Electric Blue
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2979FF),
          secondary: Color(0xFF00E676), // Cyber Green
          surface: Color(0xFF1E293B),
          error: Color(0xFFFF1744), // Radium Red
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CopilotScreen(),
    const ScanScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          backgroundColor: const Color(0xFF0F172A),
          indicatorColor: const Color(0xFF2979FF).withOpacity(0.2),
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: Color(0xFF2979FF)),
              label: 'Feed',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome, color: Color(0xFF00E676)),
              label: 'Copilot',
            ),
            NavigationDestination(
              icon: Icon(Icons.qr_code_scanner),
              selectedIcon: Icon(Icons.qr_code_scanner, color: Color(0xFF2979FF)),
              label: 'Scan',
            ),
          ],
        ),
      ),
    );
  }
}
