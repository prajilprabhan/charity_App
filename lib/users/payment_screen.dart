import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seechange/services/notification_service.dart';
import 'package:seechange/users/receipt_screen.dart';

class PaymentScreen extends StatefulWidget {
  final DocumentSnapshot charityDoc;

  const PaymentScreen({super.key, required this.charityDoc});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  String _selectedMethod = 'UPI';
  bool _isProcessing = false;

  final List<String> _paymentMethods = [
    'UPI',
    'Credit Card',
    'Debit Card',
    'Wallet',
    'Net Banking'
  ];

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      final double amount = double.parse(_amountController.text.trim());
      final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
      
      // Fetch donor name
      final donorSnap = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
      final String donorName = donorSnap.exists ? (donorSnap.data()?['name'] ?? 'Anonymous Donor') : 'Anonymous Donor';

      // Charity details
      final charityId = widget.charityDoc.id;
      final charityData = widget.charityDoc.data() as Map<String, dynamic>;
      final String charityPurpose = charityData['purpose'] ?? 'Charity Campaign';
      final String? orgId = charityData['organization_id'];
      final double currentCollected = (charityData['collected_amount'] ?? 0.0) as double;

      // Unique transaction ID
      final String txnId = 'TXN-${DateTime.now().millisecondsSinceEpoch}';

      // 1. Save Transaction record
      await FirebaseFirestore.instance.collection('transactions').doc(txnId).set({
        'transactionId': txnId,
        'charityId': charityId,
        'charityName': charityPurpose,
        'donorId': currentUserId,
        'donorName': donorName,
        'amount': amount,
        'paymentMethod': _selectedMethod,
        'status': 'success',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 2. Save Donation record
      await FirebaseFirestore.instance.collection('donations').add({
        'donationId': 'DON-${DateTime.now().millisecondsSinceEpoch}',
        'transactionId': txnId,
        'charityId': charityId,
        'charityName': charityPurpose,
        'donorId': currentUserId,
        'donorName': donorName,
        'amount': amount,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 3. Update Charity collected_amount
      await FirebaseFirestore.instance.collection('charity').doc(charityId).update({
        'collected_amount': currentCollected + amount,
      });

      // 4. Send notification to Donor
      await NotificationService.sendNotification(
        userId: currentUserId,
        title: 'Donation Successful',
        body: 'Thank you! Your donation of ₹${amount.toStringAsFixed(0)} to "$charityPurpose" was successful. Transaction ID: $txnId',
        type: 'donation',
      );

      // 5. Send notification to Host Organization
      if (orgId != null) {
        await NotificationService.sendNotification(
          userId: orgId,
          title: 'Donation Received',
          body: 'Your campaign "$charityPurpose" received a donation of ₹${amount.toStringAsFixed(0)} from $donorName.',
          type: 'donation',
        );
      }

      if (mounted) {
        // Navigate to receipt screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ReceiptScreen(transactionId: txnId),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final charityData = widget.charityDoc.data() as Map<String, dynamic>;
    final purpose = charityData['purpose'] ?? 'Charity Campaign';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text('Secure Payment', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isProcessing
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.teal),
                    const SizedBox(height: 24),
                    Text(
                      'Simulating Payment Gateway...',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
                    ),
                    const SizedBox(height: 8),
                    const Text('Please do not close the app or press back.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Donating to:',
                        style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        purpose,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: 'Donation Amount (INR)',
                          prefixText: '₹ ',
                          labelStyle: const TextStyle(fontSize: 16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Amount is required';
                          }
                          final amt = double.tryParse(value);
                          if (amt == null || amt <= 0) {
                            return 'Enter a valid amount';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Select Payment Method',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: _paymentMethods.map((method) {
                          IconData methodIcon;
                          switch (method) {
                            case 'UPI':
                              methodIcon = Icons.send_to_mobile;
                              break;
                            case 'Credit Card':
                            case 'Debit Card':
                              methodIcon = Icons.credit_card;
                              break;
                            case 'Wallet':
                              methodIcon = Icons.account_balance_wallet;
                              break;
                            default:
                              methodIcon = Icons.account_balance;
                          }

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: _selectedMethod == method ? Colors.teal : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            elevation: 1,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: RadioListTile<String>(
                              activeColor: Colors.teal,
                              value: method,
                              groupValue: _selectedMethod,
                              title: Row(
                                children: [
                                  Icon(methodIcon, color: Colors.teal.shade700),
                                  const SizedBox(width: 12),
                                  Text(method, style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _selectedMethod = val!;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _processPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'Pay Securely',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
