#!/bin/bash

# Function to check if the virtual environment is activated
is_venv_active() {
    if [ -z "$VIRTUAL_ENV" ]; then
        echo "Virtual environment is not active. Please activate it first."
        exit 1
    fi
}

# Function to display help/usage information
show_help() {
    echo "Usage: $0 {gvenv|install|help}"
    echo ""
    echo "Options:"
    echo "  gvenv    Create and activate a virtual environment in the home directory"
    echo "  install  Install the package in the current directory"
    echo "  help     Display this help message"
}

# Main script logic
case "$1" in
    gvenv)
        python3 -m venv ~/gvenv
        source ~/gvenv/bin/activate
        ;;
    install)
        is_venv_active
        pip3 install .
        ;;
    "?"|"-h"|"--help"|"help")
        show_help
        ;;
    *)
        echo "Invalid option: $1"
        show_help
        exit 1
        ;;
esac