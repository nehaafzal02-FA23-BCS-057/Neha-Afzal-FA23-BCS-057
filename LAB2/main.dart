import 'package:flutter/material.dart';

void main() {
  runApp(const MyCalculator());
}

class MyCalculator extends StatelessWidget {
  const MyCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";   // final result
  String _input = "";     // current input
  double num1 = 0;
  double num2 = 0;
  String operand = "";

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _input = "";
        num1 = 0;
        num2 = 0;
        operand = "";
        _output = "0";
      } else if (buttonText == "+" || buttonText == "-" || buttonText == "×" || buttonText == "÷") {
        num1 = double.tryParse(_input) ?? 0;
        operand = buttonText;
        _input = "";
      } else if (buttonText == "=") {
        num2 = double.tryParse(_input) ?? 0;

        if (operand == "+") {
          _output = (num1 + num2).toString();
        } else if (operand == "-") {
          _output = (num1 - num2).toString();
        } else if (operand == "×") {
          _output = (num1 * num2).toString();
        } else if (operand == "÷") {
          _output = num2 != 0 ? (num1 / num2).toString() : "Error";
        }
        _input = _output;
        operand = "";
      } else {
        _input += buttonText;
        _output = _input;
      }
    });
  }

  Widget buildButton(String buttonText, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(22),
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                _output,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  buildButton("7", Colors.blue),
                  buildButton("8", Colors.blue),
                  buildButton("9", Colors.blue),
                  buildButton("÷", Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("4", Colors.blue),
                  buildButton("5", Colors.blue),
                  buildButton("6", Colors.blue),
                  buildButton("×", Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("1", Colors.blue),
                  buildButton("2", Colors.blue),
                  buildButton("3", Colors.blue),
                  buildButton("-", Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton("C", Colors.red),
                  buildButton("0", Colors.blue),
                  buildButton("=", Colors.green),
                  buildButton("+", Colors.orange),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
