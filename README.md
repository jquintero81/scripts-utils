# Scripts Utilities Repository

This repository is a personal collection of small utilities and automation scripts to simplify common development tasks.

At the moment, it includes tools focused on project documentation and code extraction, but the repository is intended to grow with additional utilities over time.

## Current contents

- [java-project-to-md/README.md](java-project-to-md/README.md) – Extracts the contents of a Spring Boot project into a single Markdown document.
- [java-project-to-md/DocumentarProyecto.ps1](java-project-to-md/DocumentarProyecto.ps1) – PowerShell script that recursively documents a project and writes the result to a Markdown file.

## Repository purpose

This repo is meant to serve as a place where reusable scripts, helper tooling, and small operational utilities can live together in a single, easy-to-discover workspace.

The goal is to keep scripts:

- practical and focused
- easy to reuse across projects
- documented clearly for future maintenance
- simple to extend as new needs appear

## Planned additions

Future utilities may include:

- CI/CD helpers
- environment validation scripts
- code inspection and reporting tools
- project scaffolding utilities
- file or configuration automation helpers

## Example usage

To run the current documentation utility from the repository root, use a path similar to the following examples:

```powershell
$HOME\repos\demo\spring-boot-app
```

The scripts and utilities in this repository are designed to be adapted easily to your local environment, using your own project paths and output filenames.

## Notes

This repository is intentionally lightweight and practical. It is designed for quick script-based automation without adding framework overhead or complex project structures.
