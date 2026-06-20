import 'package:flutter/material.dart';

/// ITS-537 Weeks 7-8 Lab: Gesture-Controlled Interface
/// Akhil Kumar Gollapalli — University of the Cumberlands
///
/// Demonstrates three gesture interactions using GestureDetector:
///   1. Tap        -> increments rep counter
///   2. Long Press -> resets the counter (with confirmation feedback)
///   3. Horizontal Swipe -> switches between exercise cards

void main() {
  runApp(const GestureApp());
}

class GestureApp extends StatelessWidget {
  const GestureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture Workout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      home: const GestureWorkoutScreen(),
    );
  }
}

class GestureWorkoutScreen extends StatefulWidget {
  const GestureWorkoutScreen({super.key});

  @override
  State<GestureWorkoutScreen> createState() => _GestureWorkoutScreenState();
}

class _GestureWorkoutScreenState extends State<GestureWorkoutScreen> {
  // ── Exercise data ──────────────────────────────────────────────────────
  final List<Map<String, dynamic>> _exercises = [
    {'name': 'Push Ups', 'icon': Icons.fitness_center, 'color': const Color(0xFF1565C0)},
    {'name': 'Squats', 'icon': Icons.accessibility_new, 'color': const Color(0xFF2E7D32)},
    {'name': 'Plank', 'icon': Icons.self_improvement, 'color': const Color(0xFFE53935)},
    {'name': 'Lunges', 'icon': Icons.directions_walk, 'color': const Color(0xFF6A1B9A)},
  ];

  int _currentIndex = 0;     // Which exercise card is shown (swipe controls this)
  int _repCount = 0;         // Tap increments this
  bool _justReset = false;   // Brief visual feedback flag for long press
  double _dragAccumulator = 0; // Tracks cumulative horizontal drag distance

  // ── GESTURE 1: TAP — increment reps ───────────────────────────────────
  void _handleTap() {
    setState(() {
      _repCount++;
      _justReset = false;
    });
  }

  // ── GESTURE 2: LONG PRESS — reset counter ─────────────────────────────
  void _handleLongPress() {
    setState(() {
      _repCount = 0;
      _justReset = true;
    });
    // Refinement: brief visual confirmation that fades after 600ms
    // so the user gets clear feedback that the reset registered.
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _justReset = false);
    });
  }

  // ── GESTURE 3: HORIZONTAL SWIPE — switch exercise card ────────────────
  // Refinement: initial implementation relied on drag velocity
  // (onHorizontalDragEnd + primaryVelocity), but testing on Flutter Web
  // showed mouse/trackpad input often reports a velocity of zero even
  // for a clear drag, making the gesture unreliable in Chrome. This was
  // replaced with cumulative distance tracking via onHorizontalDragUpdate,
  // which works consistently across both touch and mouse input.
  void _handleDragUpdate(DragUpdateDetails details) {
    _dragAccumulator += details.delta.dx;
  }

  void _handleDragEnd(DragEndDetails details) {
    const distanceThreshold = 60.0; // pixels — filters out accidental taps/jitter

    if (_dragAccumulator <= -distanceThreshold) {
      // Dragged left -> next exercise
      setState(() {
        _currentIndex = (_currentIndex + 1) % _exercises.length;
        _repCount = 0;
      });
    } else if (_dragAccumulator >= distanceThreshold) {
      // Dragged right -> previous exercise
      setState(() {
        _currentIndex = (_currentIndex - 1 + _exercises.length) % _exercises.length;
        _repCount = 0;
      });
    }
    _dragAccumulator = 0; // reset for the next gesture
  }

  @override
  Widget build(BuildContext context) {
    final exercise = _exercises[_currentIndex];
    final Color exColor = exercise['color'] as Color;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: const Text('Gesture Workout', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ── Instructions banner ─────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Tap to count reps  •  Long-press to reset  •  Swipe to switch exercise',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF1565C0), fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 30),

            // ── Page indicator dots ─────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_exercises.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _currentIndex ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _currentIndex ? exColor : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),

            // ── Main Gesture Card ────────────────────────────────────────
            Expanded(
              child: GestureDetector(
                onTap: _handleTap,
                onLongPress: _handleLongPress,
                onHorizontalDragUpdate: _handleDragUpdate,
                onHorizontalDragEnd: _handleDragEnd,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _justReset ? exColor.withOpacity(0.15) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _justReset ? exColor : const Color(0xFFE3E8F0),
                      width: _justReset ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: exColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(exercise['icon'] as IconData, size: 56, color: exColor),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        exercise['name'] as String,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: exColor,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        '$_repCount',
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: exColor,
                        ),
                      ),
                      const Text(
                        'reps',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      AnimatedOpacity(
                        opacity: _justReset ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          'Reset!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: exColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Text(
              'Exercise ${_currentIndex + 1} of ${_exercises.length}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            // Refinement: added explicit prev/next buttons as a fallback
            // navigation path. Testing showed some users on trackpads/mice
            // didn't realize a horizontal drag was possible, so buttons
            // make the same action available through a tap as well.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => setState(() {
                    _currentIndex = (_currentIndex - 1 + _exercises.length) % _exercises.length;
                    _repCount = 0;
                  }),
                  icon: const Icon(Icons.chevron_left),
                  style: IconButton.styleFrom(backgroundColor: const Color(0xFFE3E8F0)),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => setState(() {
                    _currentIndex = (_currentIndex + 1) % _exercises.length;
                    _repCount = 0;
                  }),
                  icon: const Icon(Icons.chevron_right),
                  style: IconButton.styleFrom(backgroundColor: const Color(0xFFE3E8F0)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
