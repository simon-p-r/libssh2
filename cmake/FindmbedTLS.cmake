#
# - Find the mbedTLS include file and library
# 
# Read-Only variables
#  MBEDTLS_FOUND - system has mbedTLS
#  MBEDTLS_INCLUDE_DIR - the mbedTLS include directory
#  MBEDTLS_LIBRARY_DIR - the mbedTLS library directory
#  MBEDTLS_LIBRARIES - Link these to use mbedTLS
#  MBEDTLS_LIBRARY - path to mbedTLS library
#  MBEDX509_LIBRARY - path to mbedTLS X.509 library
#  MBEDCRYPTO_LIBRARY - path to mbedTLS Crypto library
#
# Hint
#  MBEDTLS_ROOT_DIR can be pointed to a local mbedTLS installation.


include(FindPackageHandleStandardArgs)

set(_MBEDTLS_ROOT_HINTS
    ${MBEDTLS_ROOT_DIR}
    ENV MBEDTLS_ROOT_DIR
)


find_path(MBEDTLS_INCLUDE_DIR
    NAMES 
        mbedtls/version.h
    HINTS 
        ${_MBEDTLS_ROOT_HINTS}
    PATH_SUFFIXES 
        include
)

if(MBEDTLS_INCLUDE_DIR AND MBEDTLS_LIBRARIES)
    # Already in cache, be silent
    set(MBEDTLS_FIND_QUIETLY TRUE)
endif()

find_library(MBEDTLS_LIBRARY
    NAMES 
        mbedtls libmbedtls
    HINTS 
        ${_MBEDTLS_ROOT_HINTS}
    PATH_SUFFIXES 
        library lib
)

find_library(MBEDX509_LIBRARY
    NAMES 
        mbedx509 libmbedx509
    HINTS 
        ${_MBEDTLS_ROOT_HINTS}
    PATH_SUFFIXES 
        library lib
)

find_library(MBEDCRYPTO_LIBRARY
    NAMES 
        mbedcrypto libmbedcrypto
    HINTS 
        ${_MBEDTLS_ROOT_HINTS}
    PATH_SUFFIXES
        library lib
)

if(MBEDTLS_INCLUDE_DIR AND MBEDTLS_LIBRARY AND MBEDX509_LIBRARY AND MBEDCRYPTO_LIBRARY)
     set(MBEDTLS_FOUND TRUE)
endif()

if(MBEDTLS_FOUND)
    set(MBEDTLS_LIBRARIES "${MBEDTLS_LIBRARY} ${MBEDX509_LIBRARY} ${MBEDCRYPTO_LIBRARY}")
    set(MBEDTLS_INCLUDE_DIRS "${MBEDTLS_INCLUDE_DIR}")

    if(NOT MBEDTLS_FIND_QUIETLY)
        message(STATUS "Found mbedTLS:")
        file(READ ${MBEDTLS_INCLUDE_DIR}/mbedtls/version.h MBEDTLSCONTENT)
        string(REGEX MATCH "MBEDTLS_VERSION_STRING +\"[0-9|.]+\"" MBEDTLSMATCH ${MBEDTLSCONTENT})
        if (MBEDTLSMATCH)
            string(REGEX REPLACE "MBEDTLS_VERSION_STRING +\"([0-9|.]+)\"" "\\1" MBEDTLS_VERSION ${MBEDTLSMATCH})
            message(STATUS "  version ${MBEDTLS_VERSION}")
        endif(MBEDTLSMATCH)
        message(STATUS "  TLS: ${MBEDTLS_LIBRARY}")
        message(STATUS "  X509: ${MBEDX509_LIBRARY}")
        message(STATUS "  Crypto: ${MBEDCRYPTO_LIBRARY}")
    endif(NOT MBEDTLS_FIND_QUIETLY)
else(MBEDTLS_FOUND)
    if(MBEDTLS_FIND_REQUIRED)
        message(FATAL_ERROR "Could not find mbedTLS")
    endif(MBEDTLS_FIND_REQUIRED)
endif(MBEDTLS_FOUND)


find_package_handle_standard_args(MbedTLS
	DEFAULT_MSG
	MBEDTLS_INCLUDE_DIRS MBEDTLS_LIBRARIES
)


mark_as_advanced(
    MBEDTLS_INCLUDE_DIR
    MBEDTLS_LIBRARY_DIR
    MBEDTLS_LIBRARIES
    MBEDTLS_LIBRARY
    MBEDX509_LIBRARY
    MBEDCRYPTO_LIBRARY
)

