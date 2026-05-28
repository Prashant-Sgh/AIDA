import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:aida/features/otp/presentation/view/custom_banners/custom_otp_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TempScreen extends ConsumerStatefulWidget {
  const TempScreen({super.key});

  @override
  ConsumerState<TempScreen> createState() => _TempScreenState();
}

class _TempScreenState extends ConsumerState<TempScreen> {
  late String jwtToken;
  // bool showBanner = false;

  Future<void> showBannerNow() async {
    debugPrint('Show banner now');
    await ref
        .read(authenticationViewModelProvider.notifier)
        .setOtpBannerType(BannerType.wrongOtp);
    debugPrint('Hide banner now');
  }

  @override
  void initState() {
    super.initState();
    // showBannerNow();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final backgroundColor = theme.colorScheme.surface;


    debugPrint('Building temp screen');
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Center(
        child: IconButton(
          icon: Icon(Icons.refresh_rounded),
          onPressed: () async {
            debugPrint('Show banner pressed');
            await showBannerNow();
          },
        ),
      ),
    );
  }
}
