import '../../data/datasources/support_remote_data_source.dart';
import '../../data/models/support_request_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class SupportRepository {
  Future<void> submitSupportRequest(SupportRequestModel request);
}

class SupportRepositoryImpl implements SupportRepository {
  final SupportRemoteDataSource remoteDataSource;

  SupportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitSupportRequest(SupportRequestModel request) async {
    try {
      await remoteDataSource.submitSupportRequest(request);
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Failed to submit support request: $e');
    }
  }
}
