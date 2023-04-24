# Flutter

## Navigation

We're using Flutter navigation:

- Each page is associated with a name, which is defined as a static constant in its file. For
  example in `ConsultationDetailsPage`:

```dart
static const routeName = "/consultationDetailsPage";
```

- All routes are defined in file `AgoraAppRouter`:
  - `onGenerateRoute` is used for page need specific configuration (share bloc to new page, animation, ...)
  - `routes` is used for all other simple cases
  -
- All routes are pushed with the variations of the `Navigator.pushNamed` method.
-
## Widget import

Use `import 'package:flutter/material.dart';` when importing base Flutter classes like
`StatefulWidget`, `Text`...

## StatefulWidget vs StatelessWidget

- Use StatelessWidget when no attribute in class or all attribute are final in class
- Use StatefulWidget when at least one attribute is not final in class
- `setState` forces the widget to refresh when the content of the attribute changes. If setState is
  not used, the content displayed on the screen is random (the widget can display the old value or
  the new one)

**StatelessWidget:**

```dart
class WidgetWithoutAttribute extends StatelessWidget {

  // no attribute exists

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

**StatelessWidget:**

```dart
class WidgetWithFinalAttribute extends StatelessWidget {
  final String attribute1;
  final Widget attribute2; // all attribute are final

  WidgetWithFinalAttribute(this.attribute1, this.attribute2);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

**StatefulWidget:**

```dart
class WidgetWithNoFinalAttribute extends StatefulWidget {
  final bool attribute1;

  WidgetWithNoFinalAttribute({Key? key, required this.attribute1}) : super(key: key);

  @override
  State<WidgetWithNoFinalAttribute> createState() => _WidgetWithNoFinalAttribute();
}

class _WidgetWithNoFinalAttribute extends State<WidgetWithNoFinalAttribute> {
  final String attribute2 = "Hello"; // this attribute is final
  String? attribute3; // but this attribute is not final then should use StatefulWidget

  @override
  Widget build(BuildContext context) {
    if (widget.attribute1) {
      attribute3 = "abc";
    } else {
      attribute3 = "def";
    }
    return Text("$attribute2 $attribute3");
  }
}
```

# Dart

## Order of class members

1. Static fields
2. Final properties
3. Mutable properties
4. Constructor(s)
5. Static methods
6. Public methods
7. Private methods

## Named arguments

```dart
// ❌
void doSomething(String a, String b, String c) {}

// ✅ single positional argument
void doSomething(String a) {}

// ✅ multiple named arguments
void doSomething({required String a, required String b, required String c}) {}

// ✅ combination of both
void doSomething(String a, {required String b, required String c, required String d}) {}
```

## Enum

```dart
enum ConsultationQuestionType { unique, ouverte, multiple}
```

## Equatable

If you need to compare two objects:

```dart
class FetchConsultationDetailsEvent extends Equatable {
  final String consultationId;

  FetchConsultationDetailsEvent({required this.consultationId});

  @override
  List<Object> get props => [consultationId];
}
```


# Test

We have 2 tests:

- repository test (example : `qag_repository_test.dart`)
- bloc test  (example : `qag_details_bloc_test.dart`)
