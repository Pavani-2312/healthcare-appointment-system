import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _headerController;
  late final AnimationController _listController;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _listFade;

  final List<_HealthTip> _healthTips = const [
    _HealthTip(
      emoji: '💧',
      title: 'Stay Hydrated',
      description:
          'Drink at least 8 glasses of water daily to maintain optimal body function and energy levels.',
      color: Color(0xFF1565C0),
    ),
    _HealthTip(
      emoji: '🏃',
      title: 'Exercise Daily',
      description:
          '30 minutes of moderate exercise a day reduces risk of heart disease, diabetes and improves mood.',
      color: Color(0xFF2E7D32),
    ),
    _HealthTip(
      emoji: '😴',
      title: 'Sleep Well',
      description:
          '7–9 hours of quality sleep is essential for cognitive function, immunity and emotional health.',
      color: Color(0xFF4527A0),
    ),
    _HealthTip(
      emoji: '🥗',
      title: 'Eat Balanced',
      description:
          'A diet rich in fruits, vegetables, whole grains and lean proteins powers your body and brain.',
      color: Color(0xFFE65100),
    ),
    _HealthTip(
      emoji: '🧘',
      title: 'Manage Stress',
      description:
          'Practise meditation, yoga or deep breathing for 10 minutes a day to reduce chronic stress.',
      color: Color(0xFF00695C),
    ),
    _HealthTip(
      emoji: '🚭',
      title: 'Avoid Smoking',
      description:
          'Quitting smoking reduces risk of cancer, heart disease and stroke within weeks of stopping.',
      color: Color(0xFFC62828),
    ),
    _HealthTip(
      emoji: '☀️',
      title: 'Get Sunlight',
      description:
          '15–20 minutes of morning sunlight boosts vitamin D levels, improves mood and regulates sleep.',
      color: Color(0xFFF57F17),
    ),
    _HealthTip(
      emoji: '🦷',
      title: 'Oral Hygiene',
      description:
          'Brush twice and floss daily. Good oral health is directly linked to heart and overall health.',
      color: Color(0xFF00838F),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _headerFade = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeIn,
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic),
    );
    _listFade = CurvedAnimation(
      parent: _listController,
      curve: Curves.easeIn,
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _listController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Tips')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated header banner
            SlideTransition(
              position: _headerSlide,
              child: FadeTransition(
                opacity: _headerFade,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primary, Color(0xFF006064)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.favorite, color: Colors.white, size: 48),
                      SizedBox(height: 12),
                      Text(
                        'Live Well Every Day',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Small daily habits lead to big health improvements',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(
                'Daily Health Tips',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
            ),

            FadeTransition(
              opacity: _listFade,
              child: Column(
                children: _healthTips
                    .asMap()
                    .entries
                    .map(
                      (entry) => _AnimatedTipCard(
                        tip: entry.value,
                        delayMillis: entry.key * 100,
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _AnimatedTipCard extends StatefulWidget {
  final _HealthTip tip;
  final int delayMillis;

  const _AnimatedTipCard({required this.tip, required this.delayMillis});

  @override
  State<_AnimatedTipCard> createState() => _AnimatedTipCardState();
}

class _AnimatedTipCardState extends State<_AnimatedTipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0.4, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);

    Future.delayed(Duration(milliseconds: widget.delayMillis), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: widget.tip.color.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: widget.tip.color.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.tip.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      widget.tip.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tip.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: widget.tip.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.tip.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMedium,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HealthTip {
  final String emoji;
  final String title;
  final String description;
  final Color color;

  const _HealthTip({
    required this.emoji,
    required this.title,
    required this.description,
    required this.color,
  });
}
