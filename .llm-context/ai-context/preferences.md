# AI Assistant Preferences and Guidelines

## Code Generation Preferences

### Language and Framework Preferences
- **Primary Language**: Dart for Flutter development
- **Architecture Pattern**: MVVM with Clean Architecture (Domain/Data/Presentation layers)
- **State Management**: ValueNotifier with custom base classes
- **Async Programming**: Dart Future/Stream with async/await
- **UI Framework**: Flutter Widgets with custom base classes

### Code Style Preferences
- **Naming Convention**: camelCase for variables/functions, PascalCase for classes
- **File Organization**: Modular approach with separate data/domain/presentation layers
- **Comment Style**: Focus on "why" rather than "what"
- **Error Handling**: Use Result pattern with sealed classes
- **Null Safety**: Leverage Dart's null safety features

### Testing Preferences
- **Unit Testing**: Flutter test framework with mockito for mocking
- **Widget Testing**: Flutter widget tests for UI components
- **Integration Testing**: Flutter integration tests for end-to-end flows
- **Test Structure**: Given-When-Then pattern
- **Coverage Target**: Minimum 80% code coverage

## Communication Preferences

### Response Style
- **Conciseness**: Provide direct, actionable responses
- **Code Examples**: Include practical code snippets when relevant
- **Explanations**: Focus on implementation details and reasoning
- **Alternatives**: Suggest multiple approaches when applicable

### Documentation Style
- **Structure**: Use clear headings and bullet points
- **Code Comments**: Inline documentation for complex logic
- **README Updates**: Keep documentation current with changes
- **API Documentation**: Document public interfaces thoroughly

## Development Workflow Preferences

### Git Workflow
- **Commit Messages**: Use conventional commit format (feat:, fix:, docs:, etc.)
- **Branch Naming**: feature/description, bugfix/description, hotfix/description
- **PR Reviews**: Comprehensive code review using established guidelines
- **Merge Strategy**: Squash and merge for feature branches

### Build and Deployment
- **Environment Management**: Flutter flavors for dev/test/staging/prod
- **Dependency Management**: Pin specific versions in pubspec.yaml
- **Build Optimization**: Minimize app size, optimize build times
- **CI/CD**: Automated testing and deployment pipelines for multiple platforms

## Problem-Solving Approach

### Debugging Strategy
1. **Reproduce Issue**: Understand the exact problem scenario
2. **Isolate Cause**: Use systematic elimination approach
3. **Root Cause Analysis**: Address underlying issues, not just symptoms
4. **Test Solution**: Verify fix doesn't introduce new issues
5. **Document Solution**: Add to troubleshooting knowledge base

### Performance Optimization
- **Measure First**: Use profiling tools before optimizing
- **Focus Areas**: Memory usage, network efficiency, UI responsiveness
- **Incremental Improvements**: Small, measurable optimizations
- **Monitor Impact**: Track performance metrics after changes

## Security and Privacy Guidelines

### Data Handling
- **Sensitive Data**: Never log or expose sensitive information
- **Encryption**: Use platform-provided secure storage
- **API Keys**: Store in secure configuration, never hardcode
- **User Privacy**: Minimal data collection, transparent usage

### Code Security
- **Input Validation**: Validate all user inputs and API responses
- **SQL Injection**: Use parameterized queries with Room
- **Network Security**: HTTPS only, certificate pinning where appropriate
- **Authentication**: Secure token storage and refresh mechanisms

## Learning and Adaptation

### Knowledge Updates
- **Technology Changes**: Stay current with Android/Kotlin updates
- **Best Practices**: Evolve practices based on team feedback
- **Performance Insights**: Learn from production metrics
- **User Feedback**: Incorporate user experience improvements

### Continuous Improvement
- **Code Reviews**: Learn from team feedback and suggestions
- **Refactoring**: Regular code cleanup and modernization
- **Tool Updates**: Adopt new development tools when beneficial
- **Pattern Recognition**: Identify and reuse successful patterns

## Team Collaboration

### Code Review Participation
- **Constructive Feedback**: Focus on improvement, not criticism
- **Knowledge Sharing**: Explain reasoning behind suggestions
- **Standards Enforcement**: Maintain consistent code quality
- **Learning Opportunities**: Use reviews for team education

### Documentation Contributions
- **Context Updates**: Keep LLM context current and accurate
- **Decision Recording**: Document important technical decisions
- **Pattern Documentation**: Share reusable solutions and patterns
- **Onboarding Support**: Improve new team member experience

## Error Handling and Recovery

### Exception Management
- **Graceful Degradation**: App continues functioning when possible
- **User Communication**: Clear, actionable error messages
- **Logging Strategy**: Comprehensive logging for debugging
- **Crash Recovery**: Automatic recovery from non-fatal errors

### Fallback Strategies
- **Network Issues**: Offline functionality and retry mechanisms
- **Service Unavailability**: Alternative service providers
- **Data Corruption**: Data validation and recovery procedures
- **Performance Issues**: Graceful performance degradation

## Open Issues Management

### Issue Tracking Preferences
- **Documentation**: Always document open issues in `.llm-context/project/open-issues.md`
- **Categorization**: Classify issues by priority (P0-P3) and category (crash, performance, UI/UX, etc.)
- **Status Tracking**: Maintain current status and progress updates for all open issues
- **Resolution Tracking**: Update issue status and maintain implementation timeline

### Issue Analysis Approach
- **Root Cause Focus**: Always identify and address root causes, not just symptoms
- **Pattern Recognition**: Look for recurring issues and common themes
- **Impact Assessment**: Evaluate user impact and business consequences
- **Prevention Planning**: Implement measures to prevent similar issues

### Project Communication
- **Transparency**: Keep stakeholders informed of progress and timelines
- **Clarity**: Use clear, technical language appropriate for development team
- **Documentation**: Maintain detailed technical analysis and solution approaches
- **Follow-up**: Verify implementation and test results after fixes

### Knowledge Management
- **Issue Database**: Maintain comprehensive records of all open issues
- **Solution Library**: Build reusable solutions for common problems
- **Team Learning**: Share insights and lessons learned across the team
- **Continuous Improvement**: Use issue analysis to drive project improvements

## Quality Assurance

### Code Quality Metrics
- **Complexity**: Keep cyclomatic complexity under 10
- **Duplication**: Minimize code duplication through abstraction
- **Maintainability**: Write self-documenting, readable code
- **Testability**: Design for easy unit and integration testing

### Review Criteria
- **Functionality**: Code works as intended
- **Performance**: No performance regressions
- **Security**: No security vulnerabilities introduced
- **Maintainability**: Code is easy to understand and modify
