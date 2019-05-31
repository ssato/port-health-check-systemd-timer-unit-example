configure_file(${CMAKE_CURRENT_SOURCE_DIR}/port-health-checker-generator.sh.in
               ${PROJECT_BINARY_DIR}/port-health-checker-generator.sh @ONLY)

set(SYSTEMD_SYSTEM_DIR lib/systemd)
file(GLOB SYSTEMD_UNITS "${CMAKE_CURRENT_SOURCE_DIR}/*@.*")

install(FILES ${SYSTEMD_UNITS} DESTINATION ${SYSTEMD_SYSTEM_DIR}/system)
install(PROGRAMS ${PROJECT_BINARY_DIR}/port-health-checker-generator.sh
        DESTINATION ${SYSTEMD_SYSTEM_DIR}/system-generators/)
