import 'package:flutter/material.dart';
import '../models/member.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final AuthService _authService = AuthService();
  List<Member> _members = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
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
      final members = await _authService.apiService.getMembers();
      setState(() => _members = members);
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
        title: const Text('Members'),
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
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(_error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(
                onPressed: _fetchMembers,
                child: const Text('Retry')),
          ],
        ),
      )
          : _members.isEmpty
          ? const Center(child: Text('No members found'))
          : RefreshIndicator(
        onRefresh: _fetchMembers,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _members.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final m = _members[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: AppConstants.primaryColor,
                  child: Text(
                    m.fullName.isNotEmpty
                        ? m.fullName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(m.fullName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${m.memberNumber}'),
                    if (m.email != null) Text(m.email!),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Chip(
                      label: Text(
                        m.active ? 'Active' : 'Inactive',
                        style: const TextStyle(fontSize: 11),
                      ),
                      backgroundColor: m.active
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      padding: EdgeInsets.zero,
                    ),
                    Text(
                      'KES ${m.totalContributions.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
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