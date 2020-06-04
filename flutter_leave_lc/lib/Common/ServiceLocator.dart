import 'package:get_it/get_it.dart';
import './TelAndSmsService.dart';

GetIt locator = GetIt();
void setupLocator() {
  locator.registerSingleton(TelAndSmsService());
}