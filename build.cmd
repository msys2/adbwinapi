:: Build script for adbwinapi

set "GIT_TAG=35.0.1"
set "GIT_DIR=development"
set "BUILD_ARCH=%~1"

if not exist "%cd%\%GIT_DIR%\" (
git clone ^
--depth=1 ^
--branch platform-tools-"%GIT_TAG%" ^
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
-G "Visual Studio 17 2022" ^
-A "%BUILD_ARCH%" ^
-B "build-%BUILD_ARCH%" ^
-S "%GIT_DIR%"

cmake ^
--build "build-%BUILD_ARCH%" ^
--config Release

7z a ^
-tzip "adbwinapi_sources.zip" ^
"%GIT_DIR%\host\windows\usb"
