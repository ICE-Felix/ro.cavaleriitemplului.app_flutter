import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notification_bloc.dart';
import '../../../../core/services/firebase_messaging_service.dart';

class NotificationHandler extends StatefulWidget {
  final Widget child;

  const NotificationHandler({Key? key, required this.child}) : super(key: key);

  @override
  State<NotificationHandler> createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> {
  @override
  void initState() {
    super.initState();
    _listenToMessages();
  }

  void _listenToMessages() {
    FirebaseMessagingService.messageStream.listen((message) {
      // Add the message to the notification bloc
      context.read<NotificationBloc>().add(NotificationReceived(message));
      
      // Show in-app notification if needed
      _showInAppNotification(message);
    });
  }

  void _showInAppNotification(message) {
    if (message.notification != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.notification!.title ?? 'Notification',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (message.notification!.body != null)
                Text(message.notification!.body!),
            ],
          ),
          action: SnackBarAction(
            label: 'View',
            onPressed: () {
              context.read<NotificationBloc>().add(NotificationTapped(message));
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        // Handle notification state changes
        if (state is NotificationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: widget.child,
    );
  }
} 