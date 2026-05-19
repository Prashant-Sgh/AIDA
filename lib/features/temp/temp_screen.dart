import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
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

  @override
  void initState() {
    super.initState();
    jwtToken = ref.read(authenticationViewModelProvider).jwtToken ?? '';
  }

  @override
  Widget build(BuildContext context) {
    dynamic decodedToken = '';
    bool isExpired = false;
    dynamic expirationDate = '';

    if (jwtToken.isNotEmpty) {
      decodedToken = JwtDecoder.decode(jwtToken);
      isExpired = JwtDecoder.isExpired(jwtToken);
      expirationDate = JwtDecoder.getExpirationDate(jwtToken);
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Decoded token:",
                style: GoogleFonts.quicksand(color: Colors.black, fontSize: 20),
              ),
              SizedBox(height: 20),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  decodedToken.toString(),
                  textAlign: TextAlign.start,
                  style: GoogleFonts.quicksand(
                      color: Colors.blueGrey, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  "Is Expired: $isExpired",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.quicksand(
                      color: Colors.blueGrey, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  "Expiration Date: $expirationDate",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.quicksand(
                      color: Colors.blueGrey, fontSize: 20),
                ),
              ])
            ]),
      ),
    );
  }
}
