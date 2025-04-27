# bitty_hackaton
## Guide: Using the Quartus Automation Script (`run.py`)

### 1. Introduction

This Python script (`run.py`) automates project creation, compilation, opening GUI, and performance metrics collection for a Quartus FPGA project. It simplifies the workflow by wrapping Quartus command-line operations and external TCL/Python scripts.

The script is pre-configured for a project named `"bitty_hackaton"`. You can change this to whatever project you want to create, but make sure to modify the variable PROJ_NAME in .tcl and .py scripts in ./scripts folder.

### 2. Prerequisites

Before using the script, ensure you have the following:

1.  **Python 3:** Installed on your system and accessible from the command line.
2.  **Intel Quartus Prime Lite Edition:** Installed on your system. The script defaults to version `23.1std` Lite Edition installed at `C:/intelFPGA_lite/23.1std/`. However you can change it in run.py script.
3.  **Project Files:**
    * The `run.py` script itself.
    * An `rtl` directory containing your Verilog/SystemVerilog source files.
    * A `scripts` directory containing the necessary helper scripts:
        * `proj.tcl`: A Tcl script for creating the Quartus project.
        * `synt.tcl`: A Tcl script for running synthesis and implementation.
        * `metr_collection.py`: A Python script for collecting performance metrics after compilation.

### 3. Setup and Configuration

Before running the script for the first time, you **must** check and potentially modify the following constants within `run.py`:

1.  **`PROJ_NAME`**:
    * Default: `"bitty_hackaton"`
    * Purpose: Defines the name of your Quartus project.
    * **Important:** If you change this value in `run.py`, you **must** also ensure the corresponding project name is updated within the `proj.tcl`, `synt.tcl` and `metr_collection.py` scripts located in the `./scripts/` directory, as they use this name internally.

2.  **`QUARTUS_SH_EXE`**:
    * Default: `"C:/intelFPGA_lite/23.1std/quartus/bin64/quartus_sh.exe -t "`
    * Purpose: Path to the Quartus shell executable (`quartus_sh.exe`) used for running Tcl scripts. The `-t` flag indicates that a Tcl script follows.
    * **Action:** Verify this path matches your Quartus installation directory and version. Adjust if necessary.

3.  **`QUARTUS_GUI_EXE`**:
    * Default: `"C:/intelFPGA_lite/23.1std/quartus/bin64/quartus.exe "`
    * Purpose: Path to the main Quartus GUI executable (`quartus.exe`) used for opening the project.
    * **Action:** Verify this path matches your Quartus installation directory and version. Adjust if necessary.

3.  **`TOP_NAME`**:
    * Default: `"bigger"`
    * Purpose: The name of the top module in Quartus Project
    * **Important:** If the name of the top module is different in your design make sure to modify this in `proj.tcl` and `synt.tcl` scripts located in the `./scripts/` directory.

### 4. Directory Structure

The script expects the following directory structure:

```
your_project_folder/
├── run.py                 # The main Python script
├── rtl/                   # Directory for your hardware description files
│   └── your_design.v      # Example Verilog file
│   └── ...                # Other source files
└── scripts/               # Directory for helper scripts
    ├── proj.tcl           # Tcl script for project creation
    ├── synt.tcl           # Tcl script for synthesis/implementation
    ├── metr_collection.py # Python script for metrics collection
    └── synt_files         # Contains .SDC constraint file for timing analysis
```

You should run the `run.py` from the main repo directory.

### 5. Usage (Command-Line Options)

Open a command prompt or terminal, navigate to `bitty_hackaton/`, and run the script using `python run.py` followed by one of the available flags:

* **`-h` or `--help`**:
    * Displays a help message listing all available commands and their descriptions.
    * This is also the default action if no flags are provided.
    * Example: `python run.py -h`

* **`-n` or `--new_project`**:
    * **Action:** Creates a new Quartus project. It executes the `scripts/proj.tcl` script using `quartus_sh.exe`. This Tcl script is expected to find your source files in the `./rtl` directory and set up the project settings.
    * **Output:** Creates a `tmp` directory (if it doesn't exist) and places the Quartus project files inside `./tmp/PROJ_NAME/` (e.g., `./tmp/bitty_hackaton/`).
    * Example: `python run.py -n`

* **`-o` or `--open_project`**:
    * **Action:** Opens the generated Quartus project (`./tmp/PROJ_NAME/PROJ_NAME.qpf`) in the Quartus GUI (`quartus.exe`).
    * **Prerequisite:** The project must have been created first (using `-n`).
    * Example: `python run.py -o`

* **`-r` or `--run_synthesis`**:
    * **Action:** Compiles the design by running synthesis and implementation. It executes the `scripts/synt.tcl` script using `quartus_sh.exe`.
    * **Prerequisite:** The project must have been created first (using `-n`).
    * **Output:** Generates compilation reports and output files within the `./tmp/PROJ_NAME/` directory.
    * Example: `python run.py -r`

* **`-m` or `--metrics`**:
    * **Action:** Collects performance metrics from the compilation results by executing the `scripts/metr_collection.py` script. This parses Quartus report files (`.rpt`) and saves the results to `result.txt` file.
    * **Output:** Generated results are saved in `result.txt` file and printed into the terminal. The performance metrics include the maximum achievable clock frequency and area.
    * **Prerequisite:** The design must have been compiled first (using `-r`).
    * Example: `python run.py -m`

* **`-c` or `--clean`**:
    * **Action:** Cleans the workspace by removing generated files and directories. Specifically, it deletes the entire `./tmp` directory and `result.txt` file containing performance results.
    * **Note:** This command uses Windows-specific commands (`rmdir /s /q` and `del /f /q`). It will **not** work as intended on Linux or macOS.
    * Example: `python run.py -c`

### 6. Example Workflow

A typical workflow using this script might be:

1.  **Create the Project:**
    ```bash
    python run.py -n
    ```
2.  **Compile the Design:**
    ```bash
    python run.py -r
    ```
3.  **Collect Performance Metrics:**
    ```bash
    python run.py -m
    ```
4.  **(Optional) Inspect in GUI:**
    ```bash
    python run.py -o
    ```
5.  **Clean Up Generated Files:**
    ```bash
    python run.py -c
    ```

### 7. Important Notes

* **Configuration is Key:** Ensure the `QUARTUS_SH_EXE`, `QUARTUS_GUI_EXE`, and `PROJ_NAME` variables are correctly set for your environment *before* running the script.
* **Working Directory:** Always run `run.py` from the root of your repository folder (i.e. `bitty_hackaton/`).
* **Error Handling:** The script has basic print statements but may not have robust error handling. If a Quartus command fails, it might print an error message from Quartus, but the script might continue or exit depending on the `os.system` call behavior. Check the console output carefully.
* **Platform Specificity:** The `-c` (clean) command is Windows-specific. If using Linux/macOS, you would need to modify the `clean_simulation` function to use appropriate commands (e.g., `rm -rf tmp result.txt`).

---