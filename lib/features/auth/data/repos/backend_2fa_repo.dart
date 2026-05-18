import 'package:aida/core/enums/response_state.dart';
import 'package:aida/features/auth/data/services/backend_2fa_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final backend2faRepoProvider = Provider<Backend2faRepo>((ref) {
  return Backend2faRepo(ref.read(backend2faServicesProvider));
});

class Backend2faRepo {
  final Backend2faServices _backend2faServices;
  Backend2faRepo(this._backend2faServices);

  Future<ResponseState> start2fa({required String token}) async {
    return await _backend2faServices.start2fa(token: token);
  }

  Future<void> sendOTP({required String email}) async {
    await _backend2faServices.sendOTP(email: email);
  }

  Future<ResponseState> verifyOtp(
      {required String otp, required String email}) async {
    return await _backend2faServices.verifyOtp(otp: otp, email: email);
  }
}
