import 'package:flutter/material.dart';

class ScrapCollectionForm extends StatefulWidget {
  const ScrapCollectionForm({Key? key}) : super(key: key);

  @override
  _ScrapCollectionFormState createState() => _ScrapCollectionFormState();
}

class _ScrapCollectionFormState extends State<ScrapCollectionForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _scrapDetailsController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _scrapDetailsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // For now, no photo upload, just show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pickup scheduled successfully!')),
      );

      // Here you would save data to Firestore or backend later
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Scrap Pickup'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person, color: Colors.lightBlue),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Phone number field
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone, color: Colors.lightBlue),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Address field
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Pickup Address',
                  prefixIcon: Icon(Icons.location_on, color: Colors.lightBlue),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter pickup address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Scrap details field
              TextFormField(
                controller: _scrapDetailsController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Scrap Details (type, quantity)',
                  prefixIcon: Icon(Icons.description, color: Colors.lightBlue),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter scrap details';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Photo upload placeholder (no real upload yet)
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Photo upload coming soon!')),
                  );
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Upload Scrap Photo', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _submitForm,
                  child: Text(
                    'Schedule Pickup',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
