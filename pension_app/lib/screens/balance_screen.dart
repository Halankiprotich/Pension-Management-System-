import 'package:flutter/material.dart';
import '../models/balance.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  final AuthService _authService = AuthService();
  final _memberNumberController = TextEditingController();
  Balance? _balance;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _memberNumberController.dispose();
    super.dispose();
  }

  Future<void> _fetchBalance() async {
    final memberNumber = _memberNumberController.text.trim();
    if (memberNumber.isEmpty) {
      setState(() => _error = 'Please enter a member number');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
      _balance = null;
    });
    try {
      final session = await _authService.getSession();
      if (session == null) {
        if (mounted) Navigator.pushReplacementNamed(context, AppConstants.loginRoute);
        return;
      }
      final balance = await _authService.apiService.getMemberBalance(memberNumber);
      setState(() => _balance = balance);
    } catch (e) {
      setState(() => _error = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Balance'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Check Balance',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Enter a member number to view their balance',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            // Search field
            TextFormField(
              controller: _memberNumberController,
              decoration: const InputDecoration(
                labelText: 'Member Number (e.g. PEN-001)',
                prefixIcon: Icon(Icons.badge_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            CustomButton(
              label: 'Get Balance',
              onPressed: _fetchBalance,
              isLoading: _isLoading,
            ),

            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(_error!,
                            style: const TextStyle(color: Colors.red))),
                  ],
                ),
              ),
            ],

            if (_balance != null) ...[
              const SizedBox(height: 28),

              // Balance card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.account_balance_wallet,
                        color: Colors.white70, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      _balance!.fullName,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'KES ${_balance!.totalContributions.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('Total Contributions',
                        style: TextStyle(color: Colors.white60, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Info rows
              _InfoRow(
                  label: 'Member Number',
                  value: _balance!.memberNumber,
                  icon: Icons.badge),
              _InfoRow(
                  label: 'Full Name',
                  value: _balance!.fullName,
                  icon: Icons.person),
              _InfoRow(
                label: 'Account Status',
                value: _balance!.active ? 'Active' : 'Inactive',
                icon: Icons.circle,
                valueColor: _balance!.active ? Colors.green : Colors.red,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label,
                  style: TextStyle(color: Colors.grey.shade600))),
          Text(value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black87,
              )),
        ],
      ),
    );
  }
}