import 'package:bytebank_persistence/http/interceptors/logging_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

final Client client = InterceptedClient.build(
    interceptors: [
      LoggingInterceptor(),
  ]
);

const String baseUrl = 'http://192.168.1.80:8080/transactions';