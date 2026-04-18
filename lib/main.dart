import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() => runApp(const IntervalQuizApp());

// --- 컬러 팔레트 ---
class AppColors {
  static const bg = Color(0xFF0D0D0D);
  static const surface = Color(0xFF1A1A2E);
  static const card = Color(0xFF16213E);
  static const accent = Color(0xFF6C63FF);
  static const accentAlt = Color(0xFFE94560);
  static const correct = Color(0xFF00C897);
  static const wrong = Color(0xFFFF6B6B);
  static const textPrimary = Color(0xFFF5F5F5);
  static const textSecondary = Color(0xFF8D8DAA);
}

class IntervalQuizApp extends StatelessWidget {
  const IntervalQuizApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Interval',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: AppColors.bg,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accent,
            secondary: AppColors.accentAlt,
            surface: AppColors.surface,
          ),
        ),
        home: const ModeSelectPage(),
      );
}

// --- 글래스 카드 위젯 ---
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const GlassCard({super.key, required this.child, this.padding});
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: child,
          ),
        ),
      );
}

// --- 모드 선택 화면 ---
class ModeSelectPage extends StatelessWidget {
  const ModeSelectPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.bg, Color(0xFF1A1A2E), Color(0xFF0D0D0D)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 로고 영역
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.accent, AppColors.accentAlt],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.music_note_rounded, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'INTERVAL',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 8,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '음정 도수 트레이닝',
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary, letterSpacing: 2),
                  ),
                  const SizedBox(height: 56),
                  _ModeButton(
                    label: '객관식',
                    subtitle: '6개 보기 중 선택',
                    icon: Icons.grid_view_rounded,
                    gradient: const [AppColors.accent, Color(0xFF5A52D5)],
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const QuizPage(subjective: false))),
                  ),
                  const SizedBox(height: 16),
                  _ModeButton(
                    label: '주관식',
                    subtitle: '직접 입력',
                    icon: Icons.edit_rounded,
                    gradient: const [AppColors.accentAlt, Color(0xFFC73E54)],
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const QuizPage(subjective: true))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label, subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;
  const _ModeButton({required this.label, required this.subtitle, required this.icon, required this.gradient, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: gradient[0].withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
                ],
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 18),
            ],
          ),
        ),
      );
}

// --- 음계 로직 ---
class Note {
  final String name;
  final int semitone;
  final int letter;
  const Note(this.name, this.semitone, this.letter);
}

const allNotes = [
  Note('도', 0, 0),
  Note('도#', 1, 0), Note('레♭', 1, 1),
  Note('레', 2, 1),
  Note('레#', 3, 1), Note('미♭', 3, 2),
  Note('미', 4, 2),
  Note('파', 5, 3),
  Note('파#', 6, 3), Note('솔♭', 6, 4),
  Note('솔', 7, 4),
  Note('솔#', 8, 4), Note('라♭', 8, 5),
  Note('라', 9, 5),
  Note('라#', 10, 5), Note('시♭', 10, 6),
  Note('시', 11, 6),
];

const _perfectDegrees = {1, 4, 5, 8};
const _refSemitones = [0, 2, 4, 5, 7, 9, 11];

String intervalName(Note from, Note to) {
  final semitones = (to.semitone - from.semitone) % 12;
  final degree = (to.letter - from.letter) % 7 + 1;
  final actualDegree = semitones == 0 && degree == 1 ? 1 : degree;
  final expected = _refSemitones[actualDegree - 1];
  final diff = semitones - expected;

  if (_perfectDegrees.contains(actualDegree)) {
    switch (diff) {
      case -2: return '겹감${actualDegree}도';
      case -1: return '감${actualDegree}도';
      case 0:  return '완전${actualDegree}도';
      case 1:  return '증${actualDegree}도';
      case 2:  return '겹증${actualDegree}도';
    }
  } else {
    switch (diff) {
      case -3: return '겹감${actualDegree}도';
      case -2: return '감${actualDegree}도';
      case -1: return '단${actualDegree}도';
      case 0:  return '장${actualDegree}도';
      case 1:  return '증${actualDegree}도';
      case 2:  return '겹증${actualDegree}도';
    }
  }
  return '${actualDegree}도';
}

List<String> allIntervals() {
  final set = <String>{};
  for (final a in allNotes) {
    for (final b in allNotes) {
      set.add(intervalName(a, b));
    }
  }
  final list = set.toList()..sort((a, b) {
    final da = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final db = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    if (da != db) return da.compareTo(db);
    return a.compareTo(b);
  });
  return list;
}

// --- 퀴즈 화면 ---
class QuizPage extends StatefulWidget {
  final bool subjective;
  const QuizPage({super.key, required this.subjective});
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  final _rand = Random();
  late Note _from, _to;
  late String _answer;
  late List<String> _choices;
  String? _selected;
  late Stopwatch _stopwatch;
  int _total = 0, _correct = 0;
  double _totalTime = 0;
  final _controller = TextEditingController();
  bool _submitted = false;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _nextQuestion();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _nextQuestion() {
    do {
      _from = allNotes[_rand.nextInt(allNotes.length)];
      _to = allNotes[_rand.nextInt(allNotes.length)];
    } while ((_to.letter - _from.letter) % 7 == 0);
    _answer = intervalName(_from, _to);
    _selected = null;
    _submitted = false;
    _controller.clear();
    final all = allIntervals()..remove(_answer)..shuffle(_rand);
    _choices = [_answer, ...all.take(5)]..shuffle(_rand);
    _stopwatch = Stopwatch()..start();
    _fadeCtrl.forward(from: 0);
  }

  void _onSelect(String choice) {
    if (_selected != null) return;
    _stopwatch.stop();
    setState(() {
      _selected = choice;
      _total++;
      _totalTime += _stopwatch.elapsedMilliseconds / 1000;
      if (choice == _answer) _correct++;
    });
  }

  void _onSubmitText() {
    if (_submitted) return;
    _stopwatch.stop();
    final input = _controller.text.trim();
    setState(() {
      _submitted = true;
      _selected = input;
      _total++;
      _totalTime += _stopwatch.elapsedMilliseconds / 1000;
      if (input == _answer) _correct++;
    });
  }

  bool get _answered => widget.subjective ? _submitted : _selected != null;
  bool get _isCorrect => _selected == _answer;

  @override
  Widget build(BuildContext context) {
    final elapsed = _stopwatch.elapsedMilliseconds / 1000;
    final avg = _total > 0 ? (_totalTime / _total) : 0.0;
    final rate = _total > 0 ? (_correct * 100 ~/ _total) : 0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), AppColors.bg],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  // 상단 바
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 22),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.subjective ? 'SUBJECTIVE' : 'MULTIPLE',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 3, color: AppColors.textSecondary),
                      ),
                      const Spacer(),
                      const SizedBox(width: 38),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // 스탯 카드
                  GlassCard(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(label: '문제', value: '$_total'),
                        Container(width: 1, height: 28, color: Colors.white.withValues(alpha: 0.1)),
                        _StatItem(label: '정답률', value: '$rate%'),
                        Container(width: 1, height: 28, color: Colors.white.withValues(alpha: 0.1)),
                        _StatItem(label: '평균', value: '${avg.toStringAsFixed(1)}s'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 문제 표시
                  Text(_from.name, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: AppColors.accent)),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.accent, AppColors.accentAlt],
                    ).createShader(bounds),
                    child: const Text('→', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300, color: Colors.white)),
                  ),
                  Text(_to.name, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: AppColors.accentAlt)),
                  const SizedBox(height: 8),
                  Text('도수를 맞춰보세요', style: TextStyle(fontSize: 13, color: AppColors.textSecondary.withValues(alpha: 0.7), letterSpacing: 1)),
                  const SizedBox(height: 28),
                  // 보기 / 입력
                  if (!widget.subjective)
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final cols = constraints.maxWidth > 500 ? 3 : 2;
                          const spacing = 10.0;
                          final itemW = (constraints.maxWidth - spacing * (cols - 1)) / cols;
                          return SingleChildScrollView(
                            child: Wrap(
                              spacing: spacing,
                              runSpacing: spacing,
                              children: _choices.map((c) {
                                final isAnswer = c == _answer;
                                final isSelected = c == _selected;
                                Color bg = AppColors.card;
                                Color border = Colors.white.withValues(alpha: 0.06);
                                Color textColor = AppColors.textPrimary;
                                if (_selected != null) {
                                  if (isAnswer) {
                                    bg = AppColors.correct.withValues(alpha: 0.15);
                                    border = AppColors.correct;
                                    textColor = AppColors.correct;
                                  } else if (isSelected) {
                                    bg = AppColors.wrong.withValues(alpha: 0.15);
                                    border = AppColors.wrong;
                                    textColor = AppColors.wrong;
                                  }
                                }
                                return GestureDetector(
                                  onTap: () => _onSelect(c),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: itemW,
                                    height: 48,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: bg,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: border, width: 1.5),
                                    ),
                                    child: Text(c, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: textColor)),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    )
                  else
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                            ),
                            child: TextField(
                              controller: _controller,
                              textAlign: TextAlign.center,
                              enabled: !_submitted,
                              style: const TextStyle(fontSize: 20, color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                hintText: '예: 장3도, 완전5도',
                                hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                              ),
                              onSubmitted: (_) => _onSubmitText(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (!_submitted)
                            GestureDetector(
                              onTap: _onSubmitText,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [AppColors.accent, AppColors.accentAlt]),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Text('확인', textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  // 결과 + 다음 버튼
                  if (_answered) ...[
                    GlassCard(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                            color: _isCorrect ? AppColors.correct : AppColors.wrong,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              _isCorrect ? '정답! ${elapsed.toStringAsFixed(1)}초' : '오답 · 정답: $_answer (${elapsed.toStringAsFixed(1)}초)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _isCorrect ? AppColors.correct : AppColors.wrong,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => setState(_nextQuestion),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [AppColors.accent, AppColors.accentAlt]),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: AppColors.accent.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
                        ),
                        child: const Text('다음 문제', textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  const _StatItem({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, letterSpacing: 1)),
        ],
      );
}
