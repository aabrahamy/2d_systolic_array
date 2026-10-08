# wsl
# make (build and run)
# make clean

TOP := tb_processing_element
RTL_DIR := ../../rtl
SRCS := $(RTL_DIR)/processing_element.sv tb_processing_element.sv

all: run

obj_dir/V$(TOP): $(SRCS)
	verilator --binary --timing --trace -Wall -Wno-fatal --top-module $(TOP) $(SRCS)

run: obj_dir/V$(TOP)
	./obj_dir/V$(TOP)

clean:
	rm -rf obj_dir

.PHONY: all run clean
