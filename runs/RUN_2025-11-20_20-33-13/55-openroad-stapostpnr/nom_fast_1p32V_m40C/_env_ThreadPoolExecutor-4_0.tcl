set ::env(STEP_ID) OpenROAD.STAPostPNR
set ::env(TECH_LEF) /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef
set ::env(MACRO_LEFS) ""
set ::env(STD_CELL_LIBRARY) sg13g2_stdcell
set ::env(VDD_PIN) VPWR
set ::env(VDD_PIN_VOLTAGE) 1.20
set ::env(GND_PIN) VGND
set ::env(TECH_LEFS) "\"nom_*\" /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef \"min_*\" /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef \"max_*\" /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef"
set ::env(PRIMARY_GDSII_STREAMOUT_TOOL) magic
set ::env(DEFAULT_CORNER) nom_typ_1p20V_25C
set ::env(STA_CORNERS) "nom_fast_1p32V_m40C nom_slow_1p08V_125C nom_typ_1p20V_25C"
set ::env(FP_IO_HLAYER) Metal3
set ::env(FP_IO_VLAYER) Metal2
set ::env(RT_MIN_LAYER) Metal2
set ::env(RT_MAX_LAYER) TopMetal2
set ::env(SCL_GROUND_PINS) VSS
set ::env(SCL_POWER_PINS) VDD
set ::env(TRISTATE_CELLS) "\"sg13g2_ebufn_*\" \"sg13g2_einvn_*\""
set ::env(FILL_CELLS) "sg13g2_fill_1 sg13g2_fill_2"
set ::env(DECAP_CELLS) "\"sg13g2_decap_*\""
set ::env(LIB) "nom_typ_1p20V_25C /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib nom_fast_1p32V_m40C /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_fast_1p32V_m40C.lib nom_slow_1p08V_125C /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_slow_1p08V_125C.lib"
set ::env(CELL_LEFS) /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_stdcell.lef
set ::env(CELL_GDS) /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/gds/sg13g2_stdcell.gds
set ::env(CELL_VERILOG_MODELS) /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/verilog/sg13g2_stdcell.v
set ::env(CELL_SPICE_MODELS) /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/spice/sg13g2_stdcell.spice
set ::env(CELL_CDLS) /foss/pdks/ihp-sg13g2/libs.ref/sg13g2_stdcell/cdl/sg13g2_stdcell.cdl
set ::env(SYNTH_EXCLUDED_CELL_FILE) /foss/pdks/ihp-sg13g2/libs.tech/librelane/sg13g2_stdcell/synth_exclude.cells
set ::env(PNR_EXCLUDED_CELL_FILE) /foss/pdks/ihp-sg13g2/libs.tech/librelane/sg13g2_stdcell/pnr_exclude.cells
set ::env(OUTPUT_CAP_LOAD) 6.0
set ::env(MAX_FANOUT_CONSTRAINT) 10
set ::env(CLOCK_UNCERTAINTY_CONSTRAINT) 0.25
set ::env(CLOCK_TRANSITION_CONSTRAINT) 0.15
set ::env(TIME_DERATING_CONSTRAINT) 5
set ::env(IO_DELAY_CONSTRAINT) 20
set ::env(SYNTH_DRIVING_CELL) sg13g2_buf_4/X
set ::env(SYNTH_TIEHI_CELL) sg13g2_tiehi/L_HI
set ::env(SYNTH_TIELO_CELL) sg13g2_tielo/L_LO
set ::env(SYNTH_BUFFER_CELL) sg13g2_buf_1/A/X
set ::env(PLACE_SITE) CoreSite
set ::env(CELL_PAD_EXCLUDE) "\"sg13g2_fill_*\" \"sg13g2_decap_*\""
set ::env(DIODE_CELL) sg13g2_antennanp
set ::env(DESIGN_NAME) bfloat16_spi_top
set ::env(CLOCK_PERIOD) 6.667
set ::env(CLOCK_PORT) clk
set ::env(FALLBACK_SDC) /usr/local/lib/python3.12/dist-packages/librelane/scripts/base.sdc
set ::env(SET_RC_VERBOSE) 0
set ::env(LAYERS_RC) ""
set ::env(PDN_CONNECT_MACROS_TO_GRID) 1
set ::env(PDN_ENABLE_GLOBAL_CONNECTIONS) 1
set ::env(PNR_SDC_FILE) /foss/designs/Task/N3/op.sdc
set ::env(DEDUPLICATE_CORNERS) 0
set ::env(STA_MACRO_PRIORITIZE_NL) 1
set ::env(SIGNOFF_SDC_FILE) /foss/designs/Task/N3/op.sdc
set ::env(CURRENT_NL) /foss/designs/Task/N3/runs/RUN_2025-11-20_20-33-13/52-openroad-fillinsertion/bfloat16_spi_top.nl.v
set ::env(CURRENT_SPEF) "\"nom_*\" /foss/designs/Task/N3/runs/RUN_2025-11-20_20-33-13/54-openroad-rcx/nom/bfloat16_spi_top.nom.spef"
set ::env(CURRENT_ODB) /foss/designs/Task/N3/runs/RUN_2025-11-20_20-33-13/53-odb-cellfrequencytables/bfloat16_spi_top.odb
set ::env(SAVE_SDC) /foss/designs/Task/N3/runs/RUN_2025-11-20_20-33-13/55-openroad-stapostpnr/bfloat16_spi_top.sdc
set ::env(OPENLANE_SDC_IDEAL_CLOCKS) 0
