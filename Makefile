# === Config ===
GHDL = ghdl
GHDLFLAGS = -fsynopsys --std=08

SRC_DIR = src
TB_DIR = testbenchs
BUILD_DIR = build
SIM_DIR = sim

# Tous les fichiers sources uniquement
SRC = $(shell find $(SRC_DIR) -name "*.vhd")

# Testbench sélectionné (via make tb=...)
tb ?= tb_processor.vhd
TB_PATH := $(shell find $(TB_DIR) -name $(tb))
TB_NAME := $(basename $(notdir $(tb)))

# Fichier VCD de sortie
VCD_FILE = $(SIM_DIR)/$(TB_NAME).vcd

# === Targets ===

all: sim

# Analyse (compile src + UN SEUL testbench)
analyze: $(BUILD_DIR)/work-obj08.cf

$(BUILD_DIR)/work-obj08.cf: $(SRC) $(TB_PATH)
	@mkdir -p $(BUILD_DIR)
	cd $(BUILD_DIR) && $(GHDL) -a $(GHDLFLAGS) \
		$(addprefix ../,$(SRC)) \
		../$(TB_PATH)

# Élaboration
elaborate: analyze
	cd $(BUILD_DIR) && $(GHDL) -e $(GHDLFLAGS) $(TB_NAME)

# Simulation avec VCD
sim: elaborate
	@mkdir -p $(SIM_DIR)
	cd $(BUILD_DIR) && $(GHDL) -r $(TB_NAME) --vcd=../$(VCD_FILE)
	@echo "Waveform générée : $(VCD_FILE)"

# Nettoyage
clean:
	rm -rf $(BUILD_DIR) $(SIM_DIR)

.PHONY: all analyze elaborate sim clean