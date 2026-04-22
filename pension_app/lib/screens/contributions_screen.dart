import 'package:flutter/material.dart';
import '../models/contribution.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class ContributionsScreen extends StatefulWidget {
  const ContributionsScreen({super.key});

  @override
  State<ContributionsScreen> createState() => _ContributionsScreenState();
}

class _ContributionsScreenState extends State<ContributionsScreen> {
  final AuthService _authService = AuthService();
  List<Contribution> _contributions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchContributions();
  }

  Future<void> _fetchContributions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final session = await _authService.getSession();
      if (session == null) {
        if (mounted) Navigator.pushReplacementNamed(context, AppConstants.loginRoute);
        return;
      }
      final list = await _authService.apiService.getAllContributions();
      setState(() => _contributions = list);
    } catch (e) {
      setState(() => _error = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contributions'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(_error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(
                onPressed: _fetchContributions,
                child: const Text('Retry')),
          ],
        ),
      )
          : _contributions.isEmpty
          ? const Center(child: Text('No contributions found'))
          : RefreshIndicator(
        onRefresh: _fetchContributions,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _contributions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final c = _contributions[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                      Colors.green.shade100,
                      child: Icon(Icons.payments,
                          color: Colors.green.shade700),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(c.fullName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                          Text('Ref: ${c.memberNumber}',
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12)),
                          if (c.paymentMethod != null)
                            Text(c.paymentMethod!,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueGrey)),
                          Text(_formatDate(c.contributionDate),
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                    Text(
                      'KES ${c.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}