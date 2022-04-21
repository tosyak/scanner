import 'package:flutter/material.dart';

import 'scanner.dart';
import 'services/processing_services.dart';


class FinalPage extends StatefulWidget {
  const FinalPage({Key? key}) : super(key: key);

  @override
  _FinalPageState createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  void resetVariables() {
    processingName = '';
    processingQuantity = null;
    linkID = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danely SLV'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: <Widget>[
                Text(
                  'Тех.Операция отправляется',
                  style: TextStyle(fontSize: 60),
                ),
                SizedBox(
                  height: 40,
                ),
                //
                //
                // Нужно что-бы кнопка активировалась после
                // успешной отправки данных на сервер postRequest()
                //
                //
                ElevatedButton(
                    // onPressed: postRequestStatus
                    //     ? () => () {
                    //           clearAll();
                    //           Navigator.pushReplacement(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => const Scanner()),
                    //           );
                    //         }
                    //     : null,
                    onPressed: () {
                      resetVariables();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Scanner()),
                      );
                    },
                    child: const Text(
                      'Подтвердить',
                      style: TextStyle(fontSize: 40),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
