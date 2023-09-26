#flutter build ipa --build-name="$VERSION_NAME" --build-number=$VERSION_CODE --export-options-plist=ios/Params/ExportOptionsAdHoc.plist -t lib/$ENTRYPOINT --flavor=$FLAVOR
#flutter build ipa --target=lib/main_dev.dart --flavor=dev --dart-define=app.flavor=Dev --export-options-plist=ios/Params/ExportOptionsAdHoc.plist --build-name="1.0.1" --build-number=22
flutter build ipa --target=lib/main_prod.dart --flavor=prod --dart-define=app.flavor=Prod --export-options-plist=ios/Params/ExportOptionsProd.plist --build-name="1.0.1" --build-number=16