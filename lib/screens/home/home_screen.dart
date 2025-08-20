import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
// import '../../providers/speech_provider.dart';
import '../../models/chat_message.dart';
import '../../models/user_model.dart';
import '../../widgets/navigation/responsive_navigation.dart';
import '../../widgets/subscription/premium_feature_widget.dart';
import '../../widgets/common/modern_card.dart';
import '../../widgets/common/modern_button.dart';
import '../../providers/subscription_provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_typography.dart';

/// Home screen with AI chatbot interface
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isVoiceMode = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _messageController.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final userMessages = ref.watch(userMessagesProvider);
    final isLoading = ref.watch(isChatLoadingProvider);
    final error = ref.watch(chatErrorProvider);

    // Speech recognition state (temporarily disabled)
    // final speechService = ref.read(speechServiceProvider);

    // Speech functionality temporarily disabled for APK build
    /*
    // Update text field with speech words when in voice mode
    ref.listen(speechWordsProvider, (previous, next) {
      if (_isVoiceMode && next.hasValue && next.value != null) {
        _messageController.text = next.value!;
        _messageController.selection = TextSelection.fromPosition(
          TextPosition(offset: _messageController.text.length),
        );
      }
    });

    // Handle speech errors
    ref.listen(speechErrorProvider, (previous, next) {
      if (next.hasValue && next.value != null && next.value!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Speech Error: ${next.value}'),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    // Auto-stop voice mode when listening stops
    ref.listen(speechListeningProvider, (previous, next) {
      if (next.hasValue && next.value == false && _isVoiceMode) {
        setState(() {
          _isVoiceMode = false;
        });
      }
    });
    */

    return ResponsiveNavigation(
      title: 'AI Chat - ${user?.firstName ?? 'User'}',
      actions: [
        // Subscription status
        const SubscriptionStatusWidget(),

        // Clear chat button
        IconButton(
          onPressed: () {
            ref.read(chatOperationsProvider).clearChat();
          },
          icon: const Icon(Icons.refresh),
          tooltip: 'Clear Chat',
        ),

        // Account section - shows different options based on auth status
        _buildAccountSection(context, theme, user),
      ],
      child: Column(
        children: [
          // Error banner
          if (error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: theme.colorScheme.error.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: theme.colorScheme.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      error,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                  IconButton(
                    onPressed: () => ref.read(chatOperationsProvider).clearError(),
                    icon: Icon(Icons.close, color: theme.colorScheme.error),
                  ),
                ],
              ),
            ),

          // Chat messages
          Expanded(
            child: userMessages.isEmpty
                ? _buildEmptyState(context, theme)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    itemCount: userMessages.length,
                    itemBuilder: (context, index) {
                      final message = userMessages[index];
                      return _buildMessageBubble(context, theme, message);
                    },
                  ),
          ),

          // Loading indicator
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI is thinking...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

          // Message input
          _buildMessageInput(context, theme, false),
        ],
      ),
    );
  }

  /// Build empty state when no messages
  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    final isDarkMode = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Modern AI Icon with Gradient Background
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.psychology_outlined,
                size: AppConstants.iconSizeXLarge + 16,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: AppConstants.spacing40),

            // Modern Title
            Text(
              'AI Chat Assistant',
              style: AppTypography.displaySmall(isDarkMode).copyWith(
                color: AppColors.getTextPrimary(isDarkMode),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.spacing16),

            // Modern Description
            Text(
              'Start a conversation with Qwen3, an advanced AI model with exceptional reasoning capabilities. Ask questions, get help, or just chat!',
              style: AppTypography.bodyLarge(isDarkMode).copyWith(
                color: AppColors.getTextSecondary(isDarkMode),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.spacing40),

            // Modern Suggestions Card
            ModernCard(
              padding: const EdgeInsets.all(AppConstants.cardPadding),
              child: Column(
                children: [
                  // Modern Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppConstants.spacing8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppConstants.spacing8),
                        ),
                        child: Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.primaryBlue,
                          size: AppConstants.iconSizeSmall,
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacing12),
                      Text(
                        'Try asking:',
                        style: AppTypography.titleMedium(isDarkMode).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacing16),

                  // Modern Suggestion Chips
                  Wrap(
                    spacing: AppConstants.spacing8,
                    runSpacing: AppConstants.spacing8,
                    children: [
                      'What is Flutter?',
                      'Explain machine learning',
                      'Help me with coding',
                      'Tell me a joke',
                    ].map((suggestion) => ModernButton(
                      text: suggestion,
                      variant: ModernButtonVariant.outline,
                      size: ModernButtonSize.small,
                      onPressed: () {
                        // Auto-fill the suggestion
                        _messageController.text = suggestion;
                      },
                    )).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppConstants.spacing32),

            // Modern Premium Features Section
            PremiumFeatureWidget(
              featureName: 'Advanced AI Features',
              description: 'Unlock unlimited conversations, priority support, and advanced AI models with Premium.',
              icon: Icons.workspace_premium,
              child: ModernPremiumCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppConstants.spacing8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppConstants.spacing8),
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: AppConstants.iconSizeSmall,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacing12),
                        Text(
                          'Premium Features Active',
                          style: AppTypography.titleMedium(false).copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    const PremiumFeaturesList(
                      features: [
                        'Unlimited AI conversations',
                        'Priority support',
                        'Advanced AI models',
                        'Export conversations',
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build message bubble
  Widget _buildMessageBubble(BuildContext context, ThemeData theme, ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.psychology,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight: isUser ? const Radius.circular(4) : null,
                  bottomLeft: !isUser ? const Radius.circular(4) : null,
                ),
                border: !isUser ? Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ) : null,
              ),
              child: Text(
                message.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isUser
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),

          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build modern message input field
  Widget _buildMessageInput(BuildContext context, ThemeData theme, bool isListening) {
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.getSurface(isDarkMode),
        border: Border(
          top: BorderSide(
            color: AppColors.getBorder(isDarkMode),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.getCard(isDarkMode),
                  borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
                  border: Border.all(
                    color: _isVoiceMode
                        ? AppColors.primaryBlue.withOpacity(0.5)
                        : AppColors.getBorder(isDarkMode),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode
                          ? AppColors.shadowDark
                          : AppColors.shadowLight,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _messageController,
                  style: AppTypography.bodyLarge(isDarkMode),
                  decoration: InputDecoration(
                    hintText: _isVoiceMode
                        ? (isListening ? 'Listening...' : 'Tap mic to speak')
                        : 'Type your message...',
                    hintStyle: AppTypography.bodyLarge(isDarkMode).copyWith(
                      color: AppColors.getTextSecondary(isDarkMode),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacing20,
                      vertical: AppConstants.spacing16,
                    ),
                  ),
                  maxLines: null,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _sendMessage,
                  readOnly: _isVoiceMode && isListening,
                ),
              ),
            ),

            const SizedBox(width: AppConstants.spacing12),

            // Modern Voice Input Button
            Container(
              width: AppConstants.buttonHeight,
              height: AppConstants.buttonHeight,
              decoration: BoxDecoration(
                color: _isVoiceMode
                    ? (isListening ? AppColors.error : AppColors.secondaryPurple)
                    : AppColors.getCard(isDarkMode),
                borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
                border: Border.all(
                  color: _isVoiceMode
                      ? (isListening ? AppColors.error : AppColors.secondaryPurple)
                      : AppColors.getBorder(isDarkMode),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isVoiceMode
                        ? (isListening
                            ? AppColors.error.withOpacity(0.3)
                            : AppColors.secondaryPurple.withOpacity(0.3))
                        : (isDarkMode
                            ? AppColors.shadowDark
                            : AppColors.shadowLight),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _toggleVoiceInput,
                  borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
                  child: Icon(
                    _isVoiceMode
                        ? (isListening ? Icons.stop_rounded : Icons.mic_rounded)
                        : Icons.mic_none_rounded,
                    color: _isVoiceMode
                        ? Colors.white
                        : AppColors.getTextSecondary(isDarkMode),
                    size: AppConstants.iconSizeMedium,
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppConstants.spacing8),

            // Modern Send Button
            Container(
              width: AppConstants.buttonHeight,
              height: AppConstants.buttonHeight,
              decoration: BoxDecoration(
                gradient: _hasText
                    ? AppColors.primaryGradient
                    : null,
                color: _hasText
                    ? null
                    : AppColors.neutral300,
                borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
                boxShadow: _hasText ? [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _hasText
                      ? () => _sendMessage(_messageController.text)
                      : null,
                  borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
                  child: Icon(
                    Icons.send_rounded,
                    color: _hasText
                        ? Colors.white
                        : AppColors.neutral500,
                    size: AppConstants.iconSizeMedium,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Send message to AI
  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    ref.read(chatOperationsProvider).sendMessage(message);
    _messageController.clear();

    // Exit voice mode after sending
    if (_isVoiceMode) {
      setState(() {
        _isVoiceMode = false;
      });
    }

    // Scroll to bottom after sending message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Toggle voice input mode (temporarily disabled)
  Future<void> _toggleVoiceInput() async {
    // Speech functionality temporarily disabled for APK build
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice input feature coming soon!'),
      ),
    );
    /*
    final speechService = ref.read(speechServiceProvider);

    if (_isVoiceMode) {
      // If currently in voice mode, stop listening and exit voice mode
      if (speechService.isListening) {
        await speechService.stopListening();
      }
      setState(() {
        _isVoiceMode = false;
      });
    } else {
      // Enter voice mode and start listening
      setState(() {
        _isVoiceMode = true;
      });

      // Clear current text and start listening
      _messageController.clear();
      await speechService.startListening();
    }
    */
  }

  /// Build account section in app bar - shows different options based on auth status
  Widget _buildAccountSection(BuildContext context, ThemeData theme, UserModel? user) {
    if (user != null) {
      // User is authenticated - show profile and logout options
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Profile button
          IconButton(
            onPressed: () => context.push('/profile'),
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
              child: user.photoURL == null
                  ? Text(
                      user.initials ?? 'U',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),

          // Menu with profile and logout options
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'profile':
                  context.push('/profile');
                  break;
                case 'logout':
                  final authNotifier = ref.read(authNotifierProvider.notifier);
                  final result = await authNotifier.signOut();
                  if (context.mounted && result.success) {
                    // Stay on dashboard after logout
                    setState(() {});
                  }
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // User is not authenticated - show login options
      return PopupMenuButton<String>(
        icon: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_outline,
                color: theme.colorScheme.onPrimary,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                'Account',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        onSelected: (value) {
          switch (value) {
            case 'login':
              context.push(AppConstants.loginRoute);
              break;
            case 'signup':
              context.push(AppConstants.signupRoute);
              break;
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'login',
            child: Row(
              children: [
                Icon(Icons.login),
                SizedBox(width: 8),
                Text('Sign In'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'signup',
            child: Row(
              children: [
                Icon(Icons.person_add),
                SizedBox(width: 8),
                Text('Sign Up'),
              ],
            ),
          ),
        ],
      );
    }
  }
}
