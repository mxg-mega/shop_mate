cmake_minimum_required(VERSION 3.5)
project(runner LANGUAGES CXX)

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /DEBUG:FASTLINK")

add_executable(${BINARY_NAME} WIN32
  "flutter_window.cpp"
  "main.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "Runner.rc"
  "runner.exe.manifest"
)

apply_standard_settings(${BINARY_NAME})

# Version definitions
target_compile_definitions(${BINARY_NAME} PRIVATE 
  "FLUTTER_VERSION=\"${FLUTTER_VERSION}\""
  "FLUTTER_VERSION_MAJOR=${FLUTTER_VERSION_MAJOR}"
  "FLUTTER_VERSION_MINOR=${FLUTTER_VERSION_MINOR}"
  "FLUTTER_VERSION_PATCH=${FLUTTER_VERSION_PATCH}"
  "FLUTTER_VERSION_BUILD=${FLUTTER_VERSION_BUILD}"
  "NOMINMAX"
)

# System libraries (Windows + Flutter)
target_link_libraries(${BINARY_NAME} PRIVATE
  flutter
  flutter_wrapper_app
  dwmapi.lib
  ws2_32.lib
  crypt32.lib
  rpcrt4.lib
  ole32.lib
  bcrypt.lib
  advapi32.lib
  shell32.lib
  icu.lib  # Required for Flutter text rendering
)

# Firebase libraries are linked via .vcxproj (DO NOT add them here)

target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")
add_dependencies(${BINARY_NAME} flutter_assemble)