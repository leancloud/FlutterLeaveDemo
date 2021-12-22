import 'package:get_it/get_it.dart';
import './TelAndSmsService.dart';
final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(TelAndSmsService());
}