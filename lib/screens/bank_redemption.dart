import 'package:flutter/material.dart'; // Flutter UI package

class BankRedemptionScreen extends StatefulWidget {
  const BankRedemptionScreen({super.key}); // Constructor

  @override
  State<BankRedemptionScreen> createState() => _BankRedemptionScreenState(); // Create state
}

class _BankRedemptionScreenState extends State<BankRedemptionScreen> {
  // Dummy redeemable balance
  double redeemableBalance = 900.00;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();

  // Dummy redemption history data with ₹ symbol
  final List<Map<String, String>> redemptionHistory = [
    {'date': '2025-05-20', 'amount': '₹100', 'status': 'Completed'},
    {'date': '2025-04-15', 'amount': '₹150', 'status': 'Pending'},
  ];

  // Submit redemption request function
  void _submitRedemption() {
    if (_formKey.currentState!.validate()) { // Validate form inputs
      final amount = double.parse(_amountController.text); // Parse amount

      if (amount > redeemableBalance) { // Check if amount exceeds balance
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Amount exceeds redeemable balance')),
        );
        return;
      }

      // Show success message (dummy)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Redemption request submitted for ₹${amount.toStringAsFixed(2)}')),
      );

      // Clear input fields
      _amountController.clear();
      _bankAccountController.clear();
    }
  }

  @override
  void dispose() {
    // Dispose controllers on widget removal
    _amountController.dispose();
    _bankAccountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Redemption'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding all around
        child: Column(
          children: [
            Text('Redeemable Balance: ₹${redeemableBalance.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 20), // Space

            // Redemption form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Amount input
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount to Redeem',
                      border: OutlineInputBorder(),
                      prefixText: '₹',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter amount';
                      final num? amount = num.tryParse(value);
                      if (amount == null || amount <= 0) return 'Enter valid amount';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Bank account input
                  TextFormField(
                    controller: _bankAccountController,
                    decoration: const InputDecoration(
                      labelText: 'Bank Account Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter bank account number';
                      if (value.length < 6) return 'Enter valid account number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Submit button
                  ElevatedButton(
                    onPressed: _submitRedemption,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Submit Redemption'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Redemption history title
            Text('Redemption History', style: Theme.of(context).textTheme.titleMedium),
            const Divider(),

            // Redemption history list
            Expanded(
              child: ListView.builder(
                itemCount: redemptionHistory.length,
                itemBuilder: (context, index) {
                  final item = redemptionHistory[index];
                  return ListTile(
                    leading: const Icon(Icons.monetization_on, color: Colors.green),
                    title: Text(item['amount']!),
                    subtitle: Text(item['status']!),
                    trailing: Text(item['date']!),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
