import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied()
abstract class Env
{
  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY', defaultValue: '', obfuscate: true)
  static String googleMapsAPI = _Env.googleMapsAPI;
}