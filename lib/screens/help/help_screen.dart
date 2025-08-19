import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_constants.dart';
import '../../widgets/navigation/responsive_navigation.dart';

/// Help and About screen
class HelpScreen extends ConsumerWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ResponsiveNavigation(
      title: 'Help & About',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Info Section
            _buildAppInfoSection(context, theme),
            
            const SizedBox(height: 32),
            
            // Features Section
            _buildFeaturesSection(context, theme),
            
            const SizedBox(height: 32),
            
            // FAQ Section
            _buildFAQSection(context, theme),
            
            const SizedBox(height: 32),
            
            // Contact Section
            _buildContactSection(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfoSection(BuildContext context, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flutter Template',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Version 1.0.0',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'A modern Flutter app template with AI chat capabilities, Firebase authentication, and responsive navigation. Built with Material Design 3 and powered by Qwen3 AI model.',
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context, ThemeData theme) {
    final features = [
      {
        'icon': Icons.chat_bubble_outline,
        'title': 'AI Chat',
        'description': 'Powered by Qwen3 with advanced reasoning capabilities',
      },
      {
        'icon': Icons.security,
        'title': 'Secure Authentication',
        'description': 'Firebase authentication with Google Sign-In support',
      },
      {
        'icon': Icons.devices,
        'title': 'Responsive Design',
        'description': 'Optimized for mobile, tablet, and desktop',
      },
      {
        'icon': Icons.palette_outlined,
        'title': 'Modern UI',
        'description': 'Material Design 3 with dark/light theme support',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...features.map((feature) => _buildFeatureItem(context, theme, feature)),
      ],
    );
  }

  Widget _buildFeatureItem(BuildContext context, ThemeData theme, Map<String, dynamic> feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              feature['icon'] as IconData,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature['title'] as String,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  feature['description'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context, ThemeData theme) {
    final faqs = [
      {
        'question': 'How do I start chatting with AI?',
        'answer': 'Simply type your message in the chat input field and press send. You can chat without signing up, but creating an account saves your conversation history.',
      },
      {
        'question': 'Is my data secure?',
        'answer': 'Yes, we use Firebase for secure authentication and data storage. Your conversations are encrypted and stored securely.',
      },
      {
        'question': 'Can I use the app offline?',
        'answer': 'The AI chat requires an internet connection, but you can browse your saved conversations offline if you\'re signed in.',
      },
      {
        'question': 'How do I change the theme?',
        'answer': 'Go to Settings and toggle between light and dark themes. The app will remember your preference.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...faqs.map((faq) => _buildFAQItem(context, theme, faq)),
      ],
    );
  }

  Widget _buildFAQItem(BuildContext context, ThemeData theme, Map<String, String> faq) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          faq['question']!,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              faq['answer']!,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need More Help?',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'If you have questions or need support, feel free to reach out to us.',
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement email support
                    },
                    icon: const Icon(Icons.email_outlined),
                    label: const Text('Email Support'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement feedback
                    },
                    icon: const Icon(Icons.feedback_outlined),
                    label: const Text('Send Feedback'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
