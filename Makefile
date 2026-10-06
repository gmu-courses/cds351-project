FC      = gfortran

FFLAGS  = -std=f2018 -Wall -Wextra -fcheck=all -g \
          -Jbuild -Ibuild

TARGET  = bin/main.x

OBJECTS = build/statistics_mod.o \
          build/io_mod.o \
          build/main.o
.PHONY: all run clean dirs

all: dirs $(TARGET)

dirs:
	mkdir -p bin build output

$(TARGET): $(OBJECTS)
	$(FC) $(OBJECTS) -o $@

build/statistics_mod.o: src/statistics_mod.f90 | dirs
	$(FC) $(FFLAGS) -c $< -o $@

build/io_mod.o: src/io_mod.f90 | dirs
	$(FC) $(FFLAGS) -c $< -o $@

build/main.o: src/main.f90 build/statistics_mod.o \
              build/io_mod.o | dirs
	$(FC) $(FFLAGS) -c $< -o $@

run: all
	./$(TARGET)

clean:
	$(RM) build/*.o build/*.mod $(TARGET) output/summary.txt

