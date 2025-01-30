set -x 

.flutter/bin/flutter clean

buildfolder=`pwd`
rm -rf $buildfolder/.pub-cache
cp -r ~/.pub-cache $buildfolder/
export PUB_CACHE=$buildfolder/.pub-cache
.flutter/bin/flutter config --no-analytics

rm -rf $buildfolder/.pub-cache/git/cache
rm -rf $buildfolder/.pub-cache/git/background_locator_2-*
rm -rf $buildfolder/.pub-cache/git/extended_image-*
rm -rf $buildfolder/.pub-cache/git/flutter_material_pickers-*
rm -rf $buildfolder/.pub-cache/git/flutter_path_provider_ex-*
rm -rf $buildfolder/.pub-cache/git/map_elevation-*
rm -rf $buildfolder/.pub-cache/git/mapsforge_flutter-*
rm -rf $buildfolder/.pub-cache/git/smashlibs-*

.flutter/bin/flutter pub get

sed -i -e /shrinkResources/d -e /minifyEnabled/d android/app/build.gradle
cd .pub-cache/git/background_locator_2-*/android
sed -i -e /gms/d build.gradle
cd src/main/kotlin/yukams/app/background_locator_2
sed -i -e /gms/d -e '/fun getAccuracy/,/^}/d' -e s/getAccuracy// IsolateHolderExtension.kt
sed -i -e s/GoogleLocationProviderClient/AndroidLocationProviderClient/ IsolateHolderService.kt
sed -i -e '/getLocationMapFromLocation.*LocationResult/,/^        }/d' -e /gms/d provider/LocationParserUtil.kt
rm provider/GoogleLocationProviderClient.kt

cd $buildfolder

.flutter/bin/flutter build apk --no-tree-shake-icons

#  if  build/app/outputs/flutter-apk/app-release.apk exists, move it to here and rename it
if [ -f build/app/outputs/flutter-apk/app-release.apk ]; then
    # get latest git tag and use it as version code
    version_code=`git describe --tags --abbrev=0`
    # remove 'version' from the tag'
    version_code=${version_code:7}
    mv build/app/outputs/flutter-apk/app-release.apk smash$version_code-unsigned.apk
fi

rm -rf .pub_cache
# git checkout .

