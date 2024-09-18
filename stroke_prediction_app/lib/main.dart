import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stroke Prediction',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const StrokePredictionPage(),
    );
  }
}

class StrokePredictionPage extends StatefulWidget {
  const StrokePredictionPage({super.key});

  @override
  _StrokePredictionPageState createState() => _StrokePredictionPageState();
}

class _StrokePredictionPageState extends State<StrokePredictionPage> {
  late Interpreter _interpreter;
  bool _isDarkMode = false;
  String _result = '';

  // Input controllers
  final TextEditingController _ageController =
      TextEditingController(text: '30.00');
  final TextEditingController _bmiController =
      TextEditingController(text: '20.00');
  final TextEditingController _glucoseController =
      TextEditingController(text: '50');
  String _gender = 'Female';
  String _residenceType = 'Urban';
  int _heartDisease = 0;
  int _hypertension = 0;
  bool _everMarried = true;
  String _workType = 'Private';
  String _smokingStatus = 'smokes';

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/stroke_model.tflite');
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _predictStroke() async {
    // Collect input data
    double age = double.parse(_ageController.text);
    double bmi = double.parse(_bmiController.text);
    double glucose = double.parse(_glucoseController.text);

    // Prepare the input data
    List<List<double>> input = [
      [
        _gender == 'Male' ? 1.0 : 0.0, // Gender
        age, // Age
        _hypertension.toDouble(), // Hypertension
        _heartDisease.toDouble(), // Heart Disease
        _everMarried ? 1.0 : 0.0, // Ever Married
        _workType == 'Private' ? 1.0 : 0.0, // Work Type (simplified)
        _residenceType == 'Urban' ? 1.0 : 0.0, // Residence Type
        glucose, // Average Glucose Level
        bmi, // BMI
        _smokingStatus == 'smokes' ? 1.0 : 0.0 // Smoking Status (simplified)
      ]
    ];

    // Prepare output array
    List<double> output =
        List.filled(1, 0); // Assuming a binary classification model

    // Run the model
    _interpreter.run(input, output);

    // Interpret the output
    setState(() {
      double probabilityStroke = output[0]; // Get probability for stroke

      _result = probabilityStroke > 0.5
          ? 'Potential Stroke'
          : 'No Stroke'; // Adjust threshold if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stroke Prediction App'),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSlider('Age:', _ageController, 0, 100),
              _buildSlider('BMI:', _bmiController, 0, 100),
              _buildSlider('Glucose Level:', _glucoseController, 0, 300),
              _buildRadioButtons('Gender:', ['Male', 'Female'],
                  (val) => setState(() => _gender = val!)),
              _buildRadioButtons('Residence Type', ['Urban', 'Rural'],
                  (val) => setState(() => _residenceType = val!)),
              _buildRadioButtons('Heart Disease', ['0', '1'],
                  (val) => setState(() => _heartDisease = int.parse(val!))),
              _buildRadioButtons('Hypertension', ['0', '1'],
                  (val) => setState(() => _hypertension = int.parse(val!))),
              _buildRadioButtons('Ever Married', ['No', 'Yes'],
                  (val) => setState(() => _everMarried = val == 'Yes')),
              _buildDropdown(
                  'Work Type',
                  [
                    'Private',
                    'Self-employed',
                    'Govt_job',
                    'children',
                    'Never_worked'
                  ],
                  _workType,
                  (val) => setState(() => _workType = val!)),
              _buildDropdown(
                  'Smoking Status',
                  ['formerly smoked', 'never smoked', 'smokes', 'Unknown'],
                  _smokingStatus,
                  (val) => setState(() => _smokingStatus = val!)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _predictStroke,
                child: const Text('Predict Stroke'),
              ),
              const SizedBox(height: 20),
              Text('Result: $_result',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(
      String label, TextEditingController controller, double min, double max) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: double.parse(controller.text),
                min: min,
                max: max,
                onChanged: (value) =>
                    setState(() => controller.text = value.toStringAsFixed(2)),
              ),
            ),
            const SizedBox(width: 16),
            Text(controller.text),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioButtons(
      String label, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Row(
          children: options
              .map((option) => Expanded(
                    child: RadioListTile<String>(
                      title: Text(option),
                      value: option,
                      groupValue: label.contains('Gender')
                          ? _gender
                          : label.contains('Residence')
                              ? _residenceType
                              : label.contains('Heart')
                                  ? _heartDisease.toString()
                                  : label.contains('Hypertension')
                                      ? _hypertension.toString()
                                      : _everMarried
                                          ? 'Yes'
                                          : 'No',
                      onChanged: onChanged,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> options, String value,
      Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: options
              .map((option) =>
                  DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }
}
