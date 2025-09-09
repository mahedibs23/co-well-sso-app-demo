# Mobile Project Code Review Guidelines

## Overview
This document provides comprehensive guidelines for conducting thorough code reviews of mobile applications across all platforms (Android, iOS, React Native, Flutter, etc.). It serves as a self-contained reference for developers and automated systems to ensure code quality, maintainability, and best practices.

## Table of Contents
1. [Code Review Process](#code-review-process)
2. [Architecture & Design Patterns](#architecture--design-patterns)
3. [Code Quality & Standards](#code-quality--standards)
4. [Performance & Optimization](#performance--optimization)
5. [Security & Privacy](#security--privacy)
6. [User Experience & Accessibility](#user-experience--accessibility)
7. [Testing & Quality Assurance](#testing--quality-assurance)
8. [Dependencies & Third-Party Libraries](#dependencies--third-party-libraries)
9. [Platform-Specific Guidelines](#platform-specific-guidelines)
10. [Documentation & Comments](#documentation--comments)
11. [Build & Deployment](#build--deployment)
12. [Project Maintainability Assessment](#project-maintainability-assessment)
13. [Technical Debt Evaluation](#technical-debt-evaluation)
14. [Scoring Framework](#scoring-framework)
15. [Code Review Checklist](#code-review-checklist)
16. [Reporting Template](#reporting-template)

---

## Code Review Process

### Pre-Review Setup
- [ ] Verify branch is up-to-date with main/master
- [ ] Ensure all automated tests pass
- [ ] Check build succeeds on all target platforms/configurations
- [ ] Validate commit messages follow conventional commit standards
- [ ] Confirm PR/MR description clearly explains changes

### Review Scope
- [ ] **Functional Changes**: New features, bug fixes, modifications
- [ ] **Non-Functional Changes**: Performance improvements, refactoring
- [ ] **Configuration Changes**: Build scripts, dependencies, environment configs
- [ ] **Documentation Updates**: README, API docs, inline comments

---

## Architecture & Design Patterns

### 1. Architectural Consistency
- [ ] **Pattern Adherence**: Follows established architecture (MVVM, MVP, MVI, Clean Architecture)
- [ ] **Separation of Concerns**: Clear boundaries between UI, business logic, and data layers
- [ ] **Dependency Direction**: Dependencies flow inward (UI → Business Logic → Data)
- [ ] **Single Responsibility**: Each class/module has one clear purpose

### 2. Design Patterns Implementation
- [ ] **Repository Pattern**: Data access abstraction properly implemented
- [ ] **Observer Pattern**: Event handling and state management
- [ ] **Factory/Builder Patterns**: Object creation complexity managed
- [ ] **Dependency Injection**: Proper DI container usage and lifecycle management

### 3. Code Organization
- [ ] **Package Structure**: Logical grouping by feature or layer
- [ ] **File Naming**: Consistent and descriptive naming conventions
- [ ] **Class Hierarchy**: Appropriate inheritance and composition usage
- [ ] **Interface Segregation**: Interfaces are focused and cohesive

---

## Code Quality & Standards

### 1. Code Style & Formatting
- [ ] **Consistent Formatting**: Follows project's style guide (ktlint, SwiftLint, ESLint)
- [ ] **Naming Conventions**: Variables, functions, classes follow platform standards
- [ ] **Indentation**: Consistent spacing and bracket placement
- [ ] **Line Length**: Adheres to maximum line length limits

### 2. Code Complexity
- [ ] **Cyclomatic Complexity**: Functions have reasonable complexity (< 10)
- [ ] **Method Length**: Functions are concise and focused (< 50 lines)
- [ ] **Class Size**: Classes are not overly large (< 500 lines)
- [ ] **Nesting Depth**: Avoid deep nesting (< 4 levels)

### 3. Error Handling
- [ ] **Exception Handling**: Proper try-catch blocks with specific exceptions
- [ ] **Error Propagation**: Errors bubble up appropriately through layers
- [ ] **User-Friendly Messages**: Error messages are meaningful to users
- [ ] **Logging**: Appropriate logging levels and information

### 4. Memory Management
- [ ] **Resource Cleanup**: Proper disposal of resources (streams, connections)
- [ ] **Memory Leaks**: No strong reference cycles or retained objects
- [ ] **Lifecycle Awareness**: Components respect platform lifecycle
- [ ] **Weak References**: Appropriate use of weak references for delegates/callbacks

---

## Performance & Optimization

### 1. Runtime Performance
- [ ] **Algorithm Efficiency**: Optimal time and space complexity
- [ ] **Database Queries**: Efficient queries with proper indexing
- [ ] **Network Calls**: Minimized and batched where possible
- [ ] **Caching Strategy**: Appropriate caching implementation

### 2. UI Performance
- [ ] **Smooth Animations**: 60fps target for animations and transitions
- [ ] **List Performance**: Efficient list rendering with recycling
- [ ] **Image Loading**: Lazy loading and proper image optimization
- [ ] **Layout Complexity**: Avoid deep view hierarchies

### 3. Background Processing
- [ ] **Threading**: Proper use of background threads for heavy operations
- [ ] **Async Operations**: Non-blocking UI with async/await patterns
- [ ] **Task Scheduling**: Appropriate use of schedulers and queues
- [ ] **Battery Optimization**: Efficient background task management

### 4. Resource Usage
- [ ] **Bundle Size**: Minimized app size through code splitting
- [ ] **Asset Optimization**: Compressed images and resources
- [ ] **Dead Code**: Removal of unused code and dependencies
- [ ] **Proguard/R8**: Proper code obfuscation and shrinking

---

## Security & Privacy

### 1. Data Protection
- [ ] **Sensitive Data**: No hardcoded secrets, keys, or passwords
- [ ] **Data Encryption**: Sensitive data encrypted at rest and in transit
- [ ] **Secure Storage**: Use of platform secure storage (Keychain, Keystore)
- [ ] **Data Validation**: Input validation and sanitization

### 2. Network Security
- [ ] **HTTPS Only**: All network communications use HTTPS
- [ ] **Certificate Pinning**: Implementation where appropriate
- [ ] **API Security**: Proper authentication and authorization
- [ ] **Request Signing**: Secure API request signing where needed

### 3. Authentication & Authorization
- [ ] **Token Management**: Secure token storage and refresh logic
- [ ] **Session Management**: Proper session timeout and cleanup
- [ ] **Biometric Auth**: Secure implementation of biometric authentication
- [ ] **Permission Handling**: Minimal and justified permission requests

### 4. Privacy Compliance
- [ ] **Data Collection**: Transparent data collection practices
- [ ] **User Consent**: Proper consent mechanisms for data usage
- [ ] **Data Retention**: Appropriate data retention policies
- [ ] **Third-Party SDKs**: Privacy-compliant third-party integrations

---

## User Experience & Accessibility

### 1. User Interface
- [ ] **Design Consistency**: Follows platform design guidelines
- [ ] **Responsive Design**: Adapts to different screen sizes and orientations
- [ ] **Loading States**: Appropriate loading indicators and skeleton screens
- [ ] **Error States**: Clear error messages and recovery options

### 2. Accessibility
- [ ] **Screen Reader Support**: Proper accessibility labels and hints
- [ ] **Keyboard Navigation**: Full keyboard navigation support
- [ ] **Color Contrast**: Meets WCAG color contrast requirements
- [ ] **Font Scaling**: Supports dynamic font sizing

### 3. Internationalization
- [ ] **Localization**: Proper string externalization and localization
- [ ] **RTL Support**: Right-to-left language support where applicable
- [ ] **Cultural Considerations**: Culturally appropriate UI elements
- [ ] **Date/Time Formatting**: Locale-appropriate formatting

### 4. Offline Experience
- [ ] **Offline Functionality**: Core features work offline
- [ ] **Data Synchronization**: Proper sync when connectivity returns
- [ ] **Offline Indicators**: Clear offline state communication
- [ ] **Cached Content**: Intelligent content caching strategy

---

## Testing & Quality Assurance

### 1. Test Coverage
- [ ] **Unit Tests**: Adequate unit test coverage (>80%)
- [ ] **Integration Tests**: Key integration points tested
- [ ] **UI Tests**: Critical user flows automated
- [ ] **Edge Cases**: Boundary conditions and error scenarios tested

### 2. Test Quality
- [ ] **Test Isolation**: Tests are independent and repeatable
- [ ] **Mock Usage**: Appropriate mocking of external dependencies
- [ ] **Test Naming**: Clear and descriptive test names
- [ ] **Assertion Quality**: Specific and meaningful assertions

### 3. Testing Strategies
- [ ] **TDD/BDD**: Test-driven or behavior-driven development practices
- [ ] **Regression Testing**: Existing functionality not broken
- [ ] **Performance Testing**: Performance benchmarks maintained
- [ ] **Security Testing**: Security vulnerabilities tested

---

## Dependencies & Third-Party Libraries

### 1. Dependency Management
- [ ] **Version Pinning**: Dependencies use specific versions
- [ ] **Update Strategy**: Regular dependency updates with testing
- [ ] **Vulnerability Scanning**: Dependencies scanned for security issues
- [ ] **License Compliance**: All dependencies have compatible licenses

### 2. Library Selection
- [ ] **Necessity Justification**: Each dependency serves a clear purpose
- [ ] **Maintenance Status**: Libraries are actively maintained
- [ ] **Performance Impact**: Dependencies don't negatively impact performance
- [ ] **Size Consideration**: Bundle size impact evaluated

### 3. Custom Libraries
- [ ] **Reusability**: Custom components designed for reuse
- [ ] **Documentation**: Well-documented APIs and usage examples
- [ ] **Testing**: Comprehensive testing of custom libraries
- [ ] **Versioning**: Proper semantic versioning for internal libraries

---

## Platform-Specific Guidelines

### Android Specific
- [ ] **Activity/Fragment Lifecycle**: Proper lifecycle management
- [ ] **Memory Leaks**: No context leaks or static references
- [ ] **Background Processing**: Proper use of Services and WorkManager
- [ ] **Permissions**: Runtime permission handling
- [ ] **ProGuard Rules**: Appropriate obfuscation rules
- [ ] **APK Optimization**: Bundle size and startup time optimization

### iOS Specific
- [ ] **ARC Compliance**: Proper memory management with ARC
- [ ] **View Controller Lifecycle**: Proper viewDidLoad, viewWillAppear usage
- [ ] **Delegate Patterns**: Proper delegate and protocol implementation
- [ ] **Core Data**: Efficient Core Data usage and threading
- [ ] **App Store Guidelines**: Compliance with App Store review guidelines
- [ ] **iOS Version Support**: Appropriate iOS version targeting

### React Native Specific
- [ ] **Bridge Usage**: Efficient native bridge communication
- [ ] **State Management**: Proper Redux/Context usage
- [ ] **Component Lifecycle**: Proper useEffect and cleanup
- [ ] **Performance**: FlatList usage for large datasets
- [ ] **Platform Differences**: Handling iOS/Android differences
- [ ] **Metro Bundler**: Efficient bundling and code splitting

### Flutter Specific
- [ ] **Widget Tree**: Efficient widget composition
- [ ] **State Management**: Proper Provider/Bloc/Riverpod usage
- [ ] **Build Context**: Proper BuildContext usage
- [ ] **Platform Channels**: Efficient native communication
- [ ] **Performance**: Proper use of const constructors
- [ ] **Dart Analysis**: Compliance with Dart analysis rules

---

## Documentation & Comments

### 1. Code Documentation
- [ ] **API Documentation**: Public APIs well documented
- [ ] **Complex Logic**: Complex algorithms explained
- [ ] **Business Rules**: Business logic documented
- [ ] **Configuration**: Setup and configuration documented

### 2. Comment Quality
- [ ] **Why Not What**: Comments explain reasoning, not implementation
- [ ] **Up-to-Date**: Comments reflect current code state
- [ ] **Concise**: Comments are clear and concise
- [ ] **No Dead Comments**: Removed commented-out code

### 3. README & Documentation
- [ ] **Setup Instructions**: Clear project setup guide
- [ ] **Architecture Overview**: High-level architecture explanation
- [ ] **Contributing Guidelines**: Clear contribution process
- [ ] **Changelog**: Maintained change history

---

## Build & Deployment

### 1. Build Configuration
- [ ] **Environment Separation**: Clear dev/staging/prod configurations
- [ ] **Build Reproducibility**: Consistent builds across environments
- [ ] **Dependency Locking**: Locked dependency versions
- [ ] **Build Optimization**: Optimized build times and output

### 2. CI/CD Pipeline
- [ ] **Automated Testing**: All tests run in CI
- [ ] **Code Quality Gates**: Quality checks prevent bad code merge
- [ ] **Automated Deployment**: Streamlined deployment process
- [ ] **Rollback Strategy**: Clear rollback procedures

### 3. Release Management
- [ ] **Version Management**: Proper semantic versioning
- [ ] **Release Notes**: Clear release documentation
- [ ] **Feature Flags**: Gradual feature rollout capability
- [ ] **Monitoring**: Post-deployment monitoring setup

---

## Project Maintainability Assessment

### 1. Codebase Structure Analysis
- [ ] **Package Organization**: Logical grouping and clear module boundaries
- [ ] **File Size Distribution**: Reasonable file sizes (< 500 lines per file)
- [ ] **Class Complexity**: Manageable class sizes and responsibilities
- [ ] **Dependency Graph**: Clear dependency directions and minimal circular dependencies
- [ ] **Code Duplication**: Minimal code duplication (< 5% overall)

### 2. Architecture Evaluation
- [ ] **Pattern Consistency**: Consistent architectural pattern usage
- [ ] **Layer Separation**: Clear separation between UI, business, and data layers
- [ ] **Design Principles**: SOLID principles adherence
- [ ] **Coupling Analysis**: Low coupling between modules/components
- [ ] **Cohesion Analysis**: High cohesion within modules/components

### 3. Code Quality Metrics
- [ ] **Cyclomatic Complexity**: Average complexity < 10 per method
- [ ] **Maintainability Index**: Score > 70 (if measurable)
- [ ] **Code Coverage**: Test coverage > 60% (preferably > 80%)
- [ ] **Static Analysis**: Clean static analysis reports
- [ ] **Code Smells**: Minimal code smells and anti-patterns

### 4. Documentation Quality
- [ ] **README Completeness**: Comprehensive setup and usage instructions
- [ ] **API Documentation**: Well-documented public interfaces
- [ ] **Architecture Documentation**: Clear system design documentation
- [ ] **Code Comments**: Appropriate inline documentation
- [ ] **Change Documentation**: Clear commit history and changelog

### 5. Development Environment
- [ ] **Build System**: Modern and efficient build configuration
- [ ] **IDE Support**: Good IDE integration and tooling
- [ ] **Debugging Tools**: Adequate debugging and profiling setup
- [ ] **Development Scripts**: Automated setup and common tasks
- [ ] **Environment Configuration**: Clear environment separation

---

## Technical Debt Evaluation

### 1. Code Debt Assessment
- [ ] **Legacy Code**: Percentage of outdated/legacy code patterns
- [ ] **TODO/FIXME Count**: Number of unresolved technical todos
- [ ] **Deprecated APIs**: Usage of deprecated frameworks/APIs
- [ ] **Code Smells**: Identified anti-patterns and code smells
- [ ] **Refactoring Needs**: Areas requiring immediate refactoring

### 2. Architecture Debt
- [ ] **Pattern Violations**: Deviations from established patterns
- [ ] **Layer Violations**: Cross-layer dependencies and violations
- [ ] **Tight Coupling**: Highly coupled components requiring decoupling
- [ ] **Missing Abstractions**: Areas lacking proper abstraction layers
- [ ] **Scalability Issues**: Architecture limitations for growth

### 3. Technology Debt
- [ ] **Outdated Dependencies**: Number of outdated libraries/frameworks
- [ ] **Security Vulnerabilities**: Known security issues in dependencies
- [ ] **Platform Compatibility**: Compatibility with current platform versions
- [ ] **Performance Issues**: Known performance bottlenecks
- [ ] **Missing Features**: Critical missing functionality

### 4. Test Debt
- [ ] **Test Coverage Gaps**: Areas with insufficient test coverage
- [ ] **Test Quality**: Quality and maintainability of existing tests
- [ ] **Test Infrastructure**: Adequacy of testing infrastructure
- [ ] **Integration Tests**: Coverage of integration scenarios
- [ ] **End-to-End Tests**: Coverage of critical user journeys

### 5. Documentation Debt
- [ ] **Outdated Documentation**: Documentation that doesn't match current code
- [ ] **Missing Documentation**: Critical areas lacking documentation
- [ ] **Setup Complexity**: Difficulty in project setup and onboarding
- [ ] **Knowledge Gaps**: Areas with insufficient knowledge transfer
- [ ] **Process Documentation**: Missing development process documentation

---

## Scoring Framework

### 1. Scoring Criteria

#### Code Quality Score (Weight: 25%)
| Metric | Excellent (9-10) | Good (7-8) | Fair (5-6) | Poor (1-4) | Critical (0) |
|--------|------------------|------------|------------|------------|--------------|
| **Code Structure** | Well-organized, clear patterns | Mostly organized | Some organization issues | Poor organization | Chaotic structure |
| **Complexity** | Low complexity, readable | Moderate complexity | High complexity in places | Very high complexity | Unmanageable complexity |
| **Duplication** | < 2% duplication | 2-5% duplication | 5-10% duplication | 10-20% duplication | > 20% duplication |
| **Standards** | Consistent style | Mostly consistent | Some inconsistencies | Many inconsistencies | No standards |

#### Architecture Score (Weight: 20%)
| Metric | Excellent (9-10) | Good (7-8) | Fair (5-6) | Poor (1-4) | Critical (0) |
|--------|------------------|------------|------------|------------|--------------|
| **Pattern Adherence** | Consistent patterns | Mostly consistent | Some violations | Many violations | No clear pattern |
| **Separation of Concerns** | Clear separation | Mostly separated | Some mixing | Significant mixing | No separation |
| **Scalability** | Highly scalable | Scalable | Limited scalability | Poor scalability | Not scalable |
| **Maintainability** | Easy to maintain | Maintainable | Moderate effort | High effort | Unmaintainable |

#### Technical Debt Score (Weight: 20%)
| Metric | Excellent (9-10) | Good (7-8) | Fair (5-6) | Poor (1-4) | Critical (0) |
|--------|------------------|------------|------------|------------|--------------|
| **Legacy Code** | < 10% legacy | 10-25% legacy | 25-50% legacy | 50-75% legacy | > 75% legacy |
| **Outdated Dependencies** | All current | Few outdated | Some outdated | Many outdated | Mostly outdated |
| **Security Issues** | No known issues | Minor issues | Some issues | Major issues | Critical vulnerabilities |
| **Performance** | Excellent performance | Good performance | Acceptable performance | Poor performance | Unacceptable performance |

#### Testing Score (Weight: 15%)
| Metric | Excellent (9-10) | Good (7-8) | Fair (5-6) | Poor (1-4) | Critical (0) |
|--------|------------------|------------|------------|------------|--------------|
| **Test Coverage** | > 80% coverage | 60-80% coverage | 40-60% coverage | 20-40% coverage | < 20% coverage |
| **Test Quality** | High-quality tests | Good tests | Adequate tests | Poor tests | No meaningful tests |
| **Test Infrastructure** | Excellent setup | Good setup | Basic setup | Poor setup | No test infrastructure |

#### Documentation Score (Weight: 10%)
| Metric | Excellent (9-10) | Good (7-8) | Fair (5-6) | Poor (1-4) | Critical (0) |
|--------|------------------|------------|------------|------------|--------------|
| **Completeness** | Comprehensive docs | Good coverage | Basic coverage | Minimal docs | No documentation |
| **Accuracy** | Up-to-date | Mostly current | Some outdated | Mostly outdated | Completely outdated |
| **Usability** | Easy to follow | Generally clear | Somewhat unclear | Difficult to follow | Unusable |

#### Development Experience Score (Weight: 10%)
| Metric | Excellent (9-10) | Good (7-8) | Fair (5-6) | Poor (1-4) | Critical (0) |
|--------|------------------|------------|------------|------------|--------------|
| **Setup Ease** | < 30 min setup | 30-60 min setup | 1-2 hour setup | 2-4 hour setup | > 4 hour setup |
| **Build Time** | < 2 min build | 2-5 min build | 5-10 min build | 10-20 min build | > 20 min build |
| **Debugging** | Excellent tools | Good tools | Basic tools | Poor tools | No debugging support |

### 2. Final Score Calculation

**Weighted Average Formula:**
```
Final Score = (Code Quality × 0.25) + (Architecture × 0.20) + (Technical Debt × 0.20) + 
              (Testing × 0.15) + (Documentation × 0.10) + (Development Experience × 0.10)
```

### 3. Risk Assessment Matrix

#### Time Investment Estimation
| Score Range | Risk Level | Estimated Effort | Recommendation |
|-------------|------------|------------------|----------------|
| **8.5 - 10.0** | **Low Risk** | 1-2 weeks setup | **Highly Recommended** - Excellent codebase |
| **7.0 - 8.4** | **Low-Medium Risk** | 2-4 weeks setup | **Recommended** - Good foundation, minor improvements needed |
| **5.5 - 6.9** | **Medium Risk** | 1-2 months refactoring | **Consider Carefully** - Significant technical debt |
| **4.0 - 5.4** | **Medium-High Risk** | 2-4 months refactoring | **High Risk** - Major refactoring required |
| **2.0 - 3.9** | **High Risk** | 4-6 months rebuild | **Not Recommended** - Consider rewrite |
| **0.0 - 1.9** | **Critical Risk** | 6+ months rebuild | **Avoid** - Complete rewrite necessary |

### 4. Decision Framework

#### Project Acceptance Criteria
- [ ] **Minimum Score**: Final score ≥ 5.5 for consideration
- [ ] **Critical Blockers**: No critical security vulnerabilities
- [ ] **Business Value**: Project value justifies investment
- [ ] **Team Capacity**: Team has bandwidth for required effort
- [ ] **Timeline Constraints**: Available time matches effort estimation

#### Risk Mitigation Strategies
- [ ] **Technical Debt Plan**: Prioritized plan for addressing debt
- [ ] **Knowledge Transfer**: Plan for understanding existing codebase
- [ ] **Gradual Improvement**: Incremental improvement strategy
- [ ] **Testing Strategy**: Plan for improving test coverage
- [ ] **Documentation Plan**: Strategy for improving documentation

---

## Code Review Checklist

### Critical Issues (Must Fix)
- [ ] Security vulnerabilities
- [ ] Memory leaks or crashes
- [ ] Data loss scenarios
- [ ] Breaking API changes
- [ ] Performance regressions

### Major Issues (Should Fix)
- [ ] Architecture violations
- [ ] Poor error handling
- [ ] Accessibility issues
- [ ] Test coverage gaps
- [ ] Documentation missing

### Minor Issues (Consider Fixing)
- [ ] Code style inconsistencies
- [ ] Minor performance improvements
- [ ] Refactoring opportunities
- [ ] Comment improvements
- [ ] Naming suggestions

### Positive Feedback
- [ ] Well-implemented solutions
- [ ] Good test coverage
- [ ] Clear documentation
- [ ] Performance improvements
- [ ] Security enhancements

---

## Reporting Template

### Code Review Report

**Project**: [Project Name]  
**Reviewer**: [Reviewer Name]  
**Date**: [Review Date]  
**Branch/PR**: [Branch/PR Reference]  
**Files Reviewed**: [Number of files]

#### Executive Summary
[Brief overview of the changes and overall assessment]

#### Maintainability Assessment Scores

| Category | Score (0-10) | Weight | Weighted Score | Comments |
|----------|--------------|--------|----------------|----------|
| **Code Quality** | [X.X] | 25% | [X.XX] | [Brief assessment] |
| **Architecture** | [X.X] | 20% | [X.XX] | [Brief assessment] |
| **Technical Debt** | [X.X] | 20% | [X.XX] | [Brief assessment] |
| **Testing** | [X.X] | 15% | [X.XX] | [Brief assessment] |
| **Documentation** | [X.X] | 10% | [X.XX] | [Brief assessment] |
| **Dev Experience** | [X.X] | 10% | [X.XX] | [Brief assessment] |
| **FINAL SCORE** | **[X.XX]** | **100%** | **[X.XX]** | **[Risk Level]** |

#### Risk Assessment
- **Risk Level**: [Low/Low-Medium/Medium/Medium-High/High/Critical]
- **Estimated Effort**: [Time estimation based on score]
- **Recommendation**: [Project acceptance recommendation]

#### Technical Debt Analysis

##### Code Debt Metrics
- **Legacy Code Percentage**: [X]%
- **TODO/FIXME Count**: [X] items
- **Code Duplication**: [X]%
- **Cyclomatic Complexity**: Average [X.X]
- **File Size Issues**: [X] files > 500 lines

##### Architecture Debt Issues
- **Pattern Violations**: [X] identified
- **Layer Violations**: [X] cross-layer dependencies
- **Tight Coupling**: [X] highly coupled components
- **Missing Abstractions**: [X] areas need abstraction

##### Technology Debt Issues
- **Outdated Dependencies**: [X] of [Y] dependencies
- **Security Vulnerabilities**: [X] critical, [Y] major, [Z] minor
- **Platform Compatibility**: [Compatible/Issues with current versions]
- **Performance Bottlenecks**: [X] identified areas

#### Time Investment Breakdown

| Category | Current State | Target State | Estimated Effort | Priority |
|----------|---------------|--------------|------------------|----------|
| **Code Refactoring** | [Current score] | [Target score] | [X weeks/months] | [High/Medium/Low] |
| **Architecture Improvements** | [Current score] | [Target score] | [X weeks/months] | [High/Medium/Low] |
| **Dependency Updates** | [Current score] | [Target score] | [X weeks/months] | [High/Medium/Low] |
| **Test Coverage** | [Current %] | [Target %] | [X weeks/months] | [High/Medium/Low] |
| **Documentation** | [Current score] | [Target score] | [X weeks/months] | [High/Medium/Low] |
| **TOTAL EFFORT** | - | - | **[X weeks/months]** | - |

#### Critical Issues Found
| Issue | File | Line | Severity | Description | Effort | Recommendation |
|-------|------|------|----------|-------------|--------|----------------|
| | | | | | | |

#### Major Issues Found
| Issue | File | Line | Category | Description | Effort | Recommendation |
|-------|------|------|----------|-------------|--------|----------------|
| | | | | | | |

#### Minor Issues & Suggestions
| Issue | File | Line | Category | Description | Effort | Recommendation |
|-------|------|------|----------|-------------|--------|----------------|
| | | | | | | |

#### Positive Observations
- [List well-implemented features or improvements]
- [Highlight good architectural decisions]
- [Note areas with good test coverage]
- [Mention clear documentation sections]

#### Detailed Assessment

##### Code Quality Analysis
- **Structure**: [Assessment of package organization and file structure]
- **Complexity**: [Analysis of code complexity and readability]
- **Standards**: [Evaluation of coding standards adherence]
- **Maintainability**: [Assessment of how easy code is to maintain]

##### Architecture Analysis
- **Pattern Usage**: [Evaluation of architectural pattern consistency]
- **Layer Separation**: [Assessment of separation of concerns]
- **Scalability**: [Analysis of system scalability]
- **Design Principles**: [SOLID principles adherence]

##### Technical Debt Priority Matrix
| Priority | Category | Issues | Estimated Effort | Business Impact |
|----------|----------|--------|------------------|-----------------|
| **P0 - Critical** | [Category] | [X issues] | [X weeks] | [High/Medium/Low] |
| **P1 - High** | [Category] | [X issues] | [X weeks] | [High/Medium/Low] |
| **P2 - Medium** | [Category] | [X issues] | [X weeks] | [High/Medium/Low] |
| **P3 - Low** | [Category] | [X issues] | [X weeks] | [High/Medium/Low] |

#### Project Acceptance Decision

##### Decision Matrix
- [ ] **Score Threshold Met**: Final score ≥ 5.5 ✓/✗
- [ ] **No Critical Blockers**: No critical security/stability issues ✓/✗
- [ ] **Effort Justified**: Business value > estimated effort ✓/✗
- [ ] **Team Capacity**: Available resources for required work ✓/✗
- [ ] **Timeline Feasible**: Delivery timeline achievable ✓/✗

##### Final Recommendation
- [ ] **Accept Project**: Proceed with acquisition/maintenance
- [ ] **Accept with Conditions**: Proceed with specific requirements
- [ ] **Negotiate Terms**: Adjust scope/timeline/budget based on findings
- [ ] **Reject Project**: Technical debt too high for business value

#### Risk Mitigation Plan
1. **Immediate Actions**: [Critical issues to address first]
2. **Short-term Plan** (1-3 months): [High-priority improvements]
3. **Medium-term Plan** (3-6 months): [Architecture and major refactoring]
4. **Long-term Plan** (6+ months): [Complete modernization strategy]

#### Resource Requirements
- **Development Team**: [X] developers for [Y] months
- **Senior/Lead Developer**: [X] person-months for architecture work
- **QA Resources**: [X] testers for [Y] months
- **DevOps Support**: [X] person-months for infrastructure
- **Total Budget Estimate**: $[X] - $[Y] (based on effort estimation)

#### Success Metrics
- **Code Quality Target**: Achieve score ≥ 8.0
- **Test Coverage Target**: Achieve ≥ 80% coverage
- **Performance Target**: [Specific performance goals]
- **Security Target**: Zero critical vulnerabilities
- **Timeline Target**: Complete improvements within [X] months

#### Next Steps
1. [Immediate action items]
2. [Team assignments and responsibilities]
3. [Timeline and milestone planning]
4. [Regular review and progress tracking setup]

---

## Usage Instructions

### For Human Reviewers
1. Use this document as a comprehensive checklist
2. Focus on areas most relevant to the specific changes
3. Provide constructive feedback with clear examples
4. Balance thoroughness with practicality
5. Document findings using the reporting template

### For Automated Systems/LLMs
1. Process each section systematically
2. Flag issues with appropriate severity levels
3. Provide specific file and line references
4. Generate actionable recommendations
5. Produce structured reports using the template

### Customization Guidelines
- Adapt sections based on project-specific requirements
- Add platform-specific checks as needed
- Modify severity levels based on project criticality
- Include project-specific coding standards
- Update checklist based on lessons learned

---

*This document should be regularly updated to reflect evolving best practices and platform changes.*
