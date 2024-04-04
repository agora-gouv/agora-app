flutter build appbundle --flavor dev -t lib/main_dev.dart --dart-define=app.flavor=Dev
rm build/app/outputs/bundle/devRelease/app-dev-release.apks
bundletool build-apks --bundle=build/app/outputs/bundle/devRelease/app-dev-release.aab --output=build/app/outputs/bundle/devRelease/app-dev-release.apks --mode=universal
tar -xzvf build/app/outputs/bundle/devRelease/app-dev-release.apks -C build/app/outputs/bundle/devRelease/
mv build/app/outputs/bundle/devRelease/universal.apk build/app/outputs/bundle/devRelease/app-dev-release.apk
firebase appdistribution:distribute build/app/outputs/bundle/devRelease/app-dev-release.apk --app 1:128862173768:android:e96bec772348b56fb3f67d --release-notes "build vendredi 29 mars"
