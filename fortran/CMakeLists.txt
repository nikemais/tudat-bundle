enable_language(Fortran)

add_library(fortran_lib STATIC
	MCD.F90
)

target_compile_options(fortran_lib PRIVATE -fPIC)

target_include_directories(fortran_lib PUBLIC
	${CMAKE_CURRENT_SOURCE_DIR}
	/home/nicolo/netcdf-f/include
)

target_link_libraries(fortran_lib PUBLIC
	/home/nicolo/netcdf-f/lib64/libnetcdff.so
)
