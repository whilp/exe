#!/bin/bash
set -euo pipefail

echo "=== Starting Lua build with cosmopolitan ==="
echo "Date: $(date)"
echo "PWD: $PWD"
echo "cosmocc location: $(which cosmocc || echo 'not in PATH')"
echo ""

# Download and setup cosmocc if not already available
if ! command -v cosmocc &> /dev/null; then
    echo "=== Downloading and setting up cosmocc ==="
    wget -q https://cosmo.zip/pub/cosmocc/cosmocc.zip
    unzip -qo cosmocc.zip
    export PATH="$PWD/cosmocc/bin:$PATH"
    echo "cosmocc installed to: $PWD/cosmocc/bin"
fi

# Download superconfigure if not present
if [ ! -f superconfigure ]; then
    echo "=== Downloading superconfigure ==="
    wget -q https://cosmo.zip/pub/cosmos/superconfigure
    chmod +x superconfigure
fi

# Download Lua source if not present
if [ ! -d lua-5.4.7 ]; then
    echo "=== Downloading Lua 5.4.7 source ==="
    wget -q https://www.lua.org/ftp/lua-5.4.7.tar.gz
    tar xzf lua-5.4.7.tar.gz
fi

# Build Lua
echo "=== Running superconfigure ==="
cd lua-5.4.7
../superconfigure

echo "=== Building with cosmocc ==="
make CC=cosmocc

echo "=== Build complete ==="
cd ..

# Copy executable to bin
echo "=== Copying executable to bin ==="
mkdir -p bin

# Find and copy the lua executable
lua_exe=$(find lua-5.4.7 -name "lua" -type f -executable | head -1)
if [ -n "$lua_exe" ]; then
    cp "$lua_exe" bin/lua.com
    echo "Successfully created bin/lua.com"

    # Show file info
    ls -lh bin/lua.com
    file bin/lua.com || true
else
    echo "ERROR: lua executable not found"
    exit 1
fi

echo ""
echo "=== Build completed successfully ==="
