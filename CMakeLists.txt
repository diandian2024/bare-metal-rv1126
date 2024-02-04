cmake_minimum_required(VERSION 3.27.0)
project(rv1126-baremetal VERSION 0.1.0 LANGUAGES ASM C)

set(USE_QEMU FALSE)

if(USE_QEMU)
    set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/link-qemu-virt.ld)
else(USE_QEMU)
    set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/link.ld)
endif(USE_QEMU)

add_compile_options(
    -target arm-none-unknown-eabihf -mcpu=cortex-a7
    -mfpu=neon-vfpv4 -mfloat-abi=hard
    -fno-builtin -static -fno-pic
)

add_link_options(
    -fuse-ld=lld -static
    -target arm-none-unknown-eabihf -mcpu=cortex-a7
    -nostdlib -nostartfiles -nodefaultlibs
    -T ${LINKER_SCRIPT}
)

add_executable(rv1126-baremetal
    start.S stack.c exception.S exception.c
    pre_c.c main.c
)

add_custom_target(${PROJECT_NAME}.bin ALL
    DEPENDS ${PROJECT_NAME}
    COMMAND ${CMAKE_OBJCOPY} -O binary ${CMAKE_BINARY_DIR}/${PROJECT_NAME} ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.bin
)

if(USE_QEMU)
    add_custom_target(${PROJECT_NAME}.img ALL
        DEPENDS ${PROJECT_NAME}.bin
        COMMAND rm -rf ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.img
        COMMAND dd if=/dev/zero of=${CMAKE_BINARY_DIR}/${PROJECT_NAME}.img bs=4096 count=16384
        COMMAND dd if=${CMAKE_BINARY_DIR}/${PROJECT_NAME}.bin of=${CMAKE_BINARY_DIR}/${PROJECT_NAME}.img bs=4096 conv=notrunc
    )
else(USE_QEMU)
    add_custom_target(${PROJECT_NAME}.img ALL
        DEPENDS ${PROJECT_NAME}.bin
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/tools/boot_merger ${CMAKE_CURRENT_SOURCE_DIR}/tools/RV1126_BAREMETAL.ini
    )
endif(USE_QEMU)


add_custom_target(${PROJECT_NAME}.asm ALL
    DEPENDS ${PROJECT_NAME}
    COMMAND ${CMAKE_OBJDUMP} -dCS ${CMAKE_BINARY_DIR}/${PROJECT_NAME} > ${CMAKE_BINARY_DIR}/${PROJECT_NAME}.asm
)

add_custom_target(size
    DEPENDS ${PROJECT_NAME}
    COMMAND ${CMAKE_SIZE} ${CMAKE_BINARY_DIR}/${PROJECT_NAME}
)

add_custom_target(download_and_run
    DEPENDS ${PROJECT_NAME}.img
    COMMAND rkdeveloptool db ${CMAKE_CURRENT_SOURCE_DIR}/build/rv1126-baremetal.img.bin
    COMMAND rkdeveloptool ul ${CMAKE_CURRENT_SOURCE_DIR}/build/rv1126-baremetal.img.bin
)

# include(CTest)
# enable_testing()

# set(CPACK_PROJECT_NAME ${PROJECT_NAME})
# set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
# include(CPack)
