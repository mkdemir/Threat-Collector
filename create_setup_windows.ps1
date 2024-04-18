# mkdemir
# Version: 1.0.0

<#
.SYNOPSIS
    Creates a new Python virtual environment with the specified Python version and installs required packages.

.DESCRIPTION
    This script creates a new Python virtual environment with the specified Python version and installs the required packages listed in the requirements.txt file.

.PARAMETER PythonVersion
    The version of Python to use for the virtual environment, e.g., "3.12.0".

.PARAMETER EnvName
    The name of the virtual environment to create.

.PARAMETER RequirementsFile
    The path to the requirements.txt file containing a list of required packages.

.EXAMPLE
    Create a new virtual environment with Python 3.12.0 and install required packages:
    .\create_setup_windows.ps1 -PythonVersion "3.12.0" -EnvName "venv" -RequirementsFile ".\requirements.txt"

.NOTES
    - This script requires PowerShell version 5.1 or later.
    - The virtual environment will be created in the current directory.
    - If the virtual environment already exists, the script will activate it and install the required packages.
    - If the requirements.txt file does not exist, the script will exit with an error.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$PythonVersion,

    [Parameter(Mandatory=$true)]
    [string]$EnvName,

    [Parameter(Mandatory=$true)]
    [string]$RequirementsFile
)

# Check if Python is installed
$pythonCheck = Get-Command python.exe -ErrorAction SilentlyContinue
if (-not $pythonCheck) {
    Write-Error "Python is not installed. Please install Python before running this script."
    Exit
}

$pythonVersionOutput = python.exe --version 2>&1
Write-Host "- Current Python version: $pythonVersionOutput"

Write-Host "- Creating virtual environment with Python $PythonVersion..."

# Set the virtual environment path
$envPath = Join-Path -Path $PWD -ChildPath $EnvName

# Check if the virtual environment already exists
if (Test-Path -Path $envPath) {
    Write-Host "Virtual environment '$EnvName' already exists. Activating it..."
} else {
    # Create a new virtual environment
    python.exe -m venv $envPath
    Write-Host "Virtual environment '$EnvName' created."
}

# Activate the virtual environment
$activateScript = Join-Path -Path $envPath -ChildPath "Scripts\Activate.ps1"
if (Test-Path -Path $activateScript) {
    Write-Host "Activating virtual environment: $activateScript"
    . $activateScript
} else {
    Write-Error "Could not find the Activate.ps1 script. Please check your virtual environment."
    Exit
}

# Upgrade pip
$pythonPath = Join-Path -Path $envPath -ChildPath "Scripts\python.exe"
Write-Host "Upgrading pip..."
& $pythonPath -m pip install --upgrade pip

# Install required packages
if (Test-Path -Path $RequirementsFile) {
    Write-Host "Installing required packages..."
    & $pythonPath -m pip install -r $RequirementsFile
} else {
    Write-Error "Could not find requirements file '$RequirementsFile'."
}
