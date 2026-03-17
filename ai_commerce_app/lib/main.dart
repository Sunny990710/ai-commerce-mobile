import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/product.dart';
import 'screens/home_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/closet_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/my_screen.dart';
import 'screens/onboarding/ai_stylist_modal.dart';
import 'screens/onboarding/onboarding_flow.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const NightDreamApp());
}

class NightDreamApp extends StatefulWidget {
  const NightDreamApp({super.key});

  @override
  State<NightDreamApp> createState() => _NightDreamAppState();
}

class _NightDreamAppState extends State<NightDreamApp> {
  bool _showOnboarding = true;
  bool _loading = true;
  bool _showAiStylistModalOnHome = false;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final complete = await isOnboardingComplete();
    if (mounted) {
      setState(() {
        _showOnboarding = !complete;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return MaterialApp(
        title: 'NightDream',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light),
          useMaterial3: true,
        ),
        darkTheme: null,
        themeMode: ThemeMode.light,
        home: const Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return MaterialApp(
      title: 'NightDream',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.light),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
      themeMode: ThemeMode.light,
      home: _showOnboarding
          ? OnboardingFlow(
              onComplete: ({showAiStylistModal = false}) => setState(() {
                _showOnboarding = false;
                _showAiStylistModalOnHome = showAiStylistModal;
              }),
            )
          : MainScreen(
              showAiStylistModalOnMount: _showAiStylistModalOnHome,
              onAiStylistModalShown: () => setState(() => _showAiStylistModalOnHome = false),
              onResetOnboarding: () async {
                await clearOnboardingComplete();
                if (mounted) setState(() => _showOnboarding = true);
              },
            ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final bool showAiStylistModalOnMount;
  final VoidCallback? onAiStylistModalShown;
  final Future<void> Function() onResetOnboarding;

  const MainScreen({
    super.key,
    this.showAiStylistModalOnMount = false,
    this.onAiStylistModalShown,
    required this.onResetOnboarding,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final Set<String> _wishIds = {};
  String? _chatInitialPrompt;

  @override
  void initState() {
    super.initState();
    if (widget.showAiStylistModalOnMount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        AiStylistModal.show(context);
        widget.onAiStylistModalShown?.call();
      });
    }
  }

  void _toggleWish(Product p) {
    setState(() {
      if (_wishIds.contains(p.id)) {
        _wishIds.remove(p.id);
      } else {
        _wishIds.add(p.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        wishIds: _wishIds,
        onToggleWish: _toggleWish,
        onGoToChat: (prompt) => setState(() {
          _chatInitialPrompt = prompt;
          _currentIndex = 2;
        }),
        onGoToMy: () => setState(() => _currentIndex = 4),
      ),
      ExploreScreen(),
      ChatScreen(
        wishIds: _wishIds,
        onToggleWish: _toggleWish,
        initialPrompt: _chatInitialPrompt,
        onGoToCloset: () => setState(() => _currentIndex = 3),
        onGoToCoordination: () => setState(() => _currentIndex = 1),
      ),
      ClosetScreen(
        wishIds: _wishIds,
        onToggleWish: _toggleWish,
        onGoToChat: () => setState(() => _currentIndex = 2),
        onGoToMy: () => setState(() => _currentIndex = 4),
      ),
      MyScreen(wishIds: _wishIds, onToggleWish: _toggleWish, onResetOnboarding: widget.onResetOnboarding),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: '홈'),
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: '탐색'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: '대화'),
          NavigationDestination(icon: Icon(Icons.checkroom_outlined), selectedIcon: Icon(Icons.checkroom), label: '옷장'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: '마이'),
        ],
      ),
    );
  }
}
