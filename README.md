# Pipex-Tests

A simple test suite for the Pipex project.

## Overview

This repository provides a set of automated tests to help you validate your Pipex implementation. The test suite uses a `test_case.txt` file where each line defines a test case. The script `test_pipex.sh` reads each test case, generates the necessary input and shell script files, and then runs the test.

## Prerequisites

- **Pipex executable:** You must have compiled your Pipex project.
- **Git:** To clone the repository.
- **Valgrind:** For memory leak detection.
- **Unix-like environment:** The scripts are designed to run on Unix-based systems.

## Setup Instructions

1. **Clone the Repository:**

   ```bash
   git clone git@github.com:AzzaouiAlae/Pipex-Tests.git Pipex_Tests
   ```

2. **Navigate to the Project Directory:**

   ```bash
   cd Pipex_Tests
   ```

3. **Set Execute Permissions for the Scripts:**

   ```bash
   chmod +x *
   ```

4. **Copy Your Pipex Executable:**

   Replace `~/your/path/pipex` with the actual path to your compiled Pipex executable:
   
   ```bash
   cp ~/your/path/pipex .
   ```

5. **Run the Tests:**

   ```bash
   ./test_pipex.sh
   ```

## How It Works

- The `test_pipex.sh` script reads each line from the `test_case.txt` file and creates a test based on that line.
- Each test case line has the following format:

  ```
  [input file content separated by \n]|||[command 1]|||[command 2]
  ```

### Example Test Case

Consider the following test case line in `test_case.txt`:

```
check_input_output_files.c\nexec_cmd2.c\nexec_cmd.c\n|||grep a|||grep d
```

This test case creates two files:

#### 1. `input_file`
The file contains:
```bash
check_input_output_files.c
exec_cmd2.c
exec_cmd.c
```

#### 2. `test.sh`
The generated shell script looks like this:
```bash
#!/bin/bash
valgrind --leak-check=full --show-leak-kinds=all --errors-for-leak-kinds=all --quiet ./pipex input_file "grep a" "grep d" pipex_output 2>> pipex_output
echo $? >> pipex_output
< input_file grep a | grep d > cmd_output 2>> cmd_output
echo $? >> cmd_output
```

After generating these files, the script executes `test.sh` to run the test and compare the output of your Pipex executable against the expected behavior.

## Adding More Tests

To add new test cases:
- Append new lines to `test_case.txt` using the format:
  ```
  [input file content separated by \n]|||[command 1]|||[command 2]
  ```
- You can add as many test cases as needed.
