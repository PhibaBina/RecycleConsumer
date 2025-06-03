import 'package:flutter/material.dart'; // Flutter material UI package

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key}); // Constructor

  @override
  State<WalletScreen> createState() => _WalletScreenState(); // Create state object
}

class _WalletScreenState extends State<WalletScreen> {
  // Dummy wallet balance
  double walletBalance = 1200.50;

  // Dummy credit history list with ₹ symbol
  final List<Map<String, String>> creditHistory = [
    {'date': '2025-05-25', 'amount': '+₹100', 'note': 'Pickup credit'},
    {'date': '2025-05-18', 'amount': '+₹50', 'note': 'Referral bonus'},
    {'date': '2025-05-10', 'amount': '+₹200', 'note': 'Subscription refund'},
  ];

  @override
  Widget build(BuildContext context) {
    // Build UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'), // App bar title
        backgroundColor: Colors.lightGreen, // Green background
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align left
          children: [
            Text('Current Balance', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8), // Vertical space
            Text('₹${walletBalance.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 24), // More vertical space
            Text('Credit History', style: Theme.of(context).textTheme.titleMedium),
            const Divider(), // Divider line
            Expanded(
              child: ListView.builder(
                itemCount: creditHistory.length, // Number of list items
                itemBuilder: (context, index) {
                  final item = creditHistory[index]; // Current item
                  return ListTile(
                    leading: const Icon(Icons.account_balance_wallet, color: Colors.green),
                    title: Text(item['amount']!),
                    subtitle: Text(item['note']!),
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
