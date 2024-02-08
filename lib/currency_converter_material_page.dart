import 'dart:convert';

import 'package:currency_converter/key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CurrencyConverterMaterialPage extends StatefulWidget {
  const CurrencyConverterMaterialPage({super.key});

  @override
  State<CurrencyConverterMaterialPage> createState() =>
      _CurrencyConverterMaterialPageState();
}

class _CurrencyConverterMaterialPageState
    extends State<CurrencyConverterMaterialPage> {
  Future<Map<String, dynamic>> getCurrentCurrency() async {
    try {
      final result = await http.get(
        Uri.parse(
            'https://api.freecurrencyapi.com/v1/latest?apikey=$currencyAPIKey'),
      );
      final data = jsonDecode(result.body);
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  final TextEditingController textEditingController = TextEditingController();
  double result = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        title: const Text(
          'Currency Converter',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getCurrentCurrency(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          final data = snapshot.data!;
          final currentCurrency = data['data']['MXN'];
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${result.toStringAsFixed(2)} MXN',
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    onSubmitted: (value) {
                      setState(() {
                        result = double.parse(textEditingController.text) *
                            currentCurrency;
                      });
                    },
                    controller: textEditingController,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Please enter the amount in USD",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      prefixIcon: Icon(
                        Icons.monetization_on,
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d*$'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        result = double.parse(textEditingController.text) *
                            currentCurrency;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.maxFinite, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text("CONVERT"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
