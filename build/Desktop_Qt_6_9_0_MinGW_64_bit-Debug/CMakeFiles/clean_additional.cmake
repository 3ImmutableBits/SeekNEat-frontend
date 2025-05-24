# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appui_im_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appui_im_autogen.dir\\ParseCache.txt"
  "appui_im_autogen"
  )
endif()
