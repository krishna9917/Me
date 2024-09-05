import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Resources/Strings.dart';

final appThemeProvider = StateProvider<bool>((ref) {
  final themeAsyncValue = ref.watch(selectedThemeProvider);

  return themeAsyncValue.maybeWhen(
    data: (theme) => theme.contains(Strings.darkTheme),
    orElse: () => false, // Default to false if loading or error
  );
});

final goldenThemeProvider = StateProvider<bool>((ref) {
  final themeAsyncValue = ref.watch(selectedThemeProvider);
  return themeAsyncValue.maybeWhen(
    data: (theme) {
      return theme.contains(Strings.goldenTheme);
    },
    orElse: () => false, // Default to false if loading or error
  );
});

// FutureProvider for fetching the initial theme
final selectedThemeProvider = FutureProvider<String>((ref) async {
  return await getSelectedTheme();
});

Future<String> getSelectedTheme() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString(Strings.theme) ?? "";
}
