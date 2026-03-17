import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';
import 'item_select_for_advice_screen.dart';
import 'my_style_profile_screen.dart';
import 'product_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  final Set<String> wishIds;
  final void Function(Product) onToggleWish;
  final String? initialPrompt;
  final VoidCallback? onGoToCloset;
  final VoidCallback? onGoToCoordination;

  const ChatScreen({
    super.key,
    required this.wishIds,
    required this.onToggleWish,
    this.initialPrompt,
    this.onGoToCloset,
    this.onGoToCoordination,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialPrompt != null && widget.initialPrompt!.isNotEmpty) {
      _controller.text = widget.initialPrompt!;
    }
    _messages.add(ChatMessage(
      role: 'assistant',
      content: '안녕하세요! AI 스타일리스트예요. 찾으시는 스타일이나 상황을 말씀해 주시면 딱 맞는 아이템을 찾아드릴게요.',
      products: null,
    ));
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty || _isLoading) return;
    final userMsg = text.trim();
    _controller.clear();
    setState(() {
      _messages.add(ChatMessage(role: 'user', content: userMsg, products: null));
      _isLoading = true;
    });
    _scrollToBottom();

    final res = await ApiService.aiSearch(userMsg);
    setState(() {
      _messages.add(ChatMessage(role: 'assistant', content: res.message, products: res.products.isEmpty ? null : res.products));
      _isLoading = false;
    });
    _scrollToBottom();
  }

  @override
  void didUpdateWidget(covariant ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPrompt != null &&
        widget.initialPrompt != oldWidget.initialPrompt &&
        widget.initialPrompt!.isNotEmpty) {
      _controller.text = widget.initialPrompt!;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  bool get _showWelcomeView => _messages.length <= 1 && !_isLoading;

  void _resetToWelcome() {
    if (_isLoading) return;
    setState(() {
      _messages.clear();
      _messages.add(ChatMessage(
        role: 'assistant',
        content: '안녕하세요! AI 스타일리스트예요. 찾으시는 스타일이나 상황을 말씀해 주시면 딱 맞는 아이템을 찾아드릴게요.',
        products: null,
      ));
      _controller.clear();
    });
  }

  void _showAddItemModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).padding.bottom),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 24),
              const Text('새 아이템 추가', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              Text('나에게 가장 잘 맞는 방법을 선택하세요', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              const SizedBox(height: 24),
              _AddItemOption(
                icon: Icons.photo_library_outlined,
                iconColor: const Color(0xFFE8A54B),
                label: '갤러리에서 업로드',
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('갤러리에서 업로드는 준비 중이에요')));
                },
              ),
              _AddItemOption(
                icon: Icons.camera_alt_outlined,
                iconColor: const Color(0xFFE8B4B8),
                label: '사진 찍기',
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('사진 찍기는 준비 중이에요')));
                },
              ),
              _AddItemOption(
                icon: Icons.checkroom_outlined,
                iconColor: const Color(0xFFB8A9E8),
                label: '옷장',
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onGoToCloset?.call();
                },
              ),
              _AddItemOption(
                icon: Icons.style_outlined,
                iconColor: const Color(0xFF98D4BB),
                label: '코디',
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onGoToCoordination?.call();
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('대화', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: false,
        elevation: 0,
        leading: _showWelcomeView
            ? null
            : IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.grey[700], size: 20),
                onPressed: _resetToWelcome,
              ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.grey[700]),
            onPressed: () => _showChatMenu(context, _resetToWelcome),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _showWelcomeView ? _buildWelcomeView() : _buildMessageList(),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildWelcomeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          _buildStylistIcon(),
          const SizedBox(height: 28),
          Text(
            '안녕하세요! AI 스타일리스트예요.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildHighlightedDescription(),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  '아이템 조언',
                  Icons.lightbulb_outline,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ItemSelectForAdviceScreen(
                          wishIds: widget.wishIds,
                          onToggleWish: widget.onToggleWish,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildActionButton('코디 추천', Icons.checkroom)),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStylistIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: const Color(0xFF90CAF9).withOpacity(0.3), blurRadius: 16, spreadRadius: 2)],
      ),
      child: Icon(Icons.checkroom, size: 40, color: Colors.blue[700]),
    );
  }

  Widget _buildHighlightedDescription() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
        children: [
          const TextSpan(text: '찾으시는 스타일이나 상황을 말씀해 주시면\n딱 맞는 아이템을 찾아드릴게요.'),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, {VoidCallback? onTap}) {
    return OutlinedButton(
      onPressed: onTap ?? () => _send(label),
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFFF5F5F0),
        foregroundColor: Colors.black87,
        side: BorderSide(color: Colors.grey[300]!),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showChatMenu(BuildContext context, VoidCallback onResetToWelcome) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, _, __) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, __, child) {
        return Stack(
          children: [
            GestureDetector(onTap: () => Navigator.pop(ctx), child: Container(color: Colors.transparent)),
            SlideTransition(
              position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: Align(
                alignment: Alignment.centerRight,
                child: Material(
                  color: Colors.white,
                  child: SizedBox(
                    width: MediaQuery.of(ctx).size.width * 0.82,
                    child: _ChatMenuContent(
                      parentContext: ctx,
                      onClose: () => Navigator.pop(ctx),
                      onNewChat: () {
                        Navigator.pop(ctx);
                        onResetToWelcome();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputBar() {
    const skyBlue = Color(0xFF64B5F6);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      color: Colors.grey[50],
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => _showAddItemModal(context),
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: skyBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 22),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: '스타일에 대해 무엇이든 물어보세요',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
                onSubmitted: _send,
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: () => _send(_controller.text),
              style: IconButton.styleFrom(backgroundColor: skyBlue, foregroundColor: Colors.white),
              icon: const Icon(Icons.arrow_upward, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (_, i) {
                if (i == _messages.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        CircleAvatar(radius: 14, backgroundColor: Colors.purple[100], child: const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))),
                        const SizedBox(width: 8),
                        Text('AI 분석 중...', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                      ],
                    ),
                  );
                }
                final msg = _messages[i];
                if (msg.role == 'user') {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
                      child: Text(msg.content, style: const TextStyle(fontSize: 14)),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(radius: 14, backgroundColor: Colors.purple[100], child: Icon(Icons.auto_awesome, size: 16, color: Colors.purple[700])),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Text(msg.content, style: const TextStyle(fontSize: 14)),
                              ),
                              if (msg.products != null && msg.products!.isNotEmpty) ...[
                                SizedBox(
                                    height: 220,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: msg.products!.length,
                                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                                      itemBuilder: (_, j) {
                                        final p = msg.products![j];
                                        return SizedBox(
                                          width: 140,
                                          child: ProductCard(
                                            product: p,
                                            isBestPick: j == 0,
                                            isWished: widget.wishIds.contains(p.id),
                                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p, wishIds: widget.wishIds, onToggleWish: widget.onToggleWish))),
                                            onWish: () => widget.onToggleWish(p),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: ['더 저렴한 것 보여줘', '비슷한 스타일 더 보여줘', '다른 브랜드'].map((chip) => ActionChip(
                                      label: Text(chip, style: const TextStyle(fontSize: 11)),
                                      onPressed: () => _send(chip),
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    )).toList(),
                                  ),
                                ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
    );
  }
}

class ChatMessage {
  final String role;
  final String content;
  final List<Product>? products;
  ChatMessage({required this.role, required this.content, this.products});
}

class _AddItemOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _AddItemOption({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 22),
    );
  }
}

class _ChatMenuContent extends StatelessWidget {
  final BuildContext parentContext;
  final VoidCallback onClose;
  final VoidCallback onNewChat;

  const _ChatMenuContent({required this.parentContext, required this.onClose, required this.onNewChat});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: onClose,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: GestureDetector(
              onTap: () {
                onClose();
                Navigator.push(parentContext, MaterialPageRoute(builder: (_) => const MyStyleProfileScreen()));
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: const Color(0xFFE3F2FD), shape: BoxShape.circle),
                    child: Icon(Icons.person_outline, color: Colors.blue[700], size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('내 스타일 프로필', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                  Icon(Icons.chevron_right, color: Colors.grey[400], size: 22),
                ],
              ),
            ),
          ),
          _MenuTile(icon: Icons.add_comment_outlined, label: '새 대화', onTap: onNewChat),
          _MenuTile(icon: Icons.auto_awesome, label: 'AI 코디 추천', onTap: () => onClose()),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('고객 지원', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[600])),
          ),
          const SizedBox(height: 8),
          _MenuTile(icon: Icons.help_outline, label: '문의하기', onTap: () => onClose()),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 22, color: Colors.grey[700]),
      title: Text(label, style: const TextStyle(fontSize: 15)),
      onTap: onTap,
    );
  }
}
