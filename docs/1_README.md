# Agora onboarding

## Content

1. [Setting project](#setup)


<a name="setup"></a>
## Setting project

### 1. Android module Gradle setup
- Go to `agora/android/build.gradle` right click on it and click on `Link Gradle Project`.
- Open the `Gradle Tool Window` (if tab doesn't appear, click on `IntelliJ IDEA` > `View` > `Tool Windows` > `Gradle`), click on `+` and select the `android/` folder. 
- Gradle sync the Android project and error disappear.

### 2. Configure Dart style
- Open `IntelliJ IDEA` > `Preferences` > `Editor` > `Code Style` > `Dart`, Change Line Length to `120`
- `shift` + `option` + `Command` + `l` > `pop-up opened` > select `Optimize imports`

### 3. Add githooks
```shell
  git config core.hooksPath .githooks/
```

## Firebase
Add following file to path 
- /ios/firebase_app_id_file.json
- /ios/Runner/GoogleService-Info.plist
- /lib/firebase_options.dart 
- /android/app/google-services.json