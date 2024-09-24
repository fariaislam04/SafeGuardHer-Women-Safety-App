import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied()
abstract class Env
{
  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY', defaultValue: '', obfuscate: true)
  @EnviedField(varName: 'OPEN_ROUTE_SERVICE_API_KEY', defaultValue: '', obfuscate: true)
  static String googleMapsAPI = _Env.googleMapsAPI;
 // static String openRouteServiceAPI = _Env.openRouteServiceAPI;
}
