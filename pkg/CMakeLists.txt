configure_file(${CMAKE_CURRENT_SOURCE_DIR}/package.spec.in ${PROJECT_BINARY_DIR}/package.spec @ONLY)
add_custom_target(srpm COMMAND "${CMAKE_CURRENT_SOURCE_DIR}/rpmbuild-wrapper.sh" "-w" "${PROJECT_BINARY_DIR}" "-S" "${PROJECT_BINARY_DIR}/${CPACK_SOURCE_PACKAGE_FILE_NAME}.tar.xz" "${PROJECT_BINARY_DIR}/package.spec")
