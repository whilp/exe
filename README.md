# exe

Portable executables built with [Cosmopolitan Libc](https://github.com/jart/cosmopolitan).

## About

This repository builds Actually Portable Executables (APE) using [cosmocc](https://github.com/jart/cosmopolitan) and [superconfigure](https://github.com/jart/cosmopolitan/blob/master/tool/scripts/superconfigure). Built binaries are placed in `./bin/`.

## Current Builds

- **Lua** - The Lua programming language interpreter (lua.com)

## Building

GitHub Actions automatically builds executables on push. See `.github/workflows/` for build configurations.

To build locally:
1. Download cosmocc and superconfigure
2. Run the build workflow steps manually

## Usage

Cosmopolitan binaries (`.com` files) can run on:
- Linux (x86_64, aarch64)
- MacOS (x86_64, aarch64)
- Windows (x86_64)
- FreeBSD (x86_64)
- OpenBSD (x86_64)
- NetBSD (x86_64)

Simply download and execute: `./lua.com`