import 'package:flutter/material.dart';

/// ITS-537 Weeks 9-10 Lab: Multi-Screen Navigation in Flutter
/// Akhil Kumar Gollapalli — University of the Cumberlands
///
/// Navigation structure (stack-based):
///   Screen 1: HomeScreen      — workout category cards
///   Screen 2: WorkoutListScreen — receives category name (data IN via constructor)
///   Screen 3: WorkoutDetailScreen — receives Workout object (data IN),
///                                   returns completion result (data OUT via pop)
///
/// Navigation bug documented and fixed — see WorkoutDetailScreen comments.

void main() {
  runApp(const FitTrackApp());
}

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────
class Workout {
  final String name;
  final int sets;
  final int reps;
  final String duration;
  final String description;

  const Workout({
    required this.name,
    required this.sets,
    required this.reps,
    required this.duration,
    required this.description,
  });
}

// Workout data per category
const Map<String, List<Workout>> kWorkoutData = {
  'Strength': [
    Workout(name: 'Push Ups',    sets: 3, reps: 15, duration: '10 min',
        description: 'Classic upper-body compound movement targeting chest, shoulders, and triceps.'),
    Workout(name: 'Squats',      sets: 4, reps: 12, duration: '12 min',
        description: 'Primary lower-body exercise for quads, hamstrings, and glutes.'),
    Workout(name: 'Lunges',      sets: 3, reps: 10, duration: '8 min',
        description: 'Unilateral leg exercise improving balance and leg strength.'),
    Workout(name: 'Plank Hold',  sets: 3, reps: 1,  duration: '6 min',
        description: 'Core stabilisation exercise. Hold each set for 45–60 seconds.'),
  ],
  'Cardio': [
    Workout(name: 'Jumping Jacks', sets: 3, reps: 30, duration: '8 min',
        description: 'Full-body cardiovascular warm-up and conditioning exercise.'),
    Workout(name: 'High Knees',    sets: 3, reps: 20, duration: '6 min',
        description: 'Running in place with exaggerated knee drive. Elevates heart rate quickly.'),
    Workout(name: 'Burpees',       sets: 3, reps: 10, duration: '10 min',
        description: 'High-intensity full-body movement combining squat, plank, and jump.'),
  ],
  'Yoga': [
    Workout(name: 'Downward Dog', sets: 1, reps: 5, duration: '5 min',
        description: 'Foundation yoga pose stretching hamstrings, calves, and shoulders.'),
    Workout(name: 'Warrior I',    sets: 1, reps: 4, duration: '6 min',
        description: 'Standing strength pose building hip flexibility and leg endurance.'),
    Workout(name: 'Child\'s Pose',sets: 1, reps: 3, duration: '4 min',
        description: 'Restorative resting pose for hip, thigh, and lower back release.'),
  ],
};

// Color per category
const Map<String, Color> kCategoryColor = {
  'Strength': Color(0xFF1565C0),
  'Cardio':   Color(0xFFE53935),
  'Yoga':     Color(0xFF2E7D32),
};

const Map<String, IconData> kCategoryIcon = {
  'Strength': Icons.fitness_center,
  'Cardio':   Icons.directions_run,
  'Yoga':     Icons.self_improvement,
};

// ─────────────────────────────────────────────────────────────────────────────
// Root App
// ─────────────────────────────────────────────────────────────────────────────
class FitTrackApp extends StatelessWidget {
  const FitTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrack Nav',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN 1 — HomeScreen (StatefulWidget)
// Tracks which workouts have been completed (returned by Screen 3 via pop).
// ─────────────────────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _completedCount = 0;

  // Called after returning from WorkoutListScreen so the
  // completed count can update on the Home screen.
  void _onCategoryReturn(int completed) {
    setState(() => _completedCount += completed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: const Text('FitTrack',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Welcome banner ──────────────────────────────────────
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
                  const Text('Welcome back, Akhil!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    _completedCount == 0
                        ? 'Choose a category to get started.'
                        : '$_completedCount workout${_completedCount > 1 ? 's' : ''} completed today!',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text('Choose a Category',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E))),
            const SizedBox(height: 14),

            // ── Category cards ──────────────────────────────────────
            ...kCategoryColor.keys.map((category) {
              final color = kCategoryColor[category]!;
              final icon  = kCategoryIcon[category]!;
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _CategoryCard(
                  category: category,
                  color: color,
                  icon: icon,
                  count: kWorkoutData[category]!.length,
                  // ── Navigator.push: Screen 1 → Screen 2
                  // Passes category name as constructor argument.
                  // Awaits the return value (completed count) via pop.
                  onTap: () async {
                    final completed = await Navigator.push<int>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkoutListScreen(
                          category: category,
                          color: color,
                        ),
                      ),
                    );
                    if (completed != null && completed > 0) {
                      _onCategoryReturn(completed);
                    }
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// Category card widget
class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.color,
    required this.icon,
    required this.count,
    required this.onTap,
  });
  final String category;
  final Color color;
  final IconData icon;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE3E8F0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color)),
                  Text('$count workouts',
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN 2 — WorkoutListScreen (StatefulWidget)
// Receives: category (String), color (Color) — data passed IN from Screen 1.
// Returns:  completed count (int) — data passed BACK via Navigator.pop.
// ─────────────────────────────────────────────────────────────────────────────
class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({
    super.key,
    required this.category,
    required this.color,
  });
  final String category;
  final Color color;

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  int _completedInSession = 0;

  // Called when WorkoutDetailScreen pops with result = true (completed).
  void _onWorkoutCompleted() {
    setState(() => _completedInSession++);
  }

  @override
  Widget build(BuildContext context) {
    final workouts = kWorkoutData[widget.category]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
        title: Text('${widget.category} Workouts',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        // Flutter provides a default back button here (Navigator.pop).
        // Overriding to also pass the completed count back to Screen 1.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context, _completedInSession),
        ),
      ),
      body: Column(
        children: [
          // Progress banner
          if (_completedInSession > 0)
            Container(
              color: widget.color.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: widget.color, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '$_completedInSession of ${workouts.length} completed',
                    style: TextStyle(
                        color: widget.color, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: workouts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final w = workouts[index];
                return _WorkoutListTile(
                  workout: w,
                  color: widget.color,
                  // ── Navigator.push: Screen 2 → Screen 3
                  // Passes the full Workout object as a constructor argument.
                  // Awaits bool result from Screen 3 (true = completed).
                  onTap: () async {
                    final completed = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkoutDetailScreen(
                          workout: w,
                          color: widget.color,
                        ),
                      ),
                    );
                    if (completed == true) {
                      _onWorkoutCompleted();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Workout list tile
class _WorkoutListTile extends StatelessWidget {
  const _WorkoutListTile({
    required this.workout,
    required this.color,
    required this.onTap,
  });
  final Workout workout;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE3E8F0)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(workout.name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${workout.sets} sets × ${workout.reps} reps  ·  ${workout.duration}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SCREEN 3 — WorkoutDetailScreen (StatefulWidget)
// Receives: Workout object and Color — data passed IN from Screen 2.
// Returns:  bool (true if marked complete) — data passed BACK via pop.
//
// Navigation bug documented and fixed:
// ──────────────────────────────────────────────────────────────────────────
// BUG: Initially, this screen used named routes (routes: {'/detail': ...})
// and passed data via Navigator.pushNamed(context, '/detail', arguments: w).
// The bug: when the user pressed the system back gesture (swipe from edge)
// instead of the AppBar back button, the named route popped WITHOUT returning
// any result, so Screen 2 received null even if the user had tapped Complete.
// The completed count was never incremented on HomeScreen.
//
// FIX: Switched to MaterialPageRoute with a constructor parameter (passing
// the Workout object directly) and wrapped the WillPopScope / PopScope to
// intercept the system back gesture and ensure Navigator.pop(context, _done)
// is always called with the correct result, whether the user presses the
// AppBar button or swipes back.
// ─────────────────────────────────────────────────────────────────────────────
class WorkoutDetailScreen extends StatefulWidget {
  const WorkoutDetailScreen({
    super.key,
    required this.workout,
    required this.color,
  });
  final Workout workout;
  final Color color;

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  bool _done = false;

  // Always pop with the correct result — covers both AppBar button
  // and system back gesture (the fix for the documented bug above).
  void _navigateBack() {
    Navigator.pop(context, _done);
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.workout;

    // PopScope intercepts system back gesture so it also returns _done.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _navigateBack();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: widget.color,
          foregroundColor: Colors.white,
          title: Text(w.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _navigateBack,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card with exercise stats
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Text(w.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatPill(label: 'Sets',     value: '${w.sets}'),
                        _StatPill(label: 'Reps',     value: '${w.reps}'),
                        _StatPill(label: 'Duration', value: w.duration),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Description
              const Text('About this exercise',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E))),
              const SizedBox(height: 10),
              Text(w.description,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.6)),

              const Spacer(),

              // Complete / undo button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _done ? const Color(0xFF2E7D32) : widget.color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => setState(() => _done = !_done),
                  icon: Icon(_done ? Icons.check_circle : Icons.radio_button_unchecked),
                  label: Text(
                    _done ? 'Completed!' : 'Mark as Complete',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Explicit back/save button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: widget.color,
                    side: BorderSide(color: widget.color),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _navigateBack,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Save & Go Back',
                      style: TextStyle(fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Stat pill widget used in the header card
class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}
