include(uncaughtTaskLib)
ADD_LIBRARY(${UNCAUGHT_TASKLIB_NAME} SHARED 
    ${UNCAUGHT_TASKLIB_SOURCES})


TARGET_LINK_LIBRARIES(${UNCAUGHT_TASKLIB_NAME}
    ${OrocosRTT_LIBRARIES}
    ${UNCAUGHT_TASKLIB_DEPENDENT_LIBRARIES})
SET_TARGET_PROPERTIES(${UNCAUGHT_TASKLIB_NAME}
    PROPERTIES LINK_INTERFACE_LIBRARIES "${UNCAUGHT_TASKLIB_INTERFACE_LIBRARIES}")

INSTALL(TARGETS ${UNCAUGHT_TASKLIB_NAME}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib/orocos)

INSTALL(FILES ${UNCAUGHT_TASKLIB_HEADERS}
    DESTINATION include/orocos/uncaught)

