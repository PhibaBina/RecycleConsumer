import 'package:flutter/material.dart';

class OldClothesForm extends StatefulWidget {
  @override
  _OldClothesFormState createState() => _OldClothesFormState();
}

class _OldClothesFormState extends State<OldClothesForm> {
  String _donateOrSell = 'Old Clothes';

  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _conditionController = TextEditingController();
  final _pickupAddressController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    _conditionController.dispose();
    _pickupAddressController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // For now, just print the values
    print('Choice: $_donateOrSell');
    print('Item Name: ${_itemNameController.text}');
    print('Quantity: ${_quantityController.text}');
    print('Condition: ${_conditionController.text}');
    print('Pickup Address: ${_pickupAddressController.text}');
    if (_donateOrSell == 'Sell') {
      print('Price per Item: ${_priceController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Old Clothes Collection Form'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Option',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Donate'),
                    value: 'Donate',
                    groupValue: _donateOrSell,
                    onChanged: (value) {
                      setState(() {
                        _donateOrSell = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Sell'),
                    value: 'Sell',
                    groupValue: _donateOrSell,
                    onChanged: (value) {
                      setState(() {
                        _donateOrSell = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Item Name
            TextField(
              controller: _itemNameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.checkroom),
              ),
            ),
            SizedBox(height: 16),

            // Quantity
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.format_list_numbered),
              ),
            ),
            SizedBox(height: 16),

            // Condition
            TextField(
              controller: _conditionController,
              decoration: InputDecoration(
                labelText: 'Condition (e.g. New, Good, Worn)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.info_outline),
              ),
            ),
            SizedBox(height: 16),

            // Pickup Address
            TextField(
              controller: _pickupAddressController,
              decoration: InputDecoration(
                labelText: 'Pickup Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 16),

            // Price per Item — only show if Sell is selected
            if (_donateOrSell == 'Sell')
              Column(
                children: [
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Price per Item',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),

            // Upload photo button (no actual photo logic, just UI)
            ElevatedButton.icon(
              onPressed: () {
                // TODO: implement photo upload
              },
              icon: Icon(Icons.camera_alt),
              label: Text('Upload Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),

            SizedBox(height: 32),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
