cmake_minimum_required(VERSION 3.15)
project(android-tools-win)

if(NOT MSVC)
    message(FATAL_ERROR "ADB API for Windows can only be built using MSVC.")
endif()

# For static linking
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

set(adbwinapi_SOURCES
host/windows/usb/api/AdbWinApi.cpp
host/windows/usb/api/AdbWinApi.def
host/windows/usb/api/AdbWinApi.rc
host/windows/usb/api/adb_api.cpp
host/windows/usb/api/adb_api_instance.cpp
host/windows/usb/api/adb_endpoint_object.cpp
host/windows/usb/api/adb_helper_routines.cpp
host/windows/usb/api/adb_interface.cpp
host/windows/usb/api/adb_interface_enum.cpp
host/windows/usb/api/adb_io_completion.cpp
host/windows/usb/api/adb_legacy_endpoint_object.cpp
host/windows/usb/api/adb_legacy_interface.cpp
host/windows/usb/api/adb_legacy_io_completion.cpp
host/windows/usb/api/adb_object_handle.cpp
host/windows/usb/api/stdafx.cpp
)

add_library(AdbWinApi SHARED ${adbwinapi_SOURCES})
target_compile_definitions(AdbWinApi PRIVATE
ADBWIN_EXPORTS _CRT_NON_CONFORMING_SWPRINTFS _CRT_SECURE_NO_WARNINGS _UNICODE UNICODE
NTDDI_VERSION=NTDDI_WIN10 _WIN32_WINNT=_WIN32_WINNT_WIN10 WINVER=_WIN32_WINNT_WIN10)
target_link_libraries(AdbWinApi PRIVATE setupapi)

set(adbwinusbapi_SOURCES
host/windows/usb/winusb/AdbWinUsbApi.cpp
host/windows/usb/winusb/AdbWinUsbApi.def
host/windows/usb/winusb/AdbWinUsbApi.rc
host/windows/usb/winusb/adb_winusb_endpoint_object.cpp
host/windows/usb/winusb/adb_winusb_interface.cpp
host/windows/usb/winusb/adb_winusb_io_completion.cpp
host/windows/usb/winusb/stdafx.cpp
)

add_library(AdbWinUsbApi SHARED ${adbwinusbapi_SOURCES})
target_compile_definitions(AdbWinUsbApi PRIVATE
ADBWIN_EXPORTS _CRT_NON_CONFORMING_SWPRINTFS _CRT_SECURE_NO_WARNINGS _UNICODE UNICODE
NTDDI_VERSION=NTDDI_WIN10 _WIN32_WINNT=_WIN32_WINNT_WIN10 WINVER=_WIN32_WINNT_WIN10)
target_link_libraries(AdbWinUsbApi PRIVATE AdbWinApi winusb)

install(TARGETS AdbWinApi AdbWinUsbApi RUNTIME DESTINATION bin)
