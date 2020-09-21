cmake_minimum_required(VERSION 3.9)

project(logan LANGUAGES CXX CUDA)

find_package(OpenMP)

add_executable(logan_demo demo.cu)
target_compile_definitions(logan_demo PRIVATE ADAPTABLE)
target_compile_features(logan_demo PRIVATE cxx_std_14)
target_link_libraries(logan_demo PRIVATE OpenMP::OpenMP_CXX)
target_compile_options(logan_demo
  PRIVATE
    -maxrregcount=32
    $<$<COMPILE_LANGUAGE:CUDA>:-gencode=arch=compute_50,code=sm_50>
    $<$<COMPILE_LANGUAGE:CUDA>:-gencode=arch=compute_52,code=sm_52>
    $<$<COMPILE_LANGUAGE:CUDA>:-gencode=arch=compute_60,code=sm_60>
    $<$<COMPILE_LANGUAGE:CUDA>:-gencode=arch=compute_61,code=sm_61>
    $<$<COMPILE_LANGUAGE:CUDA>:-gencode=arch=compute_70,code=sm_70>
    $<$<COMPILE_LANGUAGE:CUDA>:-Xcompiler=-Wall,-Wextra>
    $<$<COMPILE_LANGUAGE:CUDA>:-Xcompiler=-fopenmp>
)