import '../models/support_request_model.dart';

abstract class SupportRemoteDataSource {
  Future<void> submitSupportRequest(SupportRequestModel request);
}

class SupportRemoteDataSourceImpl implements SupportRemoteDataSource {
  @override
  Future<void> submitSupportRequest(SupportRequestModel request) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // In production, this would send the request to a backend API
    // For now, we'll just log it or store it locally
    print('Support request submitted: ${request.toJson()}');

    // Success - in real app, would handle API response
  }
}
