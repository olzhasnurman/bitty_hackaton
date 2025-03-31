load_package flow

#========================================================================== params
set FAMILY_NAME    "Cyclone V"
set DEVICE_NAME    5CSEMA5F31C6
set TOP_NAME       bigger
set PROJ_NAME      bitty_hackaton
#========================================================================== params : end

#========================================================================== paths
set TCL_PATH       [file dirname [file normalize [info script]]]
set SF_PATH        $TCL_PATH/synt_files
set TMP_PATH       $TCL_PATH/../tmp
set PROJ_PATH      $TMP_PATH/$PROJ_NAME
set SRC_PATH       $TCL_PATH/../rtl

set SYNT_PATH      $TMP_PATH/synt
set RESULT_PATH    $TMP_PATH/result
#========================================================================== paths : end

#========================================================================== src files
set SRC_FILES      [glob -directory $SRC_PATH "*.*v*"]
set CONSTRAINTS    $SF_PATH/constr.sdc
#========================================================================== src files : end

#========================================================================== tmp clear
if {[file exists $PROJ_PATH] == 1} { 
  file delete -force -- $PROJ_PATH
}
file mkdir $PROJ_PATH
cd $PROJ_PATH
#========================================================================== tmp clear : end

#========================================================================== proj_build
project_new $PROJ_NAME -overwrite -revision $PROJ_NAME
set_global_assignment -name FAMILY $FAMILY_NAME
set_global_assignment -name DEVICE $DEVICE_NAME
set_global_assignment -name TOP_LEVEL_ENTITY $TOP_NAME

# Add source files
foreach src_file $SRC_FILES {
    set file_ext [file extension $src_file]
    if {$file_ext == ".v"} {
        set_global_assignment -name VERILOG_FILE $src_file
    } elseif {$file_ext == ".sv"} {
        set_global_assignment -name SYSTEMVERILOG_FILE $src_file
    } elseif {$file_ext == ".vhd"} {
        set_global_assignment -name VHDL_FILE $src_file
    }
}

# Add constraints file (assuming SDC format)
if {[file exists $CONSTRAINTS]} {
    set_global_assignment -name SDC_FILE $CONSTRAINTS
}

# Synthesis settings
set_global_assignment -name OPTIMIZATION_TECHNIQUE SPEED
set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS ON
#========================================================================== proj_build : end

execute_flow -compile