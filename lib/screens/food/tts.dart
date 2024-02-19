import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:lottie/lottie.dart';
import 'package:nomnom/controller/food_screen_controller.dart';
import 'package:nomnom/models/food.dart';
import 'package:nomnom/screens/food/cart.dart';
import 'package:nomnom/utils/data_source.dart';
import 'package:nomnom/widgets/focused_layout.dart';
import 'package:nomnom/widgets/wrapper.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeakToOrder extends StatefulWidget {
  const SpeakToOrder({super.key});

  @override
  State<SpeakToOrder> createState() => _SpeakToOrderState();
}

class _SpeakToOrderState extends State<SpeakToOrder> {
  final fc = Get.find<FoodScreenController>();
  bool _speechEnabled = false;
  String _lastWords = '';
  bool isLoading = false;
  Dio dio = Dio();

  void fetchCart() async {
    setState(() {
      isLoading = true;
    });

    String url =
        'https://6b0c-2402-3a80-42b0-6132-5813-1500-3e17-6e4d.ngrok-free.app/extract';

    try {
      Response body = await dio.post(url, data: _lastWords);
      final data = body.data['data'];
      if (data != null && data.length > 0) {
        for (int i = 0; i < data.length; i++) {
          List<Food> temp = fc.menuItems
              .where((p0) =>
                  p0.name!.toLowerCase() ==
                  data[i]['dish'].toString().toLowerCase())
              .toList();
          if (temp.isNotEmpty) {
            int ix = fc.menuItems.indexOf(temp[0]);
            fc.orderAmt += (fc.menuItems[ix].price ?? 0);
            int q = fc.menuItems[ix].qty;
            fc.totalItems.value += 1;
            q += 1;
            fc.setFoodItems(fc.menuItems, ix, q);
          }
        }
        Get.off(() => Cart(), arguments: Get.arguments.routeMarker);
      } else {
        Get.back();
      }
    } on DioException catch (e) {
      print(e.error);
      print(e.message);
      print(e.response);
    }
  }

  void _startListening() async {
    await fc.speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await fc.speechToText.stop();
    setState(() {});
    print('world');
    // fetchCart();
  }

  @override
  void initState() {
    _startListening();
    // _stopListening();
    super.initState();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
    // fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
        child: FocusedLayout(
      fab: FloatingActionButton(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            fc.speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(fc.speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Text(
                'Ordering from traditional menu can be boring....\nTry It this way!',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              Lottie.asset('assets/images/tts.json'),
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Noted so far...',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    IconButton(
                        onPressed: () {
                          fetchCart();
                        },
                        icon: Icon(
                          EvaIcons.checkmarkCircle,
                          color: Colors.green,
                        ))
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    // If listening is active show the recognized words
                    fc.speechToText.isListening
                        ? '$_lastWords'
                        // If listening isn't active but could be tell the user
                        // how to start it, otherwise indicate that speech
                        // recognition is not yet ready or not supported on
                        // the target device
                        : _speechEnabled
                            ? 'Tap the microphone to start listening...'
                            : '$_lastWords',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
