#!/usr/bin/env bash
# init-csharp — scaffolds a .NET project with src/tests/docs structure
# Usage: init-csharp <ProjectName> [console|webapi|classlib]
# Version: 1.0.0

set -e

VERSION="1.0.0"

# --- Argument Validation ---

if [ -z "$1" ]; then
  echo "Usage: init-csharp.sh <ProjectName> [console|webapi|classlib]"
  exit 1
fi

if [ "$1" = "--version" ]; then
  echo "init-csharp version $VERSION"
  exit 0
fi

# --- Configuration ---

PROJECT_NAME="$1"
PROJECT_TYPE="${2:-console}"
PROJECTS_DIR="${PROJECTS_DIR:-$HOME/projects/csharp}"
PROJECT_PATH="$PROJECTS_DIR/$PROJECT_NAME"
PLATFORM="$(uname -s)"

mkdir -p "$PROJECTS_DIR"

echo "Platform: $PLATFORM"
echo "Project directory: $PROJECTS_DIR"

# --- Idempotency Check ---

if [ -d "$PROJECT_PATH" ]; then
  echo "Error: Project '$PROJECT_NAME' already exists at $PROJECT_PATH"
  exit 2
fi

# --- Directory Setup ---

echo "Initializing  project: $PROJECT_NAME"
echo "Location: $PROJECT_PATH"

mkdir -p "$PROJECT_PATH/src"
mkdir -p "$PROJECT_PATH/tests"
mkdir -p "$PROJECT_PATH/docs"
mkdir -p "$PROJECT_PATH/scripts"

# --- Scaffold .NET Project ---

echo "Scaffolding .NET solution and projects..."
echo "Project type: $PROJECT_TYPE"

dotnet new sln -n "$PROJECT_NAME" -o "$PROJECT_PATH"

case "$PROJECT_TYPE" in
console)
  dotnet new console -n "$PROJECT_NAME" \
    -o "$PROJECT_PATH/src/$PROJECT_NAME"
  ;;
webapi)
  dotnet new webapi -n "$PROJECT_NAME" \
    -o "$PROJECT_PATH/src/$PROJECT_NAME"
  ;;
classlib)
  dotnet new classlib -n "$PROJECT_NAME" \
    -o "$PROJECT_PATH/src/$PROJECT_NAME"
  ;;
*)
  echo "Error: Unknown project type '$PROJECT_TYPE'"
  echo "Valid types: console, webapi, classlib"
  exit 3
  ;;
esac

dotnet new xunit -n "$PROJECT_NAME.Tests" \
  -o "$PROJECT_PATH/tests/$PROJECT_NAME"

dotnet sln "$PROJECT_PATH/$PROJECT_NAME.slnx" \
  add "$PROJECT_PATH/src/$PROJECT_NAME"

dotnet sln "$PROJECT_PATH/$PROJECT_NAME.slnx" \
  add "$PROJECT_PATH/tests/$PROJECT_NAME"

# --- Generate Standard Docs ---

cat >"$PROJECT_PATH/.gitignore" <<EOF
bin/
obj/
*.user
.vs/
*.sln
*.slnx
EOF

cat >"$PROJECT_PATH/docs/README.md" <<EOF
# $PROJECT_NAME

Project description goes here.

## Getting Started

Run dotnet build to build the project.
Run dotnet test to run the test suite.
EOF

# --- Build Sample Deployment Script ---

cat >"$PROJECT_PATH/scripts/build.sh" <<EOF
#!/bin/bash
set -e

# Build steps:

dotnet build "$PROJECT_PATH/$PROJECT_NAME.slnx"
EOF

# --- Set File Permissions ---

chmod 744 "$PROJECT_PATH/scripts/build.sh"
chmod 644 "$PROJECT_PATH/.gitignore"
chmod 644 "$PROJECT_PATH/docs/README.md"

# --- Create Log Entry ---

LOG_FILE="$PROJECTS_DIR/init.log"

if [ ! -f "$LOG_FILE" ]; then
  touch "$LOG_FILE"
  chmod 644 "$LOG_FILE"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Initialized: $PROJECT_NAME \
  type=$PROJECT_TYPE path=$PROJECT_PATH" >>"$LOG_FILE"

# --- Print Success Confirmation ---

echo ""
echo "========================================"
echo " Project initialized successfully"
echo "========================================"
echo " Name:  $PROJECT_NAME"
echo " Type:  $PROJECT_TYPE"
echo " Path:  $PROJECT_PATH"
echo " Log:   $LOG_FILE"
echo "========================================"
echo ""
