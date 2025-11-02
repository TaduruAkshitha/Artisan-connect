import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerRequestScreen extends StatefulWidget {
  @override
  _CustomerRequestScreenState createState() => _CustomerRequestScreenState();
}

class _CustomerRequestScreenState extends State<CustomerRequestScreen> {
  final TextEditingController _requestController = TextEditingController();
  String? selectedCategory;
  double minPrice = 0;
  double maxPrice = 5000;
  final List<String> categories = [
    'Painting',
    'Sculpture',
    'Craft',
    'Photography',
    'Other'
  ];

  final CollectionReference requestsCollection =
      FirebaseFirestore.instance.collection('custom_requests');

  void submitRequest() async {
    if (_requestController.text.trim().isEmpty || selectedCategory == null)
      return;

    await requestsCollection.add({
      'requestText': _requestController.text.trim(),
      'category': selectedCategory,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _requestController.clear();
    setState(() {
      selectedCategory = null;
      minPrice = 0;
      maxPrice = 5000;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request submitted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Request'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _requestController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Describe your art requirement...',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                labelText: 'Select Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              items: categories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (val) => setState(() => selectedCategory = val),
            ),
            SizedBox(height: 16),
            Text(
                'Select Price Range (\$${minPrice.toInt()} - \$${maxPrice.toInt()})'),
            RangeSlider(
              values: RangeValues(minPrice, maxPrice),
              min: 0,
              max: 10000,
              divisions: 100,
              labels: RangeLabels(
                '\$${minPrice.toInt()}',
                '\$${maxPrice.toInt()}',
              ),
              onChanged: (values) {
                setState(() {
                  minPrice = values.start;
                  maxPrice = values.end;
                });
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: submitRequest,
              child: Text('Submit Request'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.deepPurpleAccent,
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
