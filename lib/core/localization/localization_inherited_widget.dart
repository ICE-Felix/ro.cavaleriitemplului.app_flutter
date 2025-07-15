import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_localization.dart';

class LocalizationInheritedWidget extends InheritedWidget {
  final LocalizationCubit localizationCubit;
  final LocalizationState localizationState;

  const LocalizationInheritedWidget({
    Key? key,
    required this.localizationCubit,
    required this.localizationState,
    required Widget child,
  }) : super(key: key, child: child);

  static LocalizationInheritedWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<LocalizationInheritedWidget>();
  }

  @override
  bool updateShouldNotify(LocalizationInheritedWidget oldWidget) {
    return localizationState != oldWidget.localizationState;
  }
}

class LocalizationProvider extends StatelessWidget {
  final Widget child;

  const LocalizationProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizationCubit = context.read<LocalizationCubit>();

    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, state) {
        return LocalizationInheritedWidget(
          localizationCubit: localizationCubit,
          localizationState: state,
          child: child,
        );
      },
    );
  }
}

// Extension to make it even easier to access localization
extension LocalizationExtension on BuildContext {
  LocalizationCubit get localization {
    final inherited = LocalizationInheritedWidget.of(this);
    if (inherited == null) {
      throw Exception('LocalizationInheritedWidget not found in widget tree');
    }
    return inherited.localizationCubit;
  }

  String getString({
    required String label,
    num? variable,
    List<String>? parameters,
    Map<String, dynamic>? namedParameters,
  }) {
    // This call to dependOnInheritedWidgetOfExactType ensures that the widget
    // will rebuild when the localization state changes
    final inherited =
        dependOnInheritedWidgetOfExactType<LocalizationInheritedWidget>();
    if (inherited == null) {
      throw Exception('LocalizationInheritedWidget not found in widget tree');
    }

    return inherited.localizationCubit.getString(
      label: label,
      variable: variable,
      parameters: parameters,
      namedParameters: namedParameters,
    );
  }
}
