import 'dart:async';
import 'package:flutter/material.dart';

class CookingTimer extends StatefulWidget {
  final String cookingTime;

  const CookingTimer({
    super.key,
    required this.cookingTime,
  });

  @override
  State<CookingTimer> createState() => _CookingTimerState();
}

class _CookingTimerState extends State<CookingTimer> {
  Timer? _timer;
  Duration? _duration;
  Duration? _remainingTime;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _parseCookingTime();
  }

  void _parseCookingTime() {
    final timeString = widget.cookingTime.toLowerCase();
    final numbers = RegExp(r'\d+').allMatches(timeString);

    if (numbers.isEmpty) return;

    int minutes = 0;

    if (timeString.contains('hour')) {
      minutes += int.parse(numbers.first.group(0)!) * 60;
      if (numbers.length > 1 && timeString.contains('minute')) {
        minutes += int.parse(numbers.elementAt(1).group(0)!);
      }
    } else if (timeString.contains('minute')) {
      minutes = int.parse(numbers.first.group(0)!);
    }

    setState(() {
      _duration = Duration(minutes: minutes);
      _remainingTime = _duration;
    });
  }

  void _startTimer() {
    if (_remainingTime == null || _remainingTime!.inSeconds <= 0) {
      _remainingTime = _duration;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime!.inSeconds <= 0) {
          _timer?.cancel();
          _isRunning = false;
          // Show notification or alert when timer is done
          _showTimerCompleteDialog();
        } else {
          _remainingTime = Duration(seconds: _remainingTime!.inSeconds - 1);
        }
      });
    });

    setState(() {
      _isRunning = true;
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingTime = _duration;
      _isRunning = false;
    });
  }

  void _showTimerCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Timer Complete!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Your cooking time is up!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '--:--';
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_duration == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatDuration(_remainingTime),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                ),
                IconButton(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.replay),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
