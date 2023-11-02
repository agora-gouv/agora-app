rm build/app/outputs/bundle/prodRelease/app-prod-release.apks
bundletool build-apks --bundle=build/app/outputs/bundle/prodRelease/app-prod-release.aab --output=build/app/outputs/bundle/prodRelease/app-prod-release.apks --mode=universal
tar -xzvf build/app/outputs/bundle/prodRelease/app-prod-release.apks
mv build/app/outputs/bundle/prodRelease/universal.apk build/app/outputs/bundle/prodRelease/app-prod-release.apk