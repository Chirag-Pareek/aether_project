import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:aether_project/core/theme/app_colors.dart';
import 'package:aether_project/core/utils/bouncing_button.dart';
import 'package:aether_project/raid_service.dart';

class ChatBox extends StatefulWidget {
  final RaidService raidService;
  final String userId;

  const ChatBox({
    super.key,
    required this.raidService,
    required this.userId,
  });

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      SystemSound.play(SystemSoundType.click);
      unawaited(widget.raidService.sendMessage(_controller.text.trim(), widget.userId));
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 80),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: widget.raidService.chatStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Chat Error', style: TextStyle(color: AppColors.textAccent)));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator(color: AppColors.buttonBg));
              }

              final docs = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                reverse: true, // Show latest messages at the bottom
                itemCount: docs.length,
                padding: const EdgeInsets.only(bottom: 8.0),
                itemBuilder: (context, index) {
                  return _ChatBubble(
                    key: ValueKey(docs[index].id),
                    messageId: docs[index].id,
                    data: docs[index].data(),
                  );
                },
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // Input Area
        Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.chatInputBg,
                  border: Border.all(color: AppColors.panelBorder, width: 2),
                ),
                child: TextField(
                  controller: _controller,
                  showCursor: false,
                  textAlignVertical: TextAlignVertical.center,
                  style: GoogleFonts.vt323(color: AppColors.textPrimary, fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 12, bottom: 8),
                    isDense: true,
                    hintText: 'Type message...',
                    hintStyle: GoogleFonts.vt323(color: AppColors.textPrimary, fontSize: 20),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    fillColor: Colors.transparent,
                    filled: true,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            BouncingButton(
              onTap: _sendMessage,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.buttonBg,
                  border: Border.all(color: AppColors.buttonBorder, width: 2),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: const [
                    BoxShadow(color: AppColors.buttonShadow, offset: Offset(1, 1)),
                  ],
                ),
                child: const Icon(
                  LucideIcons.send,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ChatBubble extends StatefulWidget {
  final String messageId;
  final Map<String, dynamic> data;

  const _ChatBubble({super.key, required this.messageId, required this.data});

  @override
  State<_ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<_ChatBubble> with SingleTickerProviderStateMixin {
  static final Set<String> _animatedIds = {};
  
  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    
    bool isNew = !_animatedIds.contains(widget.messageId);
    if (isNew) {
      final timestamp = widget.data['timestamp'] as Timestamp?;
      if (timestamp != null) {
        final diff = DateTime.now().difference(timestamp.toDate());
        if (diff.inSeconds > 5) {
          isNew = false;
        }
      }
      _animatedIds.add(widget.messageId);
    }

    _animController = AnimationController(
      vsync: this,
      duration: isNew ? const Duration(milliseconds: 300) : Duration.zero,
    );
    _scaleAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOutBack);
    
    if (isNew) {
      _animController.forward();
    } else {
      _animController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.data['text'] as String? ?? '';
    
    final colors = [
      Colors.red.shade700,
      Colors.green.shade800,
      Colors.pink.shade700,
      Colors.orange.shade800, // Readable alternative to yellow on beige background
      Colors.purple.shade700,
    ];
    final color = colors[widget.messageId.hashCode.abs() % colors.length];
    final playerNum = widget.messageId.hashCode.abs() % 9 + 1;

    return ScaleTransition(
      scale: _scaleAnim,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.vt323(
              fontSize: 20,
              color: AppColors.textPrimary,
            ),
            children: [
              TextSpan(
                text: 'Player $playerNum: ',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: text),
            ],
          ),
        ),
      ),
    );
  }
}
