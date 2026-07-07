:: Build script for adbwinapi

:: newer platform-tools-"%GIT_TAG%" are not tagged in AOSP
:: sync this with nmeum/android-tools project
set "GIT_BRANCH=android-16.0.0_r4"
set "GIT_DIR=development"
set "BUILD_ARCH=%~1"

if not exist "%cd%\%GIT_DIR%\" (
git clone ^
--depth=1 ^
--branch "%GIT_BRANCH%" ^
https://android.googlesource.com/platform/development.git ^
"%GIT_DIR%"

git apply ^
--directory="%GIT_DIR%" ^
0001-adbwinusb-fix-build.patch
)

if "%BUILD_ARCH%" == "" (
set "BUILD_ARCH=x64"
)

copy CMakeLists.txt "%GIT_DIR%\CMakeLists.txt"

cmake ^
-G "Visual Studio 18 2026" ^
-A "%BUILD_ARCH%" ^
-B "build-%BUILD_ARCH%" ^
-S "%GIT_DIR%"

cmake ^
--build "build-%BUILD_ARCH%" ^
--config Release

7z a ^
-tzip "adbwinapi_sources.zip" ^
"%GIT_DIR%\host\windows\usb"
