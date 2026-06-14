import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/db_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _dbService = DatabaseService();
  Map<String, int> _healthScores = {'production': 0, 'energy': 0, 'workforce': 0, 'inventory': 0};
  List<Map<String, dynamic>> _insights = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await _dbService.connect();
    final scores = await _dbService.getHealthScores();
    final insights = await _dbService.getInsights();
    
    if (mounted) {
      setState(() {
        _healthScores = scores;
        _insights = insights;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.precision_manufacturing, color: Color(0xFF2979FF)),
            const SizedBox(width: 8),
            const Text('ForgeMind', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white70),
              onPressed: _loadData,
            ),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white.withOpacity(0.1),
              child: const Icon(Icons.person, size: 20, color: Colors.white70),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Text(
                    'Operations Overview',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  _buildHealthScores(),
                  const SizedBox(height: 24),
                  const Text(
                    'AI Insights Feed',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  ..._insights.asMap().entries.map((entry) {
                    final index = entry.key;
                    final insight = entry.value;
                    
                    IconData icon = Icons.info_outline;
                    Color color = Colors.blue;
                    
                    if (insight['type'] == 'warning') {
                      icon = Icons.warning_amber_rounded;
                      color = const Color(0xFFFF9100);
                    } else if (insight['type'] == 'error') {
                      icon = Icons.bolt;
                      color = const Color(0xFFFF1744);
                    } else if (insight['type'] == 'success') {
                      icon = Icons.check_circle_outline;
                      color = const Color(0xFF00E676);
                    }
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _buildInsightCard(
                        title: insight['title'] ?? 'Insight',
                        description: insight['description'] ?? '',
                        icon: icon,
                        color: color,
                      ).animate().fade(duration: 500.ms, delay: Duration(milliseconds: 200 * index)).slideY(begin: 0.2, end: 0),
                    );
                  }).toList(),
                  if (_insights.isEmpty)
                    const Center(child: Text("No insights available.", style: TextStyle(color: Colors.white54))),
                ],
              ),
            ),
    );
  }

  Widget _buildHealthScores() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildScoreCircle('Production', _healthScores['production'] ?? 0, const Color(0xFF2979FF)),
        _buildScoreCircle('Energy', _healthScores['energy'] ?? 0, const Color(0xFFFF9100)),
        _buildScoreCircle('Workforce', _healthScores['workforce'] ?? 0, const Color(0xFF00E676)),
        _buildScoreCircle('Inventory', _healthScores['inventory'] ?? 0, const Color(0xFF00E676)),
      ],
    ).animate().scale(duration: 500.ms);
  }

  Widget _buildScoreCircle(String label, int score, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                value: score / 100,
                color: color,
                backgroundColor: Colors.white.withOpacity(0.05),
                strokeWidth: 6,
              ),
            ),
            Text(
              '$score',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildInsightCard({required String title, required String description, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Investigate',
                      style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward, color: color, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
