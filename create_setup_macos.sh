#!/bin/bash

# mkdemir
# Version: 1.0.0

# Usage: bash create_setup_macos.sh -PythonVersion "3.11.3" -EnvName "venv" -RequirementsFile "./requirements.txt"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -PythonVersion)
            PythonVersion=$2
            shift 2
            ;;
        -EnvName)
            EnvName=$2
            shift 2
            ;;
        -RequirementsFile)
            RequirementsFile=$2
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

pythonVersionOutput=$(python --version 2>&1)
echo "- Current Python version: $pythonVersionOutput"

echo "- Creating virtual environment with Python $PythonVersion..."

# Set the virtual environment path
envPath=$(realpath $EnvName)

# Check if the virtual environment already exists
if [ -d "$envPath" ]; then
    echo "Virtual environment '$EnvName' already exists. Activating it..."
else
    # Create a new virtual environment
    python3 -m venv $envPath
    echo "Virtual environment '$EnvName' created."
fi

# Activate the virtual environment
activateScript="$envPath/bin/activate"
echo "Activating virtual environment: $activateScript"
source $activateScript

# Upgrade pip
pythonPath="$envPath/bin/python"
echo "Upgrading pip..."
$pythonPath -m pip install --upgrade pip

# Install required packages
if [ -f "$RequirementsFile" ]; then
    echo "Installing required packages..."
    $pythonPath -m pip install -r $RequirementsFile
else
    echo "Could not find requirements file '$RequirementsFile'."
    exit 1
fi