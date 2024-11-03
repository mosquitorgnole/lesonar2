all: camera_raylib scan3d_sokol
clean:
	rm camera_charting camera_raylib scan3d_sokol

camera_raylib: camera_raylib.c protocol.h
	gcc -o camera_raylib camera_raylib.c circularbuffer.c -std=gnu99 -Ofast -march=native -lfftw3 -lfftw3_threads -lpthread   -lm -lcglm -lraylib -L . -lftd3xx

scan3d_sokol: scan3d_sokol.c protocol.h
	gcc  -o scan3d_sokol glfw_glue.c circularbuffer.c scan3d_sokol.c -std=gnu99 -Ofast -march=native -Isokol -lfftw3 -lfftw3_threads -lpthread  -lm -lcglm -lglfw -lGL -L . -lftd3xx
