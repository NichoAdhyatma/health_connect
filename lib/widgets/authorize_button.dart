import 'package:flutter/material.dart';

class AuthorizeButton extends StatelessWidget {
  const AuthorizeButton({
    super.key,
    required this.isAuthorized,
    required this.onAuthorize,
    required this.onRevoke,
  });

  final bool isAuthorized;
  final VoidCallback onAuthorize;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          isAuthorized
              ? ElevatedButton(
                  onPressed: onRevoke,
                  child: const Text("Revoke Access"),
                )
              : ElevatedButton(
                  onPressed: onAuthorize,
                  child: const Text("Authorize"),
                ),
          Text(isAuthorized
              ? "Connected to Health Connect"
              : "No Access Health Connect")
        ],
      ),
    );
  }
}
