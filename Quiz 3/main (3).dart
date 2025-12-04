import 'package:flutter/material.dart';

void main() => runApp(const BMICalculatorApp());

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6C63FF),
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        textTheme: Typography.material2021().black.apply(
          bodyColor: Colors.grey[900],
          displayColor: Colors.grey[900],
        ),
      ),
      home: const BMIHomePage(),
    );
  }
}

class BMIHomePage extends StatefulWidget {
  const BMIHomePage({super.key});

  @override
  State<BMIHomePage> createState() => _BMIHomePageState();
}

class _BMIHomePageState extends State<BMIHomePage>
    with SingleTickerProviderStateMixin {
  double _height = 170.0; // cm
  int _weight = 70; // kg
  int _age = 28;
  bool _isMale = true;

  late AnimationController _buttonController;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  double _calculateBMI() {
    final heightM = _height / 100;
    final bmi = _weight / (heightM * heightM);
    return bmi;
  }

  String _bmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obesity';
  }

  Color _categoryColor(double bmi) {
    if (bmi < 18.5) return Colors.blue.shade300;
    if (bmi < 25) return Colors.green.shade400;
    if (bmi < 30) return Colors.orange.shade400;
    return Colors.red.shade400;
  }

  void _onCalculate() async {
    await _buttonController.forward();
    await _buttonController.reverse();

    final bmi = _calculateBMI();
    if (!mounted) return;
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, a1, a2) => BMIResultPage(
          bmi: bmi,
          category: _bmiCategory(bmi),
          color: _categoryColor(bmi),
        ),
        transitionsBuilder: (context, a1, a2, child) {
          final curved = Curves.easeOut.transform(a1.value);
          return Transform.translate(
            offset: Offset(0, (1 - curved) * 60),
            child: Opacity(opacity: a1.value, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('BMI Calculator'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _genderCard(isMale: true),
                  const SizedBox(width: 12),
                  _genderCard(isMale: false),
                ],
              ),
              const SizedBox(height: 18),
              _heightCard(),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _numberCard(
                      label: 'Weight (kg)',
                      value: _weight,
                      onDecrement: () =>
                          setState(() => _weight = (_weight - 1).clamp(1, 500)),
                      onIncrement: () =>
                          setState(() => _weight = (_weight + 1).clamp(1, 500)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _numberCard(
                      label: 'Age',
                      value: _age,
                      onDecrement: () =>
                          setState(() => _age = (_age - 1).clamp(1, 130)),
                      onIncrement: () =>
                          setState(() => _age = (_age + 1).clamp(1, 130)),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 8.0,
                ),
                child: GestureDetector(
                  onTapDown: (_) => _buttonController.forward(),
                  onTapUp: (_) => _onCalculate(),
                  onTapCancel: () => _buttonController.reverse(),
                  child: AnimatedBuilder(
                    animation: _buttonController,
                    builder: (context, child) {
                      final scale = 1 - _buttonController.value;
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: Container(
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [cs.primary, cs.primaryContainer],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: cs.primary.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'CALCULATE',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _genderCard({required bool isMale}) {
    final selected = _isMale == isMale;
    final icon = isMale ? Icons.male : Icons.female;
    final label = isMale ? 'Male' : 'Female';

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isMale = isMale),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.primaryContainer
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 36,
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[700],
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heightCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Height', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _height.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Text('cm', style: TextStyle(color: Colors.grey[700])),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            ),
            child: Slider(
              value: _height,
              min: 100,
              max: 220,
              divisions: 120,
              onChanged: (v) => setState(() => _height = v),
              activeColor: Theme.of(context).colorScheme.primary,
              inactiveColor: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _numberCard({
    required String label,
    required int value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _roundIconButton(icon: Icons.remove, onPressed: onDecrement),
              const SizedBox(width: 12),
              _roundIconButton(icon: Icons.add, onPressed: onIncrement),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roundIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}

class BMIResultPage extends StatefulWidget {
  final double bmi;
  final String category;
  final Color color;

  const BMIResultPage({
    super.key,
    required this.bmi,
    required this.category,
    required this.color,
  });

  @override
  State<BMIResultPage> createState() => _BMIResultPageState();
}

class _BMIResultPageState extends State<BMIResultPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bmi = widget.bmi;
    final category = widget.category;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Result'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Curves.elasticOut,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      color: widget.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: bmi),
                    duration: const Duration(milliseconds: 900),
                    builder: (context, value, child) {
                      return Text(
                        value.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Body Mass Index',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 18),
                  LinearProgressIndicator(
                    value: (bmi.clamp(10, 40) - 10) / 30,
                    color: widget.color,
                    backgroundColor: widget.color.withOpacity(0.12),
                    minHeight: 10,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    _explain(bmi),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.0,
                        vertical: 12.0,
                      ),
                      child: Text('RE-CALCULATE'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _explain(double bmi) {
    if (bmi < 18.5)
      return 'You are underweight. Consider a balanced diet and consult a healthcare provider if concerned.';
    if (bmi < 25)
      return 'Great! Your BMI is within the normal range. Keep maintaining a healthy lifestyle.';
    if (bmi < 30)
      return 'You are overweight. Regular exercise and dietary adjustments may help.';
    return 'BMI indicates obesity. Please consult a healthcare professional for personalized advice.';
  }
}
