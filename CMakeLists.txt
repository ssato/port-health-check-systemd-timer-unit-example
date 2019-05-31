project(port-health-checker)
cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)

set(PORT_HEALTH_CHECKER_VERSION "0.0.1")

configure_file(${CMAKE_SOURCE_DIR}/src/port-health-checker-generator.sh.in
               ${PROJECT_BINARY_DIR}/port-health-checker-generator.sh @ONLY)

set(SYSTEMD_SYSTEM_DIR lib/systemd)
file(GLOB SYSTEMD_UNITS "${CMAKE_SOURCE_DIR}/src/*@.*")

install(DIRECTORY ${CMAKE_SOURCE_DIR}/conf DESTINATION etc/${CMAKE_PROJECT_NAME}.d/
        FILES_MATCHING PATTERN "*.conf")
install(FILES ${SYSTEMD_UNITS} DESTINATION ${SYSTEMD_SYSTEM_DIR}/system)
install(FILES ${CMAKE_SOURCE_DIR}/doc/port-health-checker.man DESTINATION share/man/man1)
install(PROGRAMS ${PROJECT_BINARY_DIR}/port-health-checker-generator.sh
        DESTINATION ${SYSTEMD_SYSTEM_DIR}/system-generators/)
