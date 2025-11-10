import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../core/error/exceptions.dart';

class GoogleDriveService {
  drive.DriveApi? _driveApi;
  AuthClient? _authClient;

  /// Initialize Google Drive API with service account credentials
  Future<void> initialize() async {
    try {
      // Get credentials from environment variables or secure storage
      final credentials = ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": dotenv.get('GOOGLE_PROJECT_ID'),
        "private_key_id": dotenv.get('GOOGLE_PRIVATE_KEY_ID'),
        "private_key": dotenv.get('GOOGLE_PRIVATE_KEY').replaceAll('\\n', '\n'),
        "client_email": dotenv.get('GOOGLE_CLIENT_EMAIL'),
        "client_id": dotenv.get('GOOGLE_CLIENT_ID'),
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
      });

      // Define the scopes we need
      final scopes = [drive.DriveApi.driveReadonlyScope];

      // Get authenticated client
      _authClient = await clientViaServiceAccount(credentials, scopes);
      _driveApi = drive.DriveApi(_authClient!);
    } catch (e) {
      throw ServerException(
        message: 'Failed to initialize Google Drive: ${e.toString()}',
      );
    }
  }

  /// List all PDF files in the specified folder
  Future<List<drive.File>> listPdfsInFolder(String folderId) async {
    if (_driveApi == null) {
      await initialize();
    }

    try {
      final fileList = await _driveApi!.files.list(
        q: "'$folderId' in parents and mimeType='application/pdf' and trashed=false",
        orderBy: 'modifiedTime desc',
        $fields: 'files(id, name, description, thumbnailLink, size, createdTime, modifiedTime)',
      );

      return fileList.files ?? [];
    } catch (e) {
      throw ServerException(
        message: 'Failed to list files: ${e.toString()}',
      );
    }
  }

  /// Get file metadata
  Future<drive.File> getFileMetadata(String fileId) async {
    if (_driveApi == null) {
      await initialize();
    }

    try {
      final file = await _driveApi!.files.get(
        fileId,
        $fields: 'id, name, description, thumbnailLink, size, createdTime, modifiedTime, webViewLink',
      ) as drive.File;

      return file;
    } catch (e) {
      throw ServerException(
        message: 'Failed to get file metadata: ${e.toString()}',
      );
    }
  }

  /// Download PDF file to local storage
  Future<String> downloadPdfFile(String fileId, String fileName) async {
    if (_driveApi == null) {
      await initialize();
    }

    try {
      // Get the file content
      final drive.Media? media = await _driveApi!.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media?;

      if (media == null) {
        throw ServerException(message: 'Failed to download file');
      }

      // Get local directory to save the file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/revistas/$fileName';

      // Create directory if it doesn't exist
      final file = File(filePath);
      await file.parent.create(recursive: true);

      // Write the file
      final sink = file.openWrite();
      await media.stream.pipe(sink);
      await sink.close();

      return filePath;
    } catch (e) {
      throw ServerException(
        message: 'Failed to download PDF: ${e.toString()}',
      );
    }
  }

  /// Get authenticated download URL for streaming
  Future<String> getAuthenticatedUrl(String fileId) async {
    if (_driveApi == null) {
      await initialize();
    }

    try {
      // For now, we'll download the file and return local path
      // In production, you might want to implement a streaming solution
      final metadata = await getFileMetadata(fileId);
      final fileName = metadata.name ?? 'revista_$fileId.pdf';

      return await downloadPdfFile(fileId, fileName);
    } catch (e) {
      throw ServerException(
        message: 'Failed to get authenticated URL: ${e.toString()}',
      );
    }
  }

  /// Dispose of the auth client
  void dispose() {
    _authClient?.close();
  }
}
