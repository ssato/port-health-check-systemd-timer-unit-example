set(SYSTEMD_DIR ${CMAKE_INSTALL_PREFIX}/lib/systemd)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/generate.bats.in
               ${PROJECT_BINARY_DIR}/tests/generate.bats @ONLY)
