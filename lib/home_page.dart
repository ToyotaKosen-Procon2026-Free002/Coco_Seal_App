import 'package:coco_seal/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  final List<Widget> _roleScreens = [
    const ChildTableDashboard(),
    const ParentTableDashboard()
  ];

  int _currentRoleIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _roleScreens[_currentRoleIndex],

      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: _currentRoleIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentRoleIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.child_care), label: "子供モード"),
          NavigationDestination(icon: Icon(Icons.supervisor_account), label: "保護者モード")
        ],
      ),
    );
  }
}



class ChildTableDashboard extends StatefulWidget {
  const ChildTableDashboard({super.key});

  @override
  State<StatefulWidget> createState() => ChildTableDashboardState();
}

class ChildTableDashboardState extends State<ChildTableDashboard> {
  int _selectedMenuIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ココ・シール"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer
      ),

      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,

        child: ListView(
          children: [
            _buildSidebarButton(0, "今日のすれ違い", Icons.people, Colors.orange),
            _buildSidebarButton(1, 'レアシールの場所', Icons.map, Colors.green),
            _buildSidebarButton(2, 'ウィークリーミッション', Icons.assignment, Colors.blue),
            _buildSidebarButton(3, 'シールずかん', Icons.auto_stories, Colors.pink),
            _buildSidebarButton(4, 'シール帳づくり', Icons.brush, Colors.purple),
            _buildSidebarButton(5, 'シールパック交換', Icons.published_with_changes, Colors.purple),
          ],
        )
      )
    );
  }

  Widget _buildSidebarButton(int index, String label, IconData icon, Color activeColor) {
    final bool isSelected = _selectedMenuIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: () => setState(() => _selectedMenuIndex = index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withValues(alpha: 0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? activeColor : Colors.black54, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? activeColor : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class ParentTableDashboard extends StatefulWidget {
  const ParentTableDashboard({super.key});

  @override
  State<StatefulWidget> createState() => ParentTableDashboardState();
}

class ParentTableDashboardState extends State<ParentTableDashboard> {

  var userText = "wait";

  @override
  Widget build(BuildContext context) {
    ApiService.fetchUserProfile().then((response) => {
      setState(() {
        userText = "${response}";
      })

    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("ココ・シール"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),

      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: const Text("ログアウト"),
          ),

          Text("${userText}")
        ],
      ),
    );
  }
}