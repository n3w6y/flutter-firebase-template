import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_message.dart';
import '../services/openrouter_service.dart';

/// Provider for OpenRouter service instance
final openRouterServiceProvider = Provider<OpenRouterService>((ref) {
  return OpenRouterService();
});

/// Chat state class
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final String currentModel;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.currentModel = 'deepseek/deepseek-r1-0528',
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    String? currentModel,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentModel: currentModel ?? this.currentModel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatState &&
        other.messages == messages &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.currentModel == currentModel;
  }

  @override
  int get hashCode {
    return messages.hashCode ^ isLoading.hashCode ^ error.hashCode ^ currentModel.hashCode;
  }
}

/// Chat state notifier
class ChatNotifier extends StateNotifier<ChatState> {
  final OpenRouterService _openRouterService;

  ChatNotifier(this._openRouterService) : super(const ChatState()) {
    _initializeChat();
  }

  /// Initialize chat with system message
  void _initializeChat() {
    final systemMessage = _openRouterService.createSystemMessage();
    state = state.copyWith(messages: [systemMessage]);
  }

  /// Send a message to the AI
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage.user(content.trim());
    final updatedMessages = [...state.messages, userMessage];
    
    state = state.copyWith(
      messages: updatedMessages,
      isLoading: true,
      error: null,
    );

    try {
      // Send to OpenRouter API
      final response = await _openRouterService.sendMessage(
        messages: updatedMessages,
        model: state.currentModel,
      );

      // Add AI response
      final finalMessages = [...updatedMessages, response];
      state = state.copyWith(
        messages: finalMessages,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Clear chat history
  void clearChat() {
    _initializeChat();
  }

  /// Change AI model
  void changeModel(String model) {
    state = state.copyWith(currentModel: model);
  }

  /// Remove a specific message
  void removeMessage(String messageId) {
    final updatedMessages = state.messages.where((msg) => msg.id != messageId).toList();
    state = state.copyWith(messages: updatedMessages);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Get user messages only (excluding system messages)
  List<ChatMessage> get userMessages {
    return state.messages.where((msg) => !msg.isSystem).toList();
  }

  /// Check if chat is empty (only system message)
  bool get isChatEmpty {
    return userMessages.isEmpty;
  }

  /// Get last user message
  ChatMessage? get lastUserMessage {
    final userMsgs = userMessages.where((msg) => msg.isUser).toList();
    return userMsgs.isNotEmpty ? userMsgs.last : null;
  }

  /// Get last assistant message
  ChatMessage? get lastAssistantMessage {
    final assistantMsgs = userMessages.where((msg) => msg.isAssistant).toList();
    return assistantMsgs.isNotEmpty ? assistantMsgs.last : null;
  }

  @override
  void dispose() {
    _openRouterService.dispose();
    super.dispose();
  }
}

/// Provider for chat state notifier
final chatNotifierProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final openRouterService = ref.read(openRouterServiceProvider);
  return ChatNotifier(openRouterService);
});

/// Provider for chat operations
final chatOperationsProvider = Provider<ChatNotifier>((ref) {
  return ref.read(chatNotifierProvider.notifier);
});

/// Provider for user messages only
final userMessagesProvider = Provider<List<ChatMessage>>((ref) {
  final chatState = ref.watch(chatNotifierProvider);
  return chatState.messages.where((msg) => !msg.isSystem).toList();
});

/// Provider for checking if chat is loading
final isChatLoadingProvider = Provider<bool>((ref) {
  final chatState = ref.watch(chatNotifierProvider);
  return chatState.isLoading;
});

/// Provider for chat error
final chatErrorProvider = Provider<String?>((ref) {
  final chatState = ref.watch(chatNotifierProvider);
  return chatState.error;
});

/// Provider for current AI model
final currentModelProvider = Provider<String>((ref) {
  final chatState = ref.watch(chatNotifierProvider);
  return chatState.currentModel;
});

/// Provider for available models
final availableModelsProvider = FutureProvider<List<String>>((ref) async {
  final openRouterService = ref.read(openRouterServiceProvider);
  return await openRouterService.getAvailableModels();
});

/// Provider for model information
final modelInfoProvider = Provider.family<Map<String, dynamic>, String>((ref, model) {
  final openRouterService = ref.read(openRouterServiceProvider);
  return openRouterService.getModelInfo(model);
});

/// Provider for testing OpenRouter connection
final connectionTestProvider = FutureProvider<bool>((ref) async {
  final openRouterService = ref.read(openRouterServiceProvider);
  return await openRouterService.testConnection();
});
