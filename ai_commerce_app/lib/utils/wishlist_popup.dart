import 'package:flutter/material.dart';

void showWishlistAddedPopup(BuildContext context, VoidCallback onGoTo) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '위시리스트 알림 닫기',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (ctx, _, __) => const SizedBox.shrink(),
    transitionBuilder: (ctx, anim, __, child) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.pop(ctx),
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(ctx).padding.bottom + 16,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2D2D),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '상품을 위시리스트에 담았어요.',
                          style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(ctx);
                          onGoTo();
                        },
                        child: Text(
                          '바로가기',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF64B5F6)),
                        ),
                      ),
                    ],
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
