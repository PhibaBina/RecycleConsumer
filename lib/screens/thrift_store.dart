import 'dart:io'; // For File handling
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore
import 'package:flutter/material.dart'; // Flutter UI widgets
// import 'package:image_picker/image_picker.dart'; // Disabled image picker import

// Stateful widget for the whole Thrift Store screen
class ThriftStoreScreen extends StatefulWidget {
  const ThriftStoreScreen({super.key});

  @override
  State<ThriftStoreScreen> createState() => _ThriftStoreScreenState();
}

// State class for ThriftStoreScreen with SingleTickerProviderStateMixin for tabs
class _ThriftStoreScreenState extends State<ThriftStoreScreen>
    with SingleTickerProviderStateMixin {
  
  late TabController _tabController; // Controller for TabBar

  // Seller form controllers
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final itemNameController = TextEditingController();
  final itemDescController = TextEditingController();
  final itemPriceController = TextEditingController();

  // File? selectedImage; // Disabled image selection
  // final picker = ImagePicker(); // Disabled image picker instance

  // Called when state is created
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Initialize tab controller with 2 tabs
  }

  // Called when widget is removed from tree - dispose controllers and tab controller
  @override
  void dispose() {
    _tabController.dispose();
    itemNameController.dispose();
    itemDescController.dispose();
    itemPriceController.dispose();
    super.dispose();
  }

  // Function to pick an image from gallery - disabled
  /*
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery); // Open gallery picker
    if (picked != null) { // If user picked an image
      setState(() {
        selectedImage = File(picked.path); // Save picked image as File
      });
    }
  }
  */

  // Function to submit the new item listing
  Future<void> submitItem() async {
    // Validate form only, image upload disabled
    if (!_formKey.currentState!.validate()) {
      // Show error message if validation fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return; // Stop execution if validation fails
    }

    try {
      // TODO: Upload image functionality disabled
      // Use placeholder image URL
      String imageUrl = 'https://via.placeholder.com/150';

      // Add item data to Firestore collection 'thrift_store_items'
      await FirebaseFirestore.instance.collection('thrift_store_items').add({
        'name': itemNameController.text.trim(),
        'description': itemDescController.text.trim(),
        'price': double.parse(itemPriceController.text.trim()),
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'available',
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item listed successfully!')),
      );

      // Clear all form fields
      itemNameController.clear();
      itemDescController.clear();
      itemPriceController.clear();
      // selectedImage = null; // disabled

    } catch (e) {
      // Show failure message with error details
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to list item: $e')),
      );
    }
  }

  // Widget for the Seller tab UI
  Widget sellerTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey, // Attach form key for validation
        child: ListView(
          children: [
            // Item Name input
            TextFormField(
              controller: itemNameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                prefixIcon: Icon(Icons.label, color: Colors.green),
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Enter item name' : null,
            ),
            const SizedBox(height: 12),

            // Item Description input (multiline)
            TextFormField(
              controller: itemDescController,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description, color: Colors.green),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) => value == null || value.isEmpty ? 'Enter description' : null,
            ),
            const SizedBox(height: 12),

            // Item Price input (numeric keyboard)
            TextFormField(
              controller: itemPriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                prefixIcon: Icon(Icons.currency_rupee, color: Colors.green), // Rupees icon
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter price';
                if (double.tryParse(value) == null) return 'Enter a valid number';
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Upload image label - disabled
            // Text('Upload Item Image', style: Theme.of(context).textTheme.titleMedium),
            // const SizedBox(height: 8),

            // Image picker container with gesture detection to pick image - disabled
            /*
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                  color: Colors.green.shade50,
                ),
                // Show picked image or placeholder icon
                child: selectedImage != null
                    ? Image.file(selectedImage!, fit: BoxFit.cover, width: double.infinity)
                    : const Center(
                        child: Icon(Icons.add_a_photo, size: 50, color: Colors.green),
                      ),
              ),
            ),
            */
            const SizedBox(height: 20),

            // Button to submit item listing
            ElevatedButton.icon(
              icon: const Icon(Icons.upload, color: Colors.white),
              label: const Text('List Item', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: submitItem, // Calls submitItem when pressed
            ),
          ],
        ),
      ),
    );
  }

  // Widget for the Buyer tab UI - shows list of available items from Firestore
  Widget buyerTab() {
    return StreamBuilder<QuerySnapshot>(
      // Listen to thrift_store_items collection filtered by available status
      stream: FirebaseFirestore.instance
          .collection('thrift_store_items')
          .where('status', isEqualTo: 'available')
          .orderBy('createdAt', descending: true) // Newest first
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Show error message if Firestore error occurs
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while waiting for data
          return const Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data!.docs; // Get list of documents

        if (items.isEmpty) {
          // Show message if no items found
          return const Center(child: Text('No items available'));
        }

        // ListView to display items
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final name = item['name'] ?? '';
            final desc = item['description'] ?? '';
            final price = item['price'] ?? 0;
            final imageUrl = item['imageUrl'] ??
                'https://via.placeholder.com/150'; // fallback image URL

            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                ),
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: Text('₹${price.toStringAsFixed(2)}', // Rupees symbol
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 16,
                    )),
                onTap: () {
                  // TODO: Implement item detail view or request buy feature
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Request to buy $name feature coming soon!')));
                },
              ),
            );
          },
        );
      },
    );
  }

  // Main build method that builds the Scaffold with AppBar and TabBar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thrift Store'),
        backgroundColor: Colors.green,
        bottom: TabBar(
          controller: _tabController, // Connect TabBar to controller
          tabs: const [
            Tab(icon: Icon(Icons.storefront), text: 'Seller'), // Seller tab
            Tab(icon: Icon(Icons.shopping_cart), text: 'Buyer'), // Buyer tab
          ],
          indicatorColor: Colors.white, // Color of the selected tab indicator
        ),
      ),
      body: TabBarView(
        controller: _tabController, // Connect TabBarView to controller
        children: [
          sellerTab(), // Seller tab content
          buyerTab(),  // Buyer tab content
        ],
      ),
    );
  }
}
