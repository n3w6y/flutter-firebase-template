import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_message.dart';
import '../models/conversation.dart';
import '../services/firestore_service.dart';
import 'base_repository.dart';

/// Repository for chat messages using the generic repository pattern
class ChatMessageRepository extends BaseRepository<ChatMessage> {
  final FirestoreService _firestoreService;
  final String conversationId;

  ChatMessageRepository({
    required String conversationId,
    FirestoreService? firestoreService,
  }) : _firestoreService = firestoreService ?? FirestoreService(),
       conversationId = conversationId;

  @override
  CollectionReference<Map<String, dynamic>> get collection {
    return _firestoreService
        .getUserCollection('conversations')
        .doc(conversationId)
        .collection('messages');
  }

  @override
  ChatMessage fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ChatMessage.fromFirestore(data).copyWith(id: doc.id);
  }

  @override
  Map<String, dynamic> toFirestore(ChatMessage item) {
    return item.toFirestore();
  }

  @override
  String? getDocumentId(ChatMessage item) => item.id;

  /// Get messages ordered by timestamp
  Future<List<ChatMessage>> getMessagesOrdered({bool ascending = true}) async {
    final query = collection.orderBy('timestamp', descending: !ascending);
    return await this.query(query);
  }

  /// Stream messages ordered by timestamp
  Stream<List<ChatMessage>> streamMessagesOrdered({bool ascending = true}) {
    final query = collection.orderBy('timestamp', descending: !ascending);
    return streamQuery(query);
  }

  /// Get recent messages with limit
  Future<List<ChatMessage>> getRecentMessages(int limit) async {
    final query = collection
        .orderBy('timestamp', descending: true)
        .limit(limit);
    return await this.query(query);
  }

  /// Get messages by role
  Future<List<ChatMessage>> getMessagesByRole(MessageRole role) async {
    final query = collection.where('role', isEqualTo: role.name);
    return await this.query(query);
  }

  /// Search messages by content
  Future<List<ChatMessage>> searchMessages(String searchTerm) async {
    // Note: Firestore doesn't support full-text search natively
    // This is a basic implementation - for production, consider using Algolia or similar
    final messages = await getAll();
    return messages.where((message) => 
        message.content.toLowerCase().contains(searchTerm.toLowerCase())
    ).toList();
  }

  /// Get message count
  Future<int> getMessageCount() async {
    return await super.count();
  }

  /// Delete all messages in conversation
  Future<void> deleteAllMessages() async {
    final messages = await getAll();
    final batch = _firestoreService.createBatch();
    
    for (final message in messages) {
      if (message.id != null) {
        batch.delete(collection.doc(message.id!));
      }
    }
    
    await _firestoreService.commitBatch(batch);
  }
}

/// Repository for conversations
class ConversationRepository extends BaseRepository<Conversation> {
  final FirestoreService _firestoreService;

  ConversationRepository({FirestoreService? firestoreService})
      : _firestoreService = firestoreService ?? FirestoreService();

  /// Get the Firestore service instance
  FirestoreService get firestoreService => _firestoreService;

  @override
  CollectionReference<Map<String, dynamic>> get collection {
    return _firestoreService.getUserCollection('conversations');
  }

  @override
  Conversation fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Conversation.fromFirestore(doc.id, data);
  }

  @override
  Map<String, dynamic> toFirestore(Conversation item) {
    return item.toFirestore();
  }

  @override
  String? getDocumentId(Conversation item) => item.id.isNotEmpty ? item.id : null;

  /// Get conversations ordered by update time
  Future<List<Conversation>> getConversationsOrdered({bool ascending = false}) async {
    final query = collection.orderBy('updatedAt', descending: !ascending);
    return await this.query(query);
  }

  /// Stream conversations ordered by update time
  Stream<List<Conversation>> streamConversationsOrdered({bool ascending = false}) {
    final query = collection.orderBy('updatedAt', descending: !ascending);
    return streamQuery(query);
  }

  /// Get active (non-archived) conversations
  Future<List<Conversation>> getActiveConversations() async {
    final query = collection
        .where('isArchived', isEqualTo: false)
        .orderBy('updatedAt', descending: true);
    return await this.query(query);
  }

  /// Stream active conversations
  Stream<List<Conversation>> streamActiveConversations() {
    final query = collection
        .where('isArchived', isEqualTo: false)
        .orderBy('updatedAt', descending: true);
    return streamQuery(query);
  }

  /// Get archived conversations
  Future<List<Conversation>> getArchivedConversations() async {
    final query = collection
        .where('isArchived', isEqualTo: true)
        .orderBy('updatedAt', descending: true);
    return await this.query(query);
  }

  /// Get conversations by model
  Future<List<Conversation>> getConversationsByModel(String model) async {
    final query = collection
        .where('model', isEqualTo: model)
        .orderBy('updatedAt', descending: true);
    return await this.query(query);
  }

  /// Search conversations by title
  Future<List<Conversation>> searchConversations(String searchTerm) async {
    // Basic search implementation
    final conversations = await getAll();
    return conversations.where((conversation) => 
        conversation.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
        (conversation.description?.toLowerCase().contains(searchTerm.toLowerCase()) ?? false)
    ).toList();
  }

  /// Create conversation with first message
  Future<String> createConversationWithMessage({
    required String title,
    required ChatMessage firstMessage,
    String? description,
    String model = 'deepseek/deepseek-r1-0528',
  }) async {
    return await _firestoreService.runTransaction<String>((transaction) async {
      // Create conversation
      final conversation = Conversation.create(
        userId: _firestoreService.currentUserId!,
        title: title,
        description: description,
        model: model,
      );

      final conversationRef = collection.doc();
      transaction.set(conversationRef, conversation.toFirestore());

      // Add first message
      final messageRef = conversationRef.collection('messages').doc();
      transaction.set(messageRef, firstMessage.toFirestore());

      // Update conversation with message count
      transaction.update(conversationRef, {
        'messageCount': 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return conversationRef.id;
    });
  }

  /// Update conversation message count
  Future<void> updateMessageCount(String conversationId, int newCount) async {
    await collection.doc(conversationId).update({
      'messageCount': newCount,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Archive conversation
  Future<void> archiveConversation(String conversationId) async {
    await collection.doc(conversationId).update({
      'isArchived': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Unarchive conversation
  Future<void> unarchiveConversation(String conversationId) async {
    await collection.doc(conversationId).update({
      'isArchived': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Delete conversation and all its messages
  Future<void> deleteConversationWithMessages(String conversationId) async {
    await _firestoreService.runTransaction((transaction) async {
      // Delete all messages first
      final messagesSnapshot = await collection
          .doc(conversationId)
          .collection('messages')
          .get();

      for (final messageDoc in messagesSnapshot.docs) {
        transaction.delete(messageDoc.reference);
      }

      // Delete the conversation
      transaction.delete(collection.doc(conversationId));
    });
  }

  /// Get conversation statistics
  Future<Map<String, dynamic>> getConversationStats() async {
    final conversations = await getAll();
    
    final totalConversations = conversations.length;
    final activeConversations = conversations.where((c) => !c.isArchived).length;
    final archivedConversations = conversations.where((c) => c.isArchived).length;
    final totalMessages = conversations.fold<int>(0, (sum, c) => sum + c.messageCount);
    
    final modelUsage = <String, int>{};
    for (final conversation in conversations) {
      modelUsage[conversation.model] = (modelUsage[conversation.model] ?? 0) + 1;
    }

    return {
      'totalConversations': totalConversations,
      'activeConversations': activeConversations,
      'archivedConversations': archivedConversations,
      'totalMessages': totalMessages,
      'modelUsage': modelUsage,
    };
  }
}
