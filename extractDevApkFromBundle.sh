rm build/app/outputs/bundle/devRelease/app-dev-release.apks
bundletool build-apks --bundle=build/app/outputs/bundle/devRelease/app-dev-release.aab --output=build/app/outputs/bundle/devRelease/app-dev-release.apks --mode=universal
tar -xzvf build/app/outputs/bundle/devRelease/app-dev-release.apks -C build/app/outputs/bundle/devRelease/
mv build/app/outputs/bundle/devRelease/universal.apk build/app/outputs/bundle/devRelease/app-dev-release.apk