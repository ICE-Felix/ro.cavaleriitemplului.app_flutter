import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notification_bloc.dart';
import '../../../../core/services/firebase_messaging_service.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                String? token = await FirebaseMessagingService.getToken();
                if (token != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Token: $token')),
                  );
                }
              },
              child: const Text('Get FCM Token'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<NotificationBloc>().add(
                  const SubscribeToTopic('news'),
                );
              },
              child: const Text('Subscribe to News'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<NotificationBloc>().add(
                  const UnsubscribeFromTopic('news'),
                );
              },
              child: const Text('Unsubscribe from News'),
            ),
          ],
        ),
      ),
    );
  }
} 