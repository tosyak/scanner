import 'package:flutter/material.dart';
import 'package:connection_notifier/connection_notifier.dart';
import 'package:flutter/services.dart';

import 'numpad.dart';
import 'services/processing_services.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConnectionNotifier(
      /// Wrap [MaterialApp] with [ConnectionNotifier]
      child: MaterialApp(
        title: 'Danely SLV',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // QRScanner: const MyQRScannerPage(),
        home: const Scanner(),
      ),
    );
  }
}

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final FocusNode _focusNode = FocusNode();
  String _controller = '';
  String? _qrCode;
  String? connectionType;

  void getLink(qrCode) {
    linkID = qrCode;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danely SLV'),
      ),

      /// If you want to toggle some widgets based on connection state
      body: ConnectionNotifierToggler(
        onConnectionStatusChanged: (connected) {
          /// that means it is still in the initialization phase.
          if (connected == null) return;
          print(connected);
        },
        connected: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Center(
              key: UniqueKey(),
              child: const Text(
                'Connected',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 48,
                ),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Container(
              alignment: Alignment.center,
              child: DefaultTextStyle(
                style: textTheme.bodyText1!,
                child: RawKeyboardListener(
                  focusNode: _focusNode,
                  onKey: (RawKeyEvent event) {
                    if (event is RawKeyDownEvent) {
                      if (event.physicalKey == PhysicalKeyboardKey.enter) {
                        setState(() {
                          _qrCode = _controller;
                          _controller = '';
                        });
                      } else {
                        print(
                            '_handleKeyEvent Event data keyLabel ${event.data.keyLabel}');
                        _controller += event.data.keyLabel;
                      }
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _qrCode ?? 'Отсканируйте Код',
                        style: TextStyle(fontSize: 30),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: ElevatedButton(
                          child: const Text(
                            'Подтвердить',
                            style: TextStyle(fontSize: 30),
                          ),
                          onPressed: () {
                            if (_qrCode != null) {
                              getLink(_qrCode);
                              fetchProcessing();
                             
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const NumPadPage()),
                              );
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        disconnected: Center(
          key: UniqueKey(),
          child: const Text(
            'Disconnected',
            style: TextStyle(
              color: Colors.red,
              fontSize: 48,
            ),
          ),
        ),
      ),
    );
  }
}

//_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+
//

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'main.dart';
// import 'numpad.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   static const String _title = 'RawKeyboardListener';

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       QRScanner: Scaffold(
//         appBar: AppBar(title: const Text(_title)),
//         body: const QRScanner(),
//       ),
//     );
//   }
// }

// class QRScanner extends StatefulWidget {
//   const QRScanner({Key? key}) : super(key: key);

//   @override
//   _QRScannerState createState() => _QRScannerState();
// }

// class _QRScannerState extends State<QRScanner> {
//   final FocusNode _focusNode = FocusNode();

//   String _controller = '';

//   String? message;

//   @override
//   Widget build(BuildContext context) {
//     FocusScope.of(context).requestFocus(_focusNode);
//     final TextTheme textTheme = Theme.of(context).textTheme;
//     return Container(
//       color: Colors.white,
//       alignment: Alignment.center,
//       child: DefaultTextStyle(
//         style: textTheme.bodyText1!,
//         child: RawKeyboardListener(
//           focusNode: _focusNode,
//           onKey: (RawKeyEvent event) {
//             if (event is RawKeyDownEvent) {

//               if (event.physicalKey == PhysicalKeyboardKey.enter) {
//                 print('ENTER');
//                 setState(() {
//                   message = _controller;
//                   _controller = '';
//                 });
//               } else {
//                 // print(
//                 //     '_handleKeyEvent Event data keyLabel ${event.data.keyLabel}');
//                 _controller += event.data.keyLabel;
//               }
//               if (message != null) {
//                 print(' erwerwerwerwer message: $message');

//                 getLink(message);
//                 fetchProcessing();
//               }
//             }
//           },
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 message ?? 'Press a key',
//               ),
//               Text(
//                 '${message?.length}',
//               ),
//               Text(
//                 '${message?.length}',
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(40.0),
//                 child: ElevatedButton(
//                   child: const Text(
//                     'Подтвердить',
//                     style: TextStyle(fontSize: 30),
//                   ),
//                   onPressed: () {
//                     message = null;

//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const QRScannerPage()),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }
// }
