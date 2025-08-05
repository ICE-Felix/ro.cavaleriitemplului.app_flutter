import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ProfileButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: IconButton(
        onPressed: onPressed,
        icon: CircleAvatar(
          radius: 16,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: FaIcon(
            FontAwesomeIcons.user,
            size: 16,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        tooltip: 'Profile',
      ),
    );
  }
}
