# Spring Boot Project Documentation Generator

This folder contains a PowerShell script that generates a single Markdown file from the contents of a Spring Boot project.

It is useful when you want to archive, review, or analyze a project in a single document without manually copying file contents one by one.

## Script

- [DocumentarProyecto.ps1](DocumentarProyecto.ps1)

## What the script does

The script:

- validates that the target project path exists
- scans the project recursively
- includes common source and configuration file extensions
- excludes folders such as build artifacts, hidden folders, and dependency directories
- writes a Markdown file containing each file's content inside a fenced code block
- preserves the relative path of each file in the generated document

## Supported file extensions

By default the script includes these file types:

- .java
- .xml
- .properties
- .yml
- .yaml
- .sql
- .json

## Parameters

### RutaProyecto
Required. Path to the project directory to document.

### ArchivoSalida
Optional. Name of the output Markdown file. Default: `documentacion.md`

### ExtensionesIncluir
Optional. Array of file extensions to include. Default:

```powershell
@("*.java", "*.xml", "*.properties", "*.yml", "*.yaml", "*.sql", "*.json")
```

### DirectoriosExcluir
Optional. List of directories to ignore during scanning. Default includes:

```powershell
@(".idea", ".git", ".vscode", "target", "node_modules", ".gradle", "build", ".m2")
```

## Usage examples

The examples below intentionally use a sample test path under `$HOME` instead of a personal machine path.

### Example 1: Basic generation

```powershell
powershell -ExecutionPolicy Bypass -File "$HOME\tools\scripts\DocumentarProyecto.ps1" `
  -RutaProyecto "$HOME\repos\demo\spring-boot-project" `
  -ArchivoSalida "spring-boot-project_code.md"
```

### Example 2: Using a custom output file and default extension list

```powershell
powershell -ExecutionPolicy Bypass -File "$HOME\tools\scripts\DocumentarProyecto.ps1" `
  -RutaProyecto "$HOME\repos\demo\orders-api" `
  -ArchivoSalida "orders-api_documentation.md"
```

### Example 3: Running from a test environment

```powershell
$HOME = "C:\Users\TestUser"
powershell -ExecutionPolicy Bypass -File "$HOME\tools\scripts\DocumentarProyecto.ps1" `
  -RutaProyecto "$HOME\repos\demo\payment-service" `
  -ArchivoSalida "payment-service_code.md"
```

> Note: These examples use a test-style home path to illustrate the expected command format without referencing a real machine path.

## Output format

The generated Markdown file contains:

- a title and generation date
- the project path
- one section per file
- a fenced code block with the original content
- a separator between files

Example structure:

```md
# Project Documentation

**Generated:** 01/10/2026 10:00:00
**Project path:** C:\path\to\project

## src/main/java/com/example/Application.java

```java
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

## Notes

- The script is designed for quick documentation and archival tasks.
- It is especially useful for reviewing a project in a single Markdown document.
- You can adjust the excluded directories or included file extensions to match your project layout.

## Typical use cases

- project review before handoff
- code archaeology or onboarding
- documenting legacy or small Spring Boot services
- exporting project contents to a single file for AI-assisted analysis
