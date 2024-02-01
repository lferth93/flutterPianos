import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pianos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Afinadores de piano en tu ciudad'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        'Esta es una calculadora para saber cuantos afinadores de pianos hay en su ciudad.'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        'Para el cálculo se asume que los pianos se afinan una vez al año y que cada afinador de pianos puede afinar 4 pianos al dia, por 5 dias a la semana, y que se toma 2 semanas de vacaciones al año.'),
                  ),
                  PianoForm(),
                ],
              ))),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PianoForm extends StatefulWidget {
  const PianoForm({super.key});

  @override
  State<PianoForm> createState() => _PianoFormState();
}

class _PianoFormState extends State<PianoForm> {
  double _currentSliderValue = 20;
  final _formKey = GlobalKey<FormState>();
  final poblacionController = TextEditingController();
  final familiaController = TextEditingController();
  int resultado = 0;

  void calcular() {
    setState(() {
      double p = double.parse(poblacionController.text);
      double f = double.parse(familiaController.text);
      double r = _currentSliderValue / 100.0;
      resultado = ((p * r) / (f * 1000)).round();
    });
  }

  String? validar(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo no puede estar vacio';
    }
    if (double.tryParse(value) == null) {
      return 'Valor no valido';
    }
    if (double.parse(value) == 0) {
      return 'El  valor no puede ser zero';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextFormField(
                validator: (value) => validar(value),
                controller: poblacionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Población',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextFormField(
                validator: (value) => validar(value),
                controller: familiaController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Personas por familia (promedio)',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter(RegExp(r'[0-9.]'), allow: true)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Familias con piano'),
                    Slider(
                      value: _currentSliderValue,
                      max: 100,
                      divisions: 100,
                      label: '${_currentSliderValue.round()}%',
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),
                    ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: 40, maxWidth: 40),
                      child: Text('${_currentSliderValue.round()}%'),
                    )
                  ]),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    calcular();
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Resultado'),
                        content: Text(
                            'Hay $resultado afinadores de pianos en su ciudad.'),
                      ),
                    );
                  }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.calculate), Text("Calcular")],
                )),
          ],
        ),
      ),
    );
  }
}
