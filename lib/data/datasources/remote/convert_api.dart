// ignore_for_file: always_specify_types

import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/data/errors/api_error.dart';
import 'package:commercial_app/domain/repositories/domain_repositories_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConvertAPI implements DocumentConverterRepository {
  @override
  Future<String?> convertDocxToPdf(List<int> docxBytes, String fileName) async {
    try {
      String base64Docx = base64Encode(docxBytes);
      final Uri jobUri = Uri.parse('https://api.cloudconvert.com/v2/jobs');
      final http.Response jobResponse = await http.post(
        jobUri,
        headers: <String, String>{
          'Authorization': 'Bearer $convertApiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode(<String, Map<String, Map<String, Object>>>{
          'tasks': <String, Map<String, Object>>{
            'import-1': <String, Object>{
              'operation': 'import/base64',
              'file': base64Docx,
              'filename': '$fileName.docx',
            },
            'task-1': <String, Object>{
              'operation': 'convert',
              'input_format': 'docx',
              'output_format': 'pdf',
              'input': <String>['import-1'],
            },
            'export-1': <String, Object>{
              'operation': 'export/url',
              'input': <String>['task-1'],
            },
          },
        }),
      );
      if (jobResponse.statusCode != 201) {
        throw ApiError.fromStatusCode(jobResponse.statusCode);
      }
      final Map<String, dynamic> jobData = json.decode(jobResponse.body);
      final String jobId = jobData['data']['id'];
      return await _getJobResult(jobId);
    } catch (e) {
      // ignore: avoid_print
      print('Error in convertDocxToPdf: $e');
      rethrow;
    }
  }

  Future<String?> _getJobResult(String jobId) async {
    final Uri jobStatusUri =
        Uri.parse('https://api.cloudconvert.com/v2/jobs/$jobId');
    while (true) {
      try {
        final http.Response jobStatusResponse = await http.get(
          jobStatusUri,
          headers: <String, String>{
            'Authorization': 'Bearer $convertApiKey',
          },
        );
        if (jobStatusResponse.statusCode != 200) {
          throw ApiError.fromStatusCode(jobStatusResponse.statusCode);
        }
        final Map<String, dynamic> jobData =
            json.decode(jobStatusResponse.body);
        final String jobStatus = jobData['data']['status'];
        if (jobStatus == 'finished') {
          final List<dynamic> tasks = jobData['data']['tasks'];
          for (var task in tasks) {
            if (task['name'] == 'export-1' && task['status'] == 'finished') {
              return task['result']['files'][0]['url'];
            }
          }
        } else if (jobStatus == 'error') {
          throw ApiError(S.current.taskExecutionError, 500);
        }
        await Future.delayed(
          const Duration(
            seconds: 3,
          ),
        );
      } catch (e) {
        // ignore: avoid_print
        print('Error in _getJobResult: $e');
        rethrow;
      }
    }
  }
}
