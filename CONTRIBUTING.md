# Contributing to TddHelper

This document provides guidelines and instructions for contributing to the TddHelper Rider plugin.

## Development Environment Setup

### Prerequisites

- JDK 17 or later
- IntelliJ IDEA with Gradle support
- JetBrains Rider (for testing)

### Setting Up the Project

1. Clone the repository:
   ```
   git clone https://github.com/danmarshall/tddhelper.git
   cd tddhelper
   ```

2. Open the project in IntelliJ IDEA:
   - Select "Open" from the welcome screen
   - Navigate to the cloned repository
   - Select the `build.gradle.kts` file and click "Open as Project"

3. Wait for the Gradle sync to complete

### Building the Plugin

To build the plugin, run:

```
./gradlew buildPlugin
```

This will create a plugin distribution in `build/distributions/tddhelper-[version].zip`.

### Running the Plugin in a Development Instance

To run the plugin in a development instance of Rider:

```
./gradlew runIde
```

This will start a new instance of Rider with the plugin installed.

## Project Structure

- `src/main/kotlin/com/danmarshall/tddhelper/` - Plugin source code
  - `actions/` - Actions (e.g., navigation to failed tests)
  - `services/` - Services (e.g., test results tracking)
  - `listeners/` - Event listeners
  - `util/` - Utility classes
- `src/main/resources/` - Plugin resources
  - `META-INF/plugin.xml` - Plugin configuration
- `src/test/kotlin/` - Test code

## Development Workflow

1. Create a new branch for your feature or bug fix
2. Implement your changes following the TDD approach:
   - Write failing tests first
   - Implement the minimum code to make tests pass
   - Refactor while keeping tests green
3. Ensure all tests pass with `./gradlew test`
4. Submit a pull request

## Coding Guidelines

- Follow Kotlin coding conventions
- Write unit tests for all new code
- Keep methods small and focused
- Use meaningful names for classes, methods, and variables
- Add comments for complex logic, but prefer self-documenting code

## Testing

Run tests with:

```
./gradlew test
```

## Debugging

When running the plugin with `runIde`, you can debug it by attaching a debugger to the development instance.

## Documentation

- Update documentation when adding or changing features
- Document public APIs with KDoc comments
- Keep the memory bank up-to-date with architectural decisions

## Release Process

1. Update version in `build.gradle.kts`
2. Update changelog
3. Build the plugin: `./gradlew buildPlugin`
4. Test the distribution
5. Sign the plugin: `./gradlew signPlugin`
6. Publish the plugin: `./gradlew publishPlugin`

## Getting Help

If you have questions or need help, please:
- Check the existing documentation
- Look for similar issues in the issue tracker
- Create a new issue if needed

Thank you for contributing to TddHelper!
