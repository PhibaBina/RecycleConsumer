import 'dart:io'; // For File handling (image)
import 'package:flutter/material.dart'; // Flutter UI package
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore database
import 'package:firebase_auth/firebase_auth.dart'; // For user authentication
import 'package:intl/intl.dart'; // For date formatting

// BookPickupScreen Stateful Widget
class BookPickupScreen extends StatefulWidget {
  const BookPickupScreen({super.key});

  @override
  State<BookPickupScreen> createState() => _BookPickupScreenState();
}

// State class for BookPickupScreen
class _BookPickupScreenState extends State<BookPickupScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final phoneController = TextEditingController(); // Phone input controller
  final addressController = TextEditingController(); // Address input controller
  DateTime? selectedDate; // Selected pickup date
  TimeOfDay? selectedTime; // Selected pickup time
  File? selectedImage; // Selected image file
  final picker = ImagePicker(); // Image picker instance

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  // Function to submit the pickup form
  Future<void> _submitForm() async {
    // Validate form and check required fields
    if (!_formKey.currentState!.validate() || selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete the form.')),
      );
      return;
    }

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid; // Get logged-in user's UID

      // Create pickup data map
      final pickupData = {
        'uid': uid,
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'pickupDate': DateFormat('yyyy-MM-dd').format(selectedDate!),
        'pickupTime': selectedTime!.format(context),
        'status': 'pending', // Initial status
        'createdAt': FieldValue.serverTimestamp(), // Firestore server time
      };

      // Save to Firestore
      await FirebaseFirestore.instance.collection('pickup_requests').add(pickupData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pickup Booked Successfully!')),
      );

      // Clear form after submission
      setState(() {
        phoneController.clear();
        addressController.clear();
        selectedDate = null;
        selectedTime = null;
        selectedImage = null;
      });
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book pickup: $e')),
      );
    }
  }

  // Stream to fetch the most recent pickup status for the current user
  Stream<DocumentSnapshot<Map<String, dynamic>>?> getLatestPickupStatus() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('pickup_requests')
        .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty ? snapshot.docs.first : null);
  }

  // Main UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Pickup'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign form key
          child: ListView(
            children: [

              

              // Phone Number Field
              _buildTextField(
                label: 'Phone Number',
                controller: phoneController,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),

              // Address Field
              _buildTextField(
                label: 'Address',
                controller: addressController,
                icon: Icons.home,
                
              ),

              const SizedBox(height: 8),

              // Photo Upload
              const Text("Upload Photo", style: TextStyle(fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green),
                  ),
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(selectedImage!, fit: BoxFit.cover, width: double.infinity),
                        )
                      : const Center(
                          child: Icon(Icons.add_a_photo, size: 40, color: Colors.green),
                        ),
                ),
              ),

              const SizedBox(height: 10),

              // Pickup Date Picker
              _buildPickerTile(
                icon: Icons.calendar_today,
                label: "Select Pickup Date",
                value: selectedDate != null
                    ? DateFormat('yMMMd').format(selectedDate!)
                    : null,
                onTap: _pickDate,
              ),

              const SizedBox(height: 10),

              // Pickup Time Picker
              _buildPickerTile(
                icon: Icons.access_time,
                label: "Select Pickup Time",
                value: selectedTime != null
                    ? selectedTime!.format(context)
                    : null,
                onTap: _pickTime,
              ),

              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton.icon(
                onPressed: _submitForm,
                label: const Text('Confirm booking', style: TextStyle(fontSize: 16, color: Colors.white,)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Text field builder with icon
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon, color: Colors.green) : null,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  // Picker Tile builder (used for date/time)
  Widget _buildPickerTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    String? value,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 233, 232, 232),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value ?? label,
                style: TextStyle(
                  color: value != null ? Colors.black : Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  // Function to pick date
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)), // default to tomorrow
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  // Function to pick time
  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) setState(() => selectedTime = picked);
  }
}
