# generated from catkin/cmake/template/pkgConfig.cmake.in

# append elements to a list and remove existing duplicates from the list
# copied from catkin/cmake/list_append_deduplicate.cmake to keep pkgConfig
# self contained
macro(_list_append_deduplicate listname)
  if(NOT "${ARGN}" STREQUAL "")
    if(${listname})
      list(REMOVE_ITEM ${listname} ${ARGN})
    endif()
    list(APPEND ${listname} ${ARGN})
  endif()
endmacro()

# append elements to a list if they are not already in the list
# copied from catkin/cmake/list_append_unique.cmake to keep pkgConfig
# self contained
macro(_list_append_unique listname)
  foreach(_item ${ARGN})
    list(FIND ${listname} ${_item} _index)
    if(_index EQUAL -1)
      list(APPEND ${listname} ${_item})
    endif()
  endforeach()
endmacro()

# pack a list of libraries with optional build configuration keywords
# copied from catkin/cmake/catkin_libraries.cmake to keep pkgConfig
# self contained
macro(_pack_libraries_with_build_configuration VAR)
  set(${VAR} "")
  set(_argn ${ARGN})
  list(LENGTH _argn _count)
  set(_index 0)
  while(${_index} LESS ${_count})
    list(GET _argn ${_index} lib)
    if("${lib}" MATCHES "^(debug|optimized|general)$")
      math(EXPR _index "${_index} + 1")
      if(${_index} EQUAL ${_count})
        message(FATAL_ERROR "_pack_libraries_with_build_configuration() the list of libraries '${ARGN}' ends with '${lib}' which is a build configuration keyword and must be followed by a library")
      endif()
      list(GET _argn ${_index} library)
      list(APPEND ${VAR} "${lib}${CATKIN_BUILD_CONFIGURATION_KEYWORD_SEPARATOR}${library}")
    else()
      list(APPEND ${VAR} "${lib}")
    endif()
    math(EXPR _index "${_index} + 1")
  endwhile()
endmacro()

# unpack a list of libraries with optional build configuration keyword prefixes
# copied from catkin/cmake/catkin_libraries.cmake to keep pkgConfig
# self contained
macro(_unpack_libraries_with_build_configuration VAR)
  set(${VAR} "")
  foreach(lib ${ARGN})
    string(REGEX REPLACE "^(debug|optimized|general)${CATKIN_BUILD_CONFIGURATION_KEYWORD_SEPARATOR}(.+)$" "\\1;\\2" lib "${lib}")
    list(APPEND ${VAR} "${lib}")
  endforeach()
endmacro()


if(ikfastplug_CONFIG_INCLUDED)
  return()
endif()
set(ikfastplug_CONFIG_INCLUDED TRUE)

# set variables for source/devel/install prefixes
if("TRUE" STREQUAL "TRUE")
  set(ikfastplug_SOURCE_PREFIX /home/drew/ros_idx6dof/src/ikfastplug)
  set(ikfastplug_DEVEL_PREFIX /home/drew/ros_idx6dof/devel)
  set(ikfastplug_INSTALL_PREFIX "")
  set(ikfastplug_PREFIX ${ikfastplug_DEVEL_PREFIX})
else()
  set(ikfastplug_SOURCE_PREFIX "")
  set(ikfastplug_DEVEL_PREFIX "")
  set(ikfastplug_INSTALL_PREFIX /home/drew/ros_idx6dof/install)
  set(ikfastplug_PREFIX ${ikfastplug_INSTALL_PREFIX})
endif()

# warn when using a deprecated package
if(NOT "" STREQUAL "")
  set(_msg "WARNING: package 'ikfastplug' is deprecated")
  # append custom deprecation text if available
  if(NOT "" STREQUAL "TRUE")
    set(_msg "${_msg} ()")
  endif()
  message("${_msg}")
endif()

# flag project as catkin-based to distinguish if a find_package()-ed project is a catkin project
set(ikfastplug_FOUND_CATKIN_PROJECT TRUE)

if(NOT " " STREQUAL " ")
  set(ikfastplug_INCLUDE_DIRS "")
  set(_include_dirs "")
  foreach(idir ${_include_dirs})
    if(IS_ABSOLUTE ${idir} AND IS_DIRECTORY ${idir})
      set(include ${idir})
    elseif("${idir} " STREQUAL "include ")
      get_filename_component(include "${ikfastplug_DIR}/../../../include" ABSOLUTE)
      if(NOT IS_DIRECTORY ${include})
        message(FATAL_ERROR "Project 'ikfastplug' specifies '${idir}' as an include dir, which is not found.  It does not exist in '${include}'.  Ask the maintainer 'ubuntu <ubuntu@todo.todo>' to fix it.")
      endif()
    else()
      message(FATAL_ERROR "Project 'ikfastplug' specifies '${idir}' as an include dir, which is not found.  It does neither exist as an absolute directory nor in '/home/drew/ros_idx6dof/src/ikfastplug/${idir}'.  Ask the maintainer 'ubuntu <ubuntu@todo.todo>' to fix it.")
    endif()
    _list_append_unique(ikfastplug_INCLUDE_DIRS ${include})
  endforeach()
endif()

set(libraries "")
foreach(library ${libraries})
  # keep build configuration keywords, target names and absolute libraries as-is
  if("${library}" MATCHES "^(debug|optimized|general)$")
    list(APPEND ikfastplug_LIBRARIES ${library})
  elseif(TARGET ${library})
    list(APPEND ikfastplug_LIBRARIES ${library})
  elseif(IS_ABSOLUTE ${library})
    list(APPEND ikfastplug_LIBRARIES ${library})
  else()
    set(lib_path "")
    set(lib "${library}-NOTFOUND")
    # since the path where the library is found is returned we have to iterate over the paths manually
    foreach(path /home/drew/ros_idx6dof/devel/lib;/home/drew/ros_idx6dof/devel/lib;/opt/ros/kinetic/lib)
      find_library(lib ${library}
        PATHS ${path}
        NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
      if(lib)
        set(lib_path ${path})
        break()
      endif()
    endforeach()
    if(lib)
      _list_append_unique(ikfastplug_LIBRARY_DIRS ${lib_path})
      list(APPEND ikfastplug_LIBRARIES ${lib})
    else()
      # as a fall back for non-catkin libraries try to search globally
      find_library(lib ${library})
      if(NOT lib)
        message(FATAL_ERROR "Project '${PROJECT_NAME}' tried to find library '${library}'.  The library is neither a target nor built/installed properly.  Did you compile project 'ikfastplug'?  Did you find_package() it before the subdirectory containing its code is included?")
      endif()
      list(APPEND ikfastplug_LIBRARIES ${lib})
    endif()
  endif()
endforeach()

set(ikfastplug_EXPORTED_TARGETS "")
# create dummy targets for exported code generation targets to make life of users easier
foreach(t ${ikfastplug_EXPORTED_TARGETS})
  if(NOT TARGET ${t})
    add_custom_target(${t})
  endif()
endforeach()

set(depends "")
foreach(depend ${depends})
  string(REPLACE " " ";" depend_list ${depend})
  # the package name of the dependency must be kept in a unique variable so that it is not overwritten in recursive calls
  list(GET depend_list 0 ikfastplug_dep)
  list(LENGTH depend_list count)
  if(${count} EQUAL 1)
    # simple dependencies must only be find_package()-ed once
    if(NOT ${ikfastplug_dep}_FOUND)
      find_package(${ikfastplug_dep} REQUIRED NO_MODULE)
    endif()
  else()
    # dependencies with components must be find_package()-ed again
    list(REMOVE_AT depend_list 0)
    find_package(${ikfastplug_dep} REQUIRED NO_MODULE ${depend_list})
  endif()
  _list_append_unique(ikfastplug_INCLUDE_DIRS ${${ikfastplug_dep}_INCLUDE_DIRS})

  # merge build configuration keywords with library names to correctly deduplicate
  _pack_libraries_with_build_configuration(ikfastplug_LIBRARIES ${ikfastplug_LIBRARIES})
  _pack_libraries_with_build_configuration(_libraries ${${ikfastplug_dep}_LIBRARIES})
  _list_append_deduplicate(ikfastplug_LIBRARIES ${_libraries})
  # undo build configuration keyword merging after deduplication
  _unpack_libraries_with_build_configuration(ikfastplug_LIBRARIES ${ikfastplug_LIBRARIES})

  _list_append_unique(ikfastplug_LIBRARY_DIRS ${${ikfastplug_dep}_LIBRARY_DIRS})
  list(APPEND ikfastplug_EXPORTED_TARGETS ${${ikfastplug_dep}_EXPORTED_TARGETS})
endforeach()

set(pkg_cfg_extras "")
foreach(extra ${pkg_cfg_extras})
  if(NOT IS_ABSOLUTE ${extra})
    set(extra ${ikfastplug_DIR}/${extra})
  endif()
  include(${extra})
endforeach()
