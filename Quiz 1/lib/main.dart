import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(DiceApp());
}

class DiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Vibrant Dice Roller",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Changed default theme colors for a new look
        brightness: Brightness.dark, 
        primarySwatch: Colors.deepPurple,
        // Using a bold, fun font family if available (e.g., 'Bungee' or similar)
        // fontFamily: 'CustomFont', 
      ),
      home: DiceScreen(),
    );
  }
}

class DiceScreen extends StatefulWidget {
  @override
  _DiceScreenState createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> with SingleTickerProviderStateMixin {
  int diceNumber = 1;
  final TextEditingController _guessController = TextEditingController();
  String message = "";

  // Animation Controller
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );

    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubicEmphasized),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // New glow colors: Deep Orange and Cyan
    _glowAnimation = ColorTween(
      begin: Colors.deepOrangeAccent,
      end: Colors.cyanAccent,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _guessController.dispose();
    super.dispose();
  }

  void rollDice() {
    setState(() {
      diceNumber = Random().nextInt(6) + 1;

      if (_guessController.text.isNotEmpty) {
        int? guess = int.tryParse(_guessController.text);
        if (guess != null && guess >= 1 && guess <= 6) { // Added input validation
          if (guess == diceNumber) {
            message = "🥳 Correct! It's $diceNumber!";
          } else {
            message = "😔 Nope! It was $diceNumber. Try again!";
          }
        } else {
          message = "⚠️ Invalid guess. Roll again!";
        }
      } else {
        message = "You rolled a $diceNumber!";
      }
    });

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen height for better layout control
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Changed app bar color and style
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "✨ Dice Challenge",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // New Vibrant Gradient: Deep Purple to Blue
          gradient: LinearGradient(
            colors: [
              Color(0xFF3a1c71), // Deep Purple
              Color(0xFFd76d77), // Reddish tone
              Color(0xFFffaf7b), // Peach tone
            ],
            begin: Alignment.topCenter, // Changed gradient direction
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          // Using a fixed height for the main content area (slightly shifted up)
          child: SizedBox(
            height: screenHeight * 0.8, 
            child: SingleChildScrollView(
              // Changed main alignment to be slightly more top-heavy
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 120), // More space from the top

                  // 🎲 Animated Dice (3D Flip) moved to the top of the card
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final flipValue = _flipAnimation.value;
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.002)
                          ..rotateY(flipValue)
                          ..scale(_scaleAnimation.value),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30), // Slightly rounder
                            boxShadow: [
                              BoxShadow(
                                color: _glowAnimation.value!.withOpacity(0.9),
                                blurRadius: 30, // Stronger glow
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            "assets/images/$diceNumber.png",
                            height: 200, // Slightly larger dice
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 50), // Increased spacing

                  // 🧊 Simplified Card Container
                  Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 20), // Wider margin
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12), // Brighter transparency
                      borderRadius: BorderRadius.circular(25), // Rounder corners
                      border: Border.all(color: Colors.white.withOpacity(0.3)), // Thicker border
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Make Your Prediction 🔮",
                          style: TextStyle(
                            color: Colors.cyanAccent, // New highlight color
                            fontWeight: FontWeight.w800,
                            fontSize: 24, // Larger title
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 🧮 Input Field with updated colors
                        TextField(
                          controller: _guessController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: "Enter your number (1-6)",
                            hintStyle: TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.2), // Darker fill
                            prefixIcon: const Icon(Icons.flash_on, color: Colors.deepOrangeAccent), // New icon/color
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.deepOrangeAccent, width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.cyanAccent, width: 3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // 🎮 Roll Button with updated style
                        ElevatedButton.icon(
                          onPressed: rollDice,
                          icon: const Icon(Icons.auto_awesome, size: 30),
                          label: const Text(
                            "ROLL THE DICE",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                            backgroundColor: Colors.deepOrangeAccent, // New button color
                            foregroundColor: Colors.white,
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        // 📢 Result Text
                        AnimatedOpacity(
                          opacity: message.isNotEmpty ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: Text(
                            message,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: message.contains("Correct") ? Colors.cyanAccent : Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 5.0,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(1.0, 1.0),
                                ),
                              ]
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}