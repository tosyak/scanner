import 'package:flutter/material.dart';

import 'finalpage.dart';
import 'services/processing_services.dart';


class NumPadPage extends StatefulWidget {
  const NumPadPage({Key? key}) : super(key: key);

  @override
  _NumPadPageState createState() => _NumPadPageState();
}

class _NumPadPageState extends State<NumPadPage> {
  final TextEditingController _myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danely SLV'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 10,
              child: Center(
                child: Text(
                  //
                  // при переходе на данную страницу должна отображаться строка из переменной processingName
                  // полученногой из JSON посредством fetchProcessing()
                  //
                  processingName,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
                child: TextField(
              controller: _myController,
              textAlign: TextAlign.center,
              showCursor: false,
              style: const TextStyle(fontSize: 40),
              keyboardType: TextInputType.none,
            )),
          ),
          NumPad(
            buttonSize: 75,
            buttonColor: Colors.amber,
            iconColor: Colors.deepOrange,
            controller: _myController,
            delete: () {
              if (_myController.text.length > 0) {
                _myController.text = _myController.text
                    .substring(0, _myController.text.length - 1);
              }
            },
            onSubmit: () {
              processingQuantity = num.tryParse(_myController.text)?.toDouble();
              postRequest();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FinalPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class NumPad extends StatelessWidget {
  final double buttonSize;
  final Color buttonColor;
  final Color iconColor;
  final TextEditingController controller;
  final Function delete;
  final Function onSubmit;

  const NumPad({
    Key? key,
    this.buttonSize = 70,
    this.buttonColor = Colors.indigo,
    this.iconColor = Colors.amber,
    required this.delete,
    required this.onSubmit,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      margin: const EdgeInsets.only(left: 190, right: 190),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                number: 1,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 2,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 3,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                number: 4,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 5,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 6,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NumberButton(
                number: 7,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 8,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              NumberButton(
                number: 9,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () => delete(),
                icon: Icon(
                  Icons.backspace,
                  color: iconColor,
                ),
                iconSize: buttonSize,
              ),
              NumberButton(
                number: 0,
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              DotButton(
                dot: ".",
                size: buttonSize,
                color: buttonColor,
                controller: controller,
              ),
              // IconButton(
              //   onPressed: () => onSubmit(),
              //   icon: Icon(
              //     Icons.done_rounded,
              //     color: iconColor,
              //   ),
              //   iconSize: buttonSize,
              // ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => onSubmit(),
                child: Text(
                  'Подтвердить',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final int number;
  final double size;
  final Color color;
  final TextEditingController controller;

  const NumberButton({
    Key? key,
    required this.number,
    required this.size,
    required this.color,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size / 2),
          ),
        ),
        onPressed: () {
          controller.text += number.toString();
        },
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
          ),
        ),
      ),
    );
  }
}

class DotButton extends StatelessWidget {
  final String dot;
  final double size;
  final Color color;
  final TextEditingController controller;

  const DotButton({
    Key? key,
    required this.dot,
    required this.size,
    required this.color,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size / 2),
          ),
        ),
        onPressed: () {
          controller.text += dot.toString();
        },
        child: Center(
          child: Text(
            dot.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30),
          ),
        ),
      ),
    );
  }
}
