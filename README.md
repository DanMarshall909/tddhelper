# TddHelper - Rider Plugin for Test-Driven Development

TddHelper is a JetBrains Rider plugin designed to enhance Test-Driven Development workflows. This repository contains the memory bank for the TddHelper plugin, which outlines the architecture, features, implementation details, and development roadmap.

## Memory Bank Contents

The memory bank contains the following documents:

- [Architecture](memory-bank/architecture.md) - Overall plugin architecture and component interactions
- [Features](memory-bank/features.md) - Detailed feature specifications
- [Implementation Notes](memory-bank/implementation-notes.md) - Technical implementation details
- [Development Roadmap](memory-bank/development-roadmap.md) - Phased development approach
- [Extension Points](memory-bank/extension-points.md) - Future extension mechanisms

## Plugin Overview

<!-- Plugin description -->
TddHelper enhances JetBrains Rider with tools that support Test-Driven Development.
<!-- Plugin description end -->

TddHelper enhances Test-Driven Development workflows in Rider with:

1. **Visual Feedback on Test Status**
   - Red title bar/border when tests fail
   - Failed test names displayed in the title bar
   - Clear indication of test status at a glance

2. **Quick Navigation to Failed Tests**
   - Keyboard shortcut to navigate to failed tests
   - Cycle through all failed tests
   - Immediate access to problematic code

3. **Automatic Test Execution**
   - Run tests automatically after idle period
   - Configurable idle threshold
   - Seamless integration into TDD workflow

4. **Extensible Architecture**
   - Interface-based design
   - Service-oriented architecture
   - Event-based communication
   - Formal extension points

## Development Phases

The plugin will be developed in four phases:

1. **Phase 1: Core Framework and Initial Features**
   - Red title bar for failed tests
   - Failed test navigation

2. **Phase 2: Enhanced Visualization**
   - Failed test names in title bar
   - Configurable display options

3. **Phase 3: Auto-Test Runner**
   - Idle time detection
   - Automatic test execution
   - Configuration options

4. **Phase 4: Extensibility and Polish**
   - Formalized extension points
   - Comprehensive settings
   - Performance optimization
   - Documentation and examples

## Getting Started

To contribute to the TddHelper plugin:

1. Clone this repository
2. Run the setup script to create the project structure. Choose the script for
   your environment:
   - **Unix/macOS (bash)**: `./setup-all.sh`
   - **Windows (cmd)**: `setup-all.bat`
   - **PowerShell**: `./setup-all.ps1`
3. Review the memory bank documents to understand the architecture and features
4. Update `gradle.properties` if you need to change the plugin group, version, or target IDE
5. Open the project in IntelliJ IDEA
6. Build the plugin with:
   ```
   ./gradlew buildPlugin
   ```
7. Run the plugin in a development instance with:
   ```
   ./gradlew runIde
   ```

For more detailed instructions, see [CONTRIBUTING.md](CONTRIBUTING.md).

## License

This project is licensed under the MIT License - see the LICENSE file for details.
