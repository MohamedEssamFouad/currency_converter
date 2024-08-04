import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  String fromCurrency = 'USD';
  String toCurrency = 'EUR';
  double rate = 0.0;
  double total = 0.0;
  TextEditingController amountController = TextEditingController();
  List<String> currencies = ['USD', 'EUR', 'GBP', 'JPY', 'AUD'];

  @override
  void initState() {
    super.initState();
    fetchRate();
  }

  Future<void> fetchRate() async {
    final response = await http.get(Uri.parse(
        'https://api.exchangerate-api.com/v4/latest/$fromCurrency'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        rate = data['rates'][toCurrency];
      });
    } else {
      throw Exception('Failed to load exchange rate');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1d2630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text('Currency Converter'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Image.network(
                'https://cdn-icons-png.freepik.com/512/2845/2845677.png',
                width: 250,
                height: 150,
              ),
            ),
            SizedBox(height: 25),
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(
                hintText: 'Amount',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    double amount = double.parse(value);
                    total = amount * rate;
                  });
                } else {
                  setState(() {
                    total = 0.0;
                  });
                }
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  child: DropdownButton<String>(
                    value: fromCurrency,
                    isExpanded: true,
                    dropdownColor: Color(0xFF1d2630),
                    style: TextStyle(color: Colors.white),
                    items: currencies.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        fromCurrency = newValue!;
                        fetchRate();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: DropdownButton<String>(
                    value: toCurrency,
                    isExpanded: true,
                    dropdownColor: Color(0xFF1d2630),
                    style: TextStyle(color: Colors.white),
                    items: currencies.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        toCurrency = newValue!;
                        fetchRate(); // Update rate when currency changes
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Converted Amount: $total $toCurrency',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
