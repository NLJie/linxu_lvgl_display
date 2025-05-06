# 1. 基础配置
cmake_minimum_required(VERSION 3.10)
project(motor_gui)

set(CMAKE_C_STANDARD 99) # LVGL officially supports C99 and above
set(CMAKE_CXX_STANDARD 17) #C17
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/out/lib)
set(CMAKE_C_FLAGS "-Wall -O3")
set(CMAKE_CXX_FLAGS "-Wall -O3")
set(LVGL_ROOT_DIR ${PROJECT_SOURCE_DIR}/../../sources/)
include(scripts/common_config.cmake)

message("${GY}==========> 开始编译工程：${PROJECT_NAME}${E}")
message("${GY}==========> 工程源文件目录: ${PROJECT_SOURCE_DIR}${E}")

# 2. 检查配置文件中的后端显示框架的配置
set(LV_CONF_PATH "${PROJECT_SOURCE_DIR}/lv_conf.h")
foreach(BACKEND_NAME "SDL" "LINUX_DRM" "LINUX_FBDEV" "X11" "WAYLAND" "OPENGLES" "EVDEV" "LINUX_DRAW_GE2D")
    execute_process(WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                    COMMAND "scripts/backend_conf.sh" ${BACKEND_NAME} ${LV_CONF_PATH} OUTPUT_VARIABLE IS_BACKEND_ENABLED)
    set("LV_USE_${BACKEND_NAME}" ${IS_BACKEND_ENABLED})
endforeach()

if (LV_USE_LINUX_FBDEV)
    message("${GY}==========> Including FBDEV support${E}")
    list(APPEND LV_LINUX_BACKEND_SRC src/lib/display_backends/fbdev.c)
endif()

if (LV_USE_LINUX_DRAW_GE2D)
    message("${GY}==========> Including AIC_GE2D support${E}")
    # list(APPEND LV_LINUX_BACKEND_SRC src/lib/display_backends/fbdev.c)
endif()

if (LV_USE_EVDEV)
    message("${GY}==========> Including EVDEV support${E}")
    # find_package(PkgConfig REQUIRED)
    # pkg_check_modules(EVDEV REQUIRED libevdev)

    list(APPEND PKG_CONFIG_LIB ${EVDEV_LIBRARIES})
    list(APPEND PKG_CONFIG_INC ${EVDEV_INCLUDE_DIRS})
    list(APPEND LV_LINUX_BACKEND_SRC src/lib/indev_backends/evdev.c)

endif()


# 3. 添加子模块 lvgl
add_subdirectory(${PROJECT_SOURCE_DIR}/../../sources/lvgl lvgl)
target_include_directories(lvgl PUBLIC ${PROJECT_SOURCE_DIR} ${PROJECT_SOURCE_DIR}/src/lib )

# 4. 配置应用的源文件和头文件路径,并生成动态库
file(GLOB LV_LINUX_SRC src/lib/*.c)
set(LV_LINUX_INC src/lib/)

add_library(lvgl_linux STATIC ${LV_LINUX_SRC} ${LV_LINUX_BACKEND_SRC})
target_include_directories(lvgl_linux PRIVATE ${LV_LINUX_INC} ${PROJECT_SOURCE_DIR} ${LVGL_ROOT_DIR})

# 5. 添加可执行文件
add_executable(lvglsim src/main.c ${LV_LINUX_SRC} ${LV_LINUX_BACKEND_SRC})
target_link_libraries(lvglsim 
                    lvgl_linux 
                    lvgl 
                    lvgl::examples 
                    lvgl::demos 
                    lvgl::thorvg 
                    m pthread ${PKG_CONFIG_LIB})

target_include_directories(lvglsim PRIVATE ${LV_LINUX_INC} ${PROJECT_SOURCE_DIR} ${LVGL_ROOT_DIR})

# 6. 生成文件安装


# 7. 自定义部署

