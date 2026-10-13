import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  // Theme State (Feature 1: Theme Toggle)
  bool _isDarkMode = true;

  // Core Calculator State
  String _displayValue = '0';
  double? _runningTotal;
  String? _pendingOperator;
  bool _isNewOperand = true;
  bool _hasError = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _onDigitPressed(String digit) {
    if (_hasError) return;

    setState(() {
      if (_isNewOperand) {
        _displayValue = digit;
        _isNewOperand = false;
      } else {
        if (_displayValue == '0' && digit != '.') {
          _displayValue = digit;
        } else {
          if (digit == '.' && _displayValue.contains('.')) return;
          _displayValue += digit;
        }
      }
    });
  }

  void _onOperatorPressed(String operatorSymbol) {
    if (_hasError) return;

    double currentInput = double.tryParse(_displayValue) ?? 0.0;

    setState(() {
      if (_runningTotal == null) {
        _runningTotal = currentInput;
      } else if (_pendingOperator != null && !_isNewOperand) {
        _runningTotal = _calculate(_runningTotal!, currentInput, _pendingOperator!);
        if (_hasError) return;
        _displayValue = _formatResult(_runningTotal!);
      }

      _pendingOperator = operatorSymbol;
      _isNewOperand = true;
    });
  }

  void _onEqualsPressed() {
    if (_hasError || _pendingOperator == null) return;

    double currentInput = double.tryParse(_displayValue) ?? 0.0;

    setState(() {
      _runningTotal = _calculate(_runningTotal!, currentInput, _pendingOperator!);
      if (!_hasError) {
        _displayValue = _formatResult(_runningTotal!);
      }
      _pendingOperator = null;
      _isNewOperand = true;
      _runningTotal = null;
    });
  }

  // Feature 2: Clear / All Clear (AC)
  void _onClearPressed() {
    setState(() {
      _displayValue = '0';
      _runningTotal = null;
      _pendingOperator = null;
      _isNewOperand = true;
      _hasError = false;
    });
  }

  // Feature 3: Error Handling (Division by Zero)
  double _calculate(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '×':
        return a * b;
      case '÷':
        if (b == 0) {
          _hasError = true;
          _displayValue = 'Error';
          return 0.0;
        }
        return a / b;
      default:
        return b;
    }
  }

  String _formatResult(double value) {
    if (value.isNaN || value.isInfinite) {
      _hasError = true;
      return 'Error';
    }
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = _isDarkMode ? ThemeData.dark() : ThemeData.light();
    final backgroundColor = _isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5);
    final displayTextColor = _isDarkMode ? Colors.white : Colors.black;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('Flutter Calculator'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
              onPressed: _toggleTheme,
              tooltip: 'Toggle Theme',
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    _displayValue,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: displayTextColor,
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            _buildButton('AC', color: const Color(0xFFD35400), onPressed: _onClearPressed),
                            _buildButton('±', color: Colors.grey.shade700, onPressed: () {}),
                            _buildButton('%', color: Colors.grey.shade700, onPressed: () {}),
                            _buildButton('÷', color: const Color(0xFFE67E22), onPressed: () => _onOperatorPressed('÷')),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            _buildButton('7', onPressed: () => _onDigitPressed('7')),
                            _buildButton('8', onPressed: () => _onDigitPressed('8')),
                            _buildButton('9', onPressed: () => _onDigitPressed('9')),
                            _buildButton('×', color: const Color(0xFFE67E22), onPressed: () => _onOperatorPressed('×')),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            _buildButton('4', onPressed: () => _onDigitPressed('4')),
                            _buildButton('5', onPressed: () => _onDigitPressed('5')),
                            _buildButton('6', onPressed: () => _onDigitPressed('6')),
                            _buildButton('-', color: const Color(0xFFE67E22), onPressed: () => _onOperatorPressed('-')),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            _buildButton('1', onPressed: () => _onDigitPressed('1')),
                            _buildButton('2', onPressed: () => _onDigitPressed('2')),
                            _buildButton('3', onPressed: () => _onDigitPressed('3')),
                            _buildButton('+', color: const Color(0xFFE67E22), onPressed: () => _onOperatorPressed('+')),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade800,
                                    foregroundColor: Colors.white,
                                    shape: const StadiumBorder(),
                                  ),
                                  onPressed: () => _onDigitPressed('0'),
                                  child: const Text('0', style: TextStyle(fontSize: 24)),
                                ),
                              ),
                            ),
                            _buildButton('.', onPressed: () => _onDigitPressed('.')),
                            _buildButton('=', color: const Color(0xFFF39C12), onPressed: _onEqualsPressed),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, {Color? color, required VoidCallback onPressed}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey.shade800,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}