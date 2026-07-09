/// URL de la Lambda Function URL tras `amplify push`.
/// Actualiza [functionUrl] con el output `FunctionUrl` del stack crearUsuarioCampo.
class CrearUsuarioLambdaConfig {
  CrearUsuarioLambdaConfig._();

  /// URL de la Lambda Function URL (crearUsuarioCampo-dev).
  static const String functionUrl =
      'https://324jpn6apqwyljm65to5atemxu0sgtwj.lambda-url.us-east-1.on.aws/';

  static bool get isConfigured =>
      functionUrl.isNotEmpty && functionUrl.startsWith('https://');
}
