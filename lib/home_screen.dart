import 'package:flutter/material.dart';
import 'customer_request_screen.dart';
import 'provider_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> categories = [
    'Painting',
    'Sculpture',
    'Craft',
    'Photography',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        title: Text('Artisan Connect'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGradientButton(
              context,
              text: 'I am a Customer',
              icon: Icons.person_add_alt_1,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CustomerRequestScreen()),
                );
              },
            ),
            SizedBox(height: 24),
            _buildGradientButton(
              context,
              text: 'I am a Provider',
              icon: Icons.people,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String? selectedCategory;
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text('Select your category'),
                      content: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: categories.map((cat) {
                          return DropdownMenuItem(value: cat, child: Text(cat));
                        }).toList(),
                        onChanged: (val) => selectedCategory = val,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (selectedCategory != null) {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProviderScreen(
                                      providerCategory: selectedCategory!),
                                ),
                              );
                            }
                          },
                          child: Text('Continue'),
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton(BuildContext context,
      {required String text,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.withOpacity(0.4),
              offset: Offset(0, 6),
              blurRadius: 12,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
