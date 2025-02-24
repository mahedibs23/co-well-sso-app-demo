// ignore_for_file: unnecessary_null_comparison, avoid_print
import 'dart:io';

const String presentationDir = 'presentation';
const String baseDir = '$presentationDir/base';

const String baseBindingFile = '$baseDir/base_binding.dart';
const String baseArgumentFile = '$baseDir/base_argument.dart';
const String baseRouteFile = '$baseDir/base_route.dart';
const String baseUiStateFile = '$baseDir/base_ui_state.dart';
const String baseAdaptiveUiFile = '$baseDir/base_adaptive_ui.dart';
const String baseViewModelFile = '$baseDir/base_viewmodel.dart';

const String navigationDir = '$presentationDir/navigation';
const String navigationRouteFilePath = '$navigationDir/route_path.dart';

String featurePathName = ''; // example_feature
String featureVariableName =
    convertSnakeCaseToCamelCase(featurePathName); // exampleFeature
String featureClassName = featurePathName.capitalize(); // ExampleFeature

const String featureDir = '$presentationDir/feature';

String get featurePath => '$featureDir/$featurePathName';

String get featureBindingDir => '$featurePath/binding';

String get featureBindingFile =>
    '$featureBindingDir/${featurePathName}_binding.dart';

String get featureScreenDir => '$featurePath/screen';

String get featureMobilePortraitFile =>
    '$featureScreenDir/${featurePathName}_mobile_portrait.dart';

String get featureMobileLandscapeFile =>
    '$featureScreenDir/${featurePathName}_mobile_landscape.dart';

String get featureRouteDir => '$featurePath/route';

String get featureRouteFile => '$featureRouteDir/${featurePathName}_route.dart';

String get featureArgumentFile =>
    '$featureRouteDir/${featurePathName}_argument.dart';

String get featureViewModelFile =>
    '$featurePath/${featurePathName}_view_model.dart';

String get featureAdaptiveUiFile =>
    '$featurePath/${featurePathName}_adaptive_ui.dart';

const String packageName = 'package:kirin_wellpark';

void main(List<String> arguments) {
  String? inputFeatureName = '';

  if (arguments.isEmpty) {
    print('Enter new feature name:');
    inputFeatureName = stdin.readLineSync();
    if (inputFeatureName == null || inputFeatureName.isEmpty) {
      print('Feature name cannot be empty.');
      return;
    }
  } else {
    inputFeatureName = arguments[0].trim();
  }

  featurePathName = convertToSnakeCase(inputFeatureName);
  featureVariableName = convertSnakeCaseToCamelCase(featurePathName);
  featureClassName = featureVariableName.capitalize();

  print('Feature path name: $featurePathName');
  print('Feature variable name: $featureVariableName');
  print('Feature class name: $featureClassName');

  //check if feature already exists
  final targetDir = Directory(featurePathName);
  if (targetDir.existsSync()) {
    print(
        'Feature "$featurePathName" already exists. try again with different name');
    return;
  }

  createFeatureStructure();
}

void createFeatureStructure() {
  final paths = [
    featureBindingDir,
    featureRouteDir,
    featureScreenDir,
  ];

  final files = {
    featureBindingFile: bindingContent(),
    featureArgumentFile: argumentContent(),
    featureRouteFile: routeContent(),
    featureMobilePortraitFile: mobilePortraitContent(),
    featureMobileLandscapeFile: mobileLandscapeContent(),
    featureAdaptiveUiFile: adaptiveUiContent(),
    featureViewModelFile: viewModelContent(),
  };

  for (final path in paths) {
    try {
      Directory(path).createSync(recursive: true);
    } catch (e) {
      print('Failed to create directory: $path. Error: $e');
      return;
    }
  }

  files.forEach((filePath, fileContent) {
    try {
      File(filePath).writeAsStringSync(fileContent);
    } catch (e) {
      print('Failed to create file: $filePath. Error: $e');
      return;
    }
  });

  print('Feature "$featurePathName" structure created successfully.');

  updateRoutePath();
}

String bindingContent() => '''
import '$packageName/$baseBindingFile';
import '$packageName/$featureViewModelFile';

class ${featureClassName}Binding extends BaseBinding {
  @override
  Future<void> addDependencies() async {
    // ${featureClassName}Repository ${featureVariableName}Repository = await diModule.resolve<${featureClassName}Repository>();
    return diModule.registerInstance(
       ${featureClassName}ViewModel(
       // ${featureVariableName}Repository: ${featureVariableName}Repository
       ),
     );
  }

  @override
  Future<void> removeDependencies() async {
    return diModule.unregister<${featureClassName}ViewModel>();
  }
}
''';

String argumentContent() => '''
import '$packageName/$baseArgumentFile';

class ${featureClassName}Argument extends BaseArgument {
  // int id;
  // String name;
  //
  // ${featureClassName}Argument({required this.id, required this.name});
}
''';

String routeContent() => '''
import 'package:flutter/material.dart';
import '$packageName/$baseRouteFile';
import '$packageName/$navigationRouteFilePath';
import '$packageName/$featureAdaptiveUiFile';
import '$packageName/$featureArgumentFile';

class ${featureClassName}Route extends BaseRoute<${featureClassName}Argument> {
  @override
  RoutePath routePath = RoutePath.$featureVariableName;

  ${featureClassName}Route({required super.arguments});

  @override
  MaterialPageRoute toMaterialPageRoute() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routePath.name),
      builder: (_) => ${featureClassName}AdaptiveUi(
        argument: arguments,
      ),
    );
  }
}
''';

String mobilePortraitContent() => '''
import 'package:flutter/material.dart';
import '$packageName/$baseUiStateFile';
import '$packageName/$featureViewModelFile';

class ${featureClassName}MobilePortrait extends StatefulWidget {
  final ${featureClassName}ViewModel viewModel;

  const ${featureClassName}MobilePortrait({required this.viewModel, super.key});

  @override
  State<StatefulWidget> createState() => ${featureClassName}MobilePortraitState();
}

class ${featureClassName}MobilePortraitState extends BaseUiState<${featureClassName}MobilePortrait> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: valueListenableBuilder(
        listenable: widget.viewModel.message,
        builder: (context, value) {
          return InkWell(
            child: Text('$featureClassName: \$value'),
            onTap: () => widget.viewModel.onClick(),
          );
        },
      ),
    );
  }
}
''';

String mobileLandscapeContent() => '''
import 'package:flutter/material.dart';
import '$packageName/$featureMobilePortraitFile';

class ${featureClassName}MobileLandscape extends ${featureClassName}MobilePortrait {
  const ${featureClassName}MobileLandscape({required super.viewModel, super.key});

  @override
  State<StatefulWidget> createState() => ${featureClassName}MobileLandscapeState();
}

class ${featureClassName}MobileLandscapeState extends ${featureClassName}MobilePortraitState {}
''';

String adaptiveUiContent() => '''
import 'package:flutter/material.dart';
import '$packageName/$baseAdaptiveUiFile';
import '$packageName/$featureBindingFile';
import '$packageName/$featureArgumentFile';
import '$packageName/$featureViewModelFile';
import '$packageName/$featureRouteFile';
import '$packageName/$featureMobilePortraitFile';
import '$packageName/$featureMobileLandscapeFile';

class ${featureClassName}AdaptiveUi extends BaseAdaptiveUi<${featureClassName}Argument, ${featureClassName}Route> {
  const ${featureClassName}AdaptiveUi({super.argument, super.key});

  @override
  State<StatefulWidget> createState() => ${featureClassName}AdaptiveUiState();
}

class ${featureClassName}AdaptiveUiState extends BaseAdaptiveUiState<${featureClassName}Argument, ${featureClassName}Route, ${featureClassName}AdaptiveUi, ${featureClassName}ViewModel, ${featureClassName}Binding> {
  @override
  ${featureClassName}Binding binding = ${featureClassName}Binding();

  @override
  StatefulWidget mobilePortraitContents(BuildContext context) {
    return ${featureClassName}MobilePortrait(viewModel: viewModel);
  }

  @override
  StatefulWidget mobileLandscapeContents(BuildContext context) {
    return ${featureClassName}MobileLandscape(viewModel: viewModel);
  }
}
''';

String viewModelContent() => '''
import 'package:flutter/foundation.dart';
import '$packageName/$baseViewModelFile';
import '$packageName/$featureArgumentFile';

class ${featureClassName}ViewModel extends BaseViewModel<${featureClassName}Argument> {

  final ValueNotifier<String> _message = ValueNotifier('$featureClassName');

  ValueListenable<String> get message => _message;

  int count = 0;

  ${featureClassName}ViewModel();

  @override
  void onViewReady({${featureClassName}Argument? argument}) {
    super.onViewReady();
  }

  void onClick() {
     count++;
    _message.value = '\${message.value}\$count';
  }

}
''';

void updateRoutePath() {
  final enumFilePath = File(navigationRouteFilePath);

  if (!enumFilePath.existsSync()) {
    print('RoutePath enum file not found.');
    return;
  }

  // Read the existing enum file content
  String enumContent = enumFilePath.readAsStringSync();

  // Add necessary imports for new feature after the last import statement
  final newImports = '''
import '$packageName/$featureArgumentFile';
import '$packageName/$featureRouteFile';
''';

  enumContent = newImports + enumContent;

  // 1. Replace the semicolon at the end of the last enum entry with a comma and add the new enum entry
  enumContent = enumContent.replaceFirst(
      RegExp(r'(\s*unknown;)'), '\n  $featureVariableName, \n  unknown;');

  // 2. Insert new cases for fromString, toPathString, and getAppRoute methods
  // Insert the new case for fromString method
  enumContent = enumContent.replaceFirstMapped(
      RegExp(r'(default:\s+return RoutePath\.unknown;)'),
      (match) =>
          "case '$featureVariableName':\n        return RoutePath.$featureVariableName;\n      ${match.group(0)}");

  // Insert the new case for toPathString method
  enumContent = enumContent.replaceFirstMapped(
      RegExp(r"(default:\s+return '';)", multiLine: true),
      (match) =>
          "case RoutePath.$featureVariableName:\n        return '$featureVariableName';\n      ${match.group(0)}");

  // Insert the new case for getAppRoute method
  enumContent = enumContent.replaceFirstMapped(
      RegExp(r'(default:\s+return UnknownRoute\(arguments: arguments\);)'),
      (match) =>
          "case RoutePath.$featureVariableName:\n        if (arguments is! ${featureClassName}Argument) {\n          throw Exception('${featureClassName}Argument is required');\n        }\n        return ${featureClassName}Route(arguments: arguments);\n      ${match.group(0)}");

  // Write the updated content back to the file
  try {
    enumFilePath.writeAsStringSync(enumContent);
    print('RoutePath updated successfully with new feature');
  } catch (e) {
    print('Failed to update RoutePath: $e');
  }
}

String convertToSnakeCase(String text) {
  return text.replaceAll(RegExp(r'\s+'), '_').toLowerCase();
}

String convertSnakeCaseToCamelCase(String snakeCase) {
  return snakeCase
      .split('_')
      .asMap()
      .map((index, word) {
        if (index == 0) {
          return MapEntry(index, word);
        } else {
          return MapEntry(index, word[0].toUpperCase() + word.substring(1));
        }
      })
      .values
      .join('');
}

extension StringExtension on String {
  String capitalize() {
    if (this == null) {
      throw ArgumentError("string: $this");
    }
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}
