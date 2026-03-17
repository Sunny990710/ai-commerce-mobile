import 'package:flutter/material.dart';

class TermsModal extends StatefulWidget {
  final VoidCallback onAgree;
  final VoidCallback onClose;

  const TermsModal({
    super.key,
    required this.onAgree,
    required this.onClose,
  });

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TermsModal(
        onAgree: () => Navigator.pop(ctx, true),
        onClose: () => Navigator.pop(ctx, false),
      ),
    );
  }

  @override
  State<TermsModal> createState() => _TermsModalState();
}

class _TermsModalState extends State<TermsModal> {
  bool _allAgreed = false;
  bool _serviceAgreed = false;
  bool _privacyAgreed = false;

  bool get _canProceed => _serviceAgreed && _privacyAgreed;

  void _toggleAll(bool v) {
    setState(() {
      _allAgreed = v;
      _serviceAgreed = v;
      _privacyAgreed = v;
    });
  }

  void _toggleService(bool v) {
    setState(() {
      _serviceAgreed = v;
      _allAgreed = _serviceAgreed && _privacyAgreed;
    });
  }

  void _togglePrivacy(bool v) {
    setState(() {
      _privacyAgreed = v;
      _allAgreed = _serviceAgreed && _privacyAgreed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          const Text('이용 약관', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 24),
          _CheckTile(
            label: '모두 동의합니다',
            value: _allAgreed,
            onChanged: _toggleAll,
          ),
          _CheckTile(
            label: '서비스 이용 약관 동의 [필수]',
            value: _serviceAgreed,
            onChanged: _toggleService,
            trailing: true,
          ),
          _CheckTile(
            label: '개인정보 수집 및 이용 동의 [필수]',
            value: _privacyAgreed,
            onChanged: _togglePrivacy,
            trailing: true,
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _canProceed ? widget.onAgree : null,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black87,
                  disabledBackgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('동의하고 계속하기'),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _CheckTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool trailing;

  const _CheckTile({required this.label, required this.value, required this.onChanged, this.trailing = false});

  @override
  Widget build(BuildContext context) {
    final isRequired = label.contains('[필수]');
    return ListTile(
      leading: GestureDetector(
        onTap: () => onChanged(!value),
        child: Icon(value ? Icons.check_circle : Icons.circle_outlined, color: isRequired ? Colors.blue : Colors.grey, size: 24),
      ),
      title: Text(label, style: TextStyle(fontSize: 15, color: isRequired ? Colors.blue : Colors.black87)),
      trailing: trailing ? Icon(Icons.chevron_right, color: Colors.grey[400], size: 20) : null,
      onTap: () => onChanged(!value),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
