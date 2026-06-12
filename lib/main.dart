import 'package:flutter/material.dart';

void main() {
  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const List<Map<String, dynamic>> _workouts = [
    {'icon': Icons.directions_run, 'label': 'Cardio',   'color': Color(0xFFE53935)},
    {'icon': Icons.fitness_center, 'label': 'Strength', 'color': Color(0xFF1565C0)},
    {'icon': Icons.self_improvement,'label': 'Yoga',    'color': Color(0xFF2E7D32)},
    {'icon': Icons.pool,            'label': 'Swimming','color': Color(0xFF00838F)},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: const Text('FitTrack', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome back, Akhil!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text("Ready for today's workout?", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1565C0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkoutTrackerScreen())),
                    child: const Text('Start Workout', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text('Workout Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 1.3,
              ),
              itemCount: _workouts.length,
              itemBuilder: (context, index) {
                final w = _workouts[index];
                return _CategoryCard(
                  icon: w['icon'] as IconData,
                  label: w['label'] as String,
                  color: w['color'] as Color,
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => WorkoutTrackerScreen(workoutType: w['label'] as String))),
                );
              },
            ),
            const SizedBox(height: 28),
            const Text('This Week', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _StatCard(label: 'Workouts', value: '3', icon: Icons.fitness_center, color: const Color(0xFF1565C0))),
                const SizedBox(width: 14),
                Expanded(child: _StatCard(label: 'Calories', value: '840', icon: Icons.local_fire_department, color: const Color(0xFFE53935))),
                const SizedBox(width: 14),
                Expanded(child: _StatCard(label: 'Minutes', value: '120', icon: Icons.timer_outlined, color: const Color(0xFF2E7D32))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.icon, required this.label, required this.color, required this.onTap});
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE3E8F0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: color)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});
  final String label; final String value; final IconData icon; final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE3E8F0)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}

class WorkoutTrackerScreen extends StatefulWidget {
  const WorkoutTrackerScreen({super.key, this.workoutType = 'Strength'});
  final String workoutType;
  @override
  State<WorkoutTrackerScreen> createState() => _WorkoutTrackerScreenState();
}

class _WorkoutTrackerScreenState extends State<WorkoutTrackerScreen> {
  final List<String> _exercises = ['Push Ups', 'Squats', 'Plank (secs)', 'Lunges'];
  late List<int> _reps;
  bool _workoutStarted = false;
  bool _workoutComplete = false;
  String _statusMessage = 'Press Start to begin your workout!';

  @override
  void initState() {
    super.initState();
    _reps = List.filled(_exercises.length, 0);
  }

  void _handleMainButton() {
    setState(() {
      if (!_workoutStarted) {
        _workoutStarted = true;
        _statusMessage = "Great! Log your reps for each exercise 💪";
      } else if (!_workoutComplete) {
        _workoutComplete = true;
        final total = _reps.fold(0, (a, b) => a + b);
        _statusMessage = "Workout complete! Total reps: $total 🎉";
      } else {
        _reps = List.filled(_exercises.length, 0);
        _workoutStarted = false;
        _workoutComplete = false;
        _statusMessage = 'Press Start to begin your workout!';
      }
    });
  }

  void _incrementRep(int index) {
    if (!_workoutStarted || _workoutComplete) return;
    setState(() {
      _reps[index]++;
      _statusMessage = "${_exercises[index]}: ${_reps[index]} reps";
    });
  }

  void _decrementRep(int index) {
    if (!_workoutStarted || _workoutComplete) return;
    setState(() { if (_reps[index] > 0) _reps[index]--; });
  }

  String get _buttonLabel {
    if (!_workoutStarted) return 'Start Workout';
    if (!_workoutComplete) return 'Finish Workout';
    return 'Start New Workout';
  }

  Color get _buttonColor {
    if (!_workoutStarted) return const Color(0xFF1565C0);
    if (!_workoutComplete) return const Color(0xFF2E7D32);
    return const Color(0xFF6A1B9A);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: Text('${widget.workoutType} Tracker', style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _workoutComplete ? const Color(0xFF2E7D32).withOpacity(0.1) : const Color(0xFF1565C0).withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _workoutComplete ? const Color(0xFF2E7D32).withOpacity(0.4) : const Color(0xFF1565C0).withOpacity(0.2),
                ),
              ),
              child: Text(_statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
                  color: _workoutComplete ? const Color(0xFF2E7D32) : const Color(0xFF1565C0)),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: _exercises.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE3E8F0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_exercises[index], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _decrementRep(index),
                              child: Container(
                                width: 32, height: 32,
                                decoration: BoxDecoration(color: const Color(0xFFE3E8F0), borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.remove, size: 16),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text('${_reps[index]}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () => _incrementRep(index),
                              child: Container(
                                width: 32, height: 32,
                                decoration: BoxDecoration(color: const Color(0xFF1565C0), borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.add, size: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _buttonColor, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _handleMainButton,
                child: Text(_buttonLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
