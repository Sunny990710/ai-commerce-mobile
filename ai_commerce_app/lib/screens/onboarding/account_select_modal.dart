import 'package:flutter/material.dart';

class AccountSelectModal extends StatelessWidget {
  final VoidCallback onAccountSelected;
  final VoidCallback onAddAccount;

  const AccountSelectModal({
    super.key,
    required this.onAccountSelected,
    required this.onAddAccount,
  });

  static Future<void> show(BuildContext context, {required VoidCallback onComplete}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AccountSelectModal(
        onAccountSelected: () {
          Navigator.pop(ctx);
          onComplete();
        },
        onAddAccount: () {
          Navigator.pop(ctx);
          onComplete();
        },
      ),
    );
  }

  static const _mockAccounts = [
    ('이노플', 'innople@gmail.com', Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.25),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Center(
              child: Text('N', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87, fontStyle: FontStyle.italic)),
            ),
          ),
          const SizedBox(height: 16),
          const Text('계정 선택', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 4),
          Text('NightDream 계정으로 계속', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 24),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                ..._mockAccounts.map((a) => _AccountTile(
                  name: a.$1,
                  email: a.$2,
                  icon: a.$3,
                  onTap: onAccountSelected,
                )),
                _AccountTile(
                  name: '다른 계정 추가',
                  email: null,
                  icon: Icons.person_add,
                  onTap: onAddAccount,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final String name;
  final String? email;
  final IconData icon;
  final VoidCallback onTap;

  const _AccountTile({
    required this.name,
    this.email,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Icon(icon, color: Colors.grey.shade700, size: 24),
      ),
      title: Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
      subtitle: email != null ? Text(email!, style: TextStyle(fontSize: 13, color: Colors.grey[600])) : null,
      onTap: onTap,
    );
  }
}
