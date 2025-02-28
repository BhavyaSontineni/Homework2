import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String result = '';

  void buttonPressed(String value) {
    setState(() {
      if (value == '=') {
        try {
          result = _calculateResult(input);
        } catch (e) {
          result = 'Error';
        }
      } else if (value == 'C') {
        input = '';
        result = '';
      } else {
        input += value;
      }
    });
  }

  String _calculateResult(String input) {
    try {
      // Check for division by zero
      if (input.contains('/0')) {
        return 'Cannot divide by zero';
      }

      Parser p = Parser();
      Expression exp = p.parse(input);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return 'Error';
    }
  }

  Widget buildButton(String value) {
    return Expanded(
      child: InkWell(
        onTap: () => buttonPressed(value),
        child: Container(
          margin: EdgeInsets.all(5),
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CalculatorApp')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(input, style: TextStyle(fontSize: 32)),
                  Text(result, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Column(
            children: [
              ['7', '8', '9', '/'],
              ['4', '5', '6', '*'],
              ['1', '2', '3', '-'],
              ['C', '0', '=', '+'],
            ].map((row) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row.map((btn) => buildButton(btn)).toList(),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
