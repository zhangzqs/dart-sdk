import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:dotenv/dotenv.dart' show DotEnv;
import 'package:qiniu_sdk_base/src/auth/auth.dart';
import 'package:test/test.dart';

final env = DotEnv(includePlatformEnvironment: true)..load();

final isSensitiveDataDefined = env.isEveryDefined([
  'QINIU_DART_SDK_ACCESS_KEY',
  'QINIU_DART_SDK_SECRET_KEY',
  'QINIU_DART_SDK_TOKEN_SCOPE',
]);

void configEnv() {
  setUpAll(() {
    if (!isSensitiveDataDefined) {
      stderr.writeln('没有在 .env 文件里配置测试用的必要信息，一些测试用例会被跳过');
    }
  });

  tearDownAll(env.clear);
}

String generateUploadToken(
  String key, {
  PutPolicy? putPolicy,
}) {
  final auth = Auth(
    accessKey: env['QINIU_DART_SDK_ACCESS_KEY']!,
    secretKey: env['QINIU_DART_SDK_SECRET_KEY']!,
  );
  putPolicy = putPolicy ??
      PutPolicy(
        insertOnly: 0,
        scope: "${env['QINIU_DART_SDK_TOKEN_SCOPE']!}:$key",
        deadline: DateTime.now().millisecondsSinceEpoch + 3600,
      );

  return auth.generateUploadToken(putPolicy: putPolicy);
}
