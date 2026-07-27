import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpPendingBanner extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onVerify;

  const OtpPendingBanner({
    super.key,
    required this.onClose,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.orange.withOpacity(0.24),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_clock_rounded,
            color: Colors.orange.shade700,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              'Verify OTP to unlock full access',
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          TextButton(
            onPressed: onVerify,
            child: const Text('Verify'),
          ),

          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}