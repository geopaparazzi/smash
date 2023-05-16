set -x 

buildfolder=`pwd`
cp -r ~/.pub-cache $buildfolder/
export PUB_CACHE=$buildfolder/.pub-cache
.flutter/bin/flutter config --no-analytics

.flutter/bin/flutter pub get

sed -i -e /shrinkResources/d -e /minifyEnabled/d android/app/build.gradle
cd .pub-cache/git/background_locator_2-3e0e4dcad802b5122d480c940e391c4b518a4f45/android
sed -i -e /gms/d build.gradle
cd src/main/kotlin/yukams/app/background_locator_2
sed -i -e /gms/d -e '/fun getAccuracy/,/^}/d' -e s/getAccuracy// IsolateHolderExtension.kt
sed -i -e s/GoogleLocationProviderClient/AndroidLocationProviderClient/ IsolateHolderService.kt
sed -i -e '/getLocationMapFromLocation.*LocationResult/,/^        }/d' -e /gms/d provider/LocationParserUtil.kt
rm provider/GoogleLocationProviderClient.kt

cd $buildfolder

.flutter/bin/flutter build apk --no-tree-shake-icons

rm -rf .pub_cache
git checkout .

