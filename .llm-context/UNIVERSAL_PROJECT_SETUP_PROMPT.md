# Universal Project Setup Prompt - Complete .llm-context Generator

## Overview
This prompt generates a complete `.llm-context` directory structure for any software project, maintaining the exact formatting, styling, and workflow standards established in the OBHAI Android Contractor project while adapting content to the specific project context.

## How to Use This Prompt

### Step 1: Automatic Project Analysis
This prompt will automatically analyze the target project structure to detect:
- Project name and type
- Technology stack and frameworks
- Programming language and build system
- Dependencies and architecture patterns
- Git repository type and structure
- Project stage and complexity

### Step 2: Execute the Prompt
Paste the customized prompt below to your AI assistant to automatically generate the complete `.llm-context` structure.

---

## THE UNIVERSAL SETUP PROMPT

I need you to create a complete .llm-context directory structure for my software project. Generate all files and directories following the exact format, styling, and standards from the OBHAI Android Contractor reference implementation, but adapt the content to my specific project context.

## PROJECT ANALYSIS INSTRUCTIONS

**STEP 1: Analyze the target project structure** (located at ./../ relative to this .llm-context folder)

Examine the following files and directories to automatically detect project information:

### Required Analysis Tasks:
1. **Project Identification**:
   - Check README.md, package.json, build.gradle, pom.xml, Cargo.toml, etc.
   - Extract project name, description, and version
   - Identify company/organization from package identifiers

2. **Technology Stack Detection**:
   - **Android**: Check build.gradle, AndroidManifest.xml, Kotlin/Java files
   - **iOS**: Check Podfile, Package.swift, .xcodeproj, Swift/Objective-C files  
   - **Web**: Check package.json, webpack.config.js, framework-specific files
   - **Backend**: Check requirements.txt, pom.xml, go.mod, etc.
   - **Desktop**: Check platform-specific build files and frameworks

3. **Architecture Pattern Recognition**:
   - Scan source code structure for MVVM, MVP, MVC, Clean Architecture
   - Identify dependency injection frameworks (Hilt, Dagger, etc.)
   - Detect navigation patterns and state management

4. **Build System and Dependencies**:
   - Extract primary language from file extensions and build configs
   - List major dependencies and frameworks
   - Identify testing frameworks and tools

5. **Git Repository Analysis**:
   - Check .git/config for repository type (GitHub, GitLab, etc.)
   - Analyze branch structure and workflow patterns
   - Detect CI/CD configurations

6. **Project Stage Assessment**:
   - New Project: Minimal files, basic structure
   - Existing Codebase: Established structure, multiple features
   - Legacy Migration: Mixed patterns, outdated dependencies

**STEP 2: Auto-populate project context** based on analysis results:

```
PROJECT_NAME: [Auto-detected from project files]
PROJECT_TYPE: [Auto-detected: Android App / iOS App / Web App / API Service / etc.]
TECHNOLOGY_STACK: [Auto-detected: Primary frameworks and libraries]
COMPANY_NAME: [Auto-detected from package identifiers]
PROJECT_DESCRIPTION: [Auto-generated based on project type and structure]
TARGET_PLATFORM: [Auto-detected from build configurations]
COMPLIANCE_REQUIREMENTS: [Auto-determined based on platform and type]
TEAM_SIZE: [Estimated from project complexity: Small/Medium/Large]
PROJECT_STAGE: [Auto-assessed from codebase maturity]
GIT_REPOSITORY: [Auto-detected from .git/config]
PRIMARY_LANGUAGE: [Auto-detected from file analysis]
PROJECT_PATH: ./../
```

## REQUIRED DIRECTORY STRUCTURE

Create the following exact directory structure in the project root:

```
.llm-context/
├── README.md
├── REUSABLE_PROJECT_SETUP_PROMPT.md
├── ai-context/
│   └── preferences.md
├── development/
│   ├── code-review-guidelines.md
│   ├── coding-standards.md
│   ├── git-workflow.md
│   ├── testing-strategy.md
│   └── troubleshooting.md
├── project/
│   ├── api-documentation.md
│   ├── architecture.md
│   ├── business-requirements.md
│   ├── deployment-guide.md
│   ├── open-issues.md
│   └── technology-stack.md
└── templates/
    ├── USAGE.md
    ├── comprehensive-report-generator-prompt.md
    └── UNIVERSAL_PROJECT_SETUP_PROMPT.md
```

## REFERENCE FILE CONTENTS

The following sections contain the complete content of all reference files from the OBHAI Android Contractor project. Use these as templates, adapting only the technology-specific content while maintaining exact formatting and structure.

### 1. Root Level Files

#### .llm-context/README.md
```markdown
# .llm-context Directory

## Overview
This directory contains comprehensive project documentation, development guidelines, and AI assistant configurations for [PROJECT_NAME]. It serves as the central knowledge base for development practices, code quality standards, and project management.

## Directory Structure

### `/ai-context/`
AI assistant preferences and configuration files that define how AI tools should interact with this project.

- `preferences.md` - AI assistant preferences for code generation, review standards, and communication style

### `/development/`
Development guidelines, workflows, and best practices for the engineering team.

- `code-review-guidelines.md` - Comprehensive code review framework with scoring systems
- `coding-standards.md` - Language-specific coding standards and style guides
- `git-workflow.md` - Git branching strategy and workflow procedures
- `testing-strategy.md` - Testing frameworks, coverage targets, and quality assurance
- `troubleshooting.md` - Common issues and solutions for development environment

### `/project/`
Project-specific documentation including architecture, requirements, and technical specifications.

- `api-documentation.md` - API endpoints, authentication, and integration guides
- `architecture.md` - System architecture, design patterns, and component structure
- `business-requirements.md` - Functional and non-functional requirements
- `deployment-guide.md` - Deployment procedures, environments, and CI/CD pipelines
- `open-issues.md` - Known issues, technical debt, and improvement opportunities
- `technology-stack.md` - Technology choices, dependencies, and version requirements

### `/templates/`
Reusable templates and prompts for project management and reporting.

- `USAGE.md` - Instructions for using templates and maintaining documentation
- `comprehensive-report-generator-prompt.md` - Template for generating project analysis reports
- `UNIVERSAL_PROJECT_SETUP_PROMPT.md` - Template for setting up .llm-context in new projects

## Usage Guidelines

### For Development Teams
1. **Onboarding**: New team members should read all files in order: README → project/ → development/
2. **Daily Development**: Reference coding-standards.md and git-workflow.md for consistent practices
3. **Code Reviews**: Use code-review-guidelines.md for thorough and objective reviews
4. **Issue Resolution**: Check troubleshooting.md before escalating technical problems

### For Project Managers
1. **Project Status**: Use templates/ for generating comprehensive project reports
2. **Requirements Management**: Maintain business-requirements.md and open-issues.md
3. **Quality Assurance**: Monitor adherence to guidelines in development/ directory

### For AI Assistants
1. **Configuration**: Follow preferences in ai-context/ for consistent behavior
2. **Code Generation**: Adhere to standards in coding-standards.md and architecture.md
3. **Documentation**: Use templates/ for generating project documentation

## Maintenance

### Regular Updates
- **Monthly**: Review and update open-issues.md with current project status
- **Quarterly**: Update technology-stack.md with dependency changes
- **Per Release**: Update deployment-guide.md with new procedures

### Quality Assurance
- All documentation should be reviewed during code review process
- Templates should be tested before major releases
- Guidelines should be updated based on team feedback and lessons learned

## Integration with Development Workflow

This .llm-context directory integrates with:
- **IDE Extensions**: AI assistants can reference preferences and standards
- **CI/CD Pipelines**: Automated checks can validate against coding standards
- **Code Review Tools**: Guidelines provide objective criteria for reviews
- **Project Management**: Templates enable consistent reporting and analysis

## Contributing

When updating .llm-context files:
1. Follow the existing format and structure exactly
2. Test any template changes before committing
3. Update this README if adding new files or changing structure
4. Ensure all team members are notified of significant changes

This directory serves as the single source of truth for project standards and should be maintained with the same rigor as production code.
```

#### .llm-context/REUSABLE_PROJECT_SETUP_PROMPT.md
```markdown
# Reusable Project Setup Prompt

## Overview
This document contains a reusable prompt template for setting up comprehensive project documentation and development guidelines. It can be adapted for any software project while maintaining consistent quality and structure.

## The Setup Prompt

Copy and customize the following prompt for your project:

---

I need you to set up a comprehensive .llm-context directory structure for my [PROJECT_TYPE] project. Please create all necessary files and documentation following professional standards.

## Project Information
- **Project Name**: [PROJECT_NAME]
- **Technology Stack**: [TECHNOLOGY_STACK]
- **Team Size**: [TEAM_SIZE]
- **Project Stage**: [PROJECT_STAGE]

## Required Structure
Create the complete .llm-context directory with all subdirectories and files, adapting content for the specified technology stack while maintaining professional formatting and comprehensive coverage.

---

## Customization Guidelines

### Technology-Specific Adaptations
- **Android Projects**: Include Kotlin/Java standards, Android Architecture Components
- **iOS Projects**: Include Swift/Objective-C standards, iOS frameworks
- **Web Projects**: Include JavaScript/TypeScript standards, web frameworks
- **Backend Projects**: Include server-side standards, API design guidelines

### Team Size Considerations
- **Small Teams (1-5)**: Focus on essential guidelines and simplified workflows
- **Medium Teams (6-15)**: Include comprehensive review processes and collaboration tools
- **Large Teams (15+)**: Add governance, architecture review boards, and formal processes

### Project Stage Adaptations
- **New Projects**: Emphasize setup procedures and initial architecture decisions
- **Existing Projects**: Focus on improvement opportunities and technical debt management
- **Legacy Projects**: Include migration strategies and modernization guidelines

This template ensures consistent, high-quality project documentation across all software projects.
```

### 2. AI Context Directory

#### .llm-context/ai-context/preferences.md
```markdown
# AI Assistant Preferences and Guidelines

## Code Generation Preferences

### Language and Framework Preferences
- **Primary Language**: [Adapt to PRIMARY_LANGUAGE - e.g., Kotlin for Android, Swift for iOS, TypeScript for Web]
- **Architecture Pattern**: [Adapt to platform - MVVM for Android/iOS, MVC for Web, Clean Architecture for all]
- **Dependency Injection**: [Technology-specific - Dagger Hilt for Android, SwiftUI DI for iOS, etc.]
- **Async Programming**: [Language-specific - Coroutines for Kotlin, async/await for JS/TS, Combine for Swift]
- **UI Framework**: [Platform-specific - ViewBinding for Android, SwiftUI for iOS, React for Web]

### Code Style Preferences
- **Naming Convention**: [Language-specific conventions - camelCase, PascalCase, snake_case as appropriate]
- **File Organization**: Group by feature rather than by type
- **Comment Style**: Focus on "why" rather than "what"
- **Error Handling**: [Language-appropriate - sealed classes for Kotlin, Result types for Swift, try/catch for JS]
- **Null Safety**: [Language-specific null safety features]

### Testing Preferences
- **Unit Testing**: [Framework-specific - JUnit for Java/Kotlin, XCTest for Swift, Jest for JS/TS]
- **UI Testing**: [Platform-specific - Espresso for Android, XCUITest for iOS, Cypress for Web]
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
- **Environment Management**: Separate configurations for dev/test/prod
- **Dependency Management**: Pin specific versions, regular security updates
- **Build Optimization**: [Platform-specific optimization strategies]
- **CI/CD**: Automated testing and deployment pipelines
```
- **Development Workflow**: Adapt to GIT_REPOSITORY type
- **Build and Deployment**: Technology-specific build tools

### 3. Development Directory

#### .llm-context/development/code-review-guidelines.md
**CRITICAL**: Maintain the EXACT formatting, styling, and structure from OBHAI reference. Only adapt:
- Technology-specific examples in code blocks
- Platform-specific checklist items
- Framework-specific best practices
- Keep all scoring matrices, tables, and decision frameworks identical
- Maintain all CSS classes and HTML structure for reports
- Update only technology references, not the review framework

#### .llm-context/development/coding-standards.md
Adapt coding standards for the specific technology stack while maintaining structure:
- **Language-Specific Standards**: PRIMARY_LANGUAGE conventions
- **Framework Guidelines**: TECHNOLOGY_STACK best practices
- **Platform Standards**: TARGET_PLATFORM requirements
- **Code Organization**: Technology-appropriate structure
- Keep exact formatting and section organization

#### .llm-context/development/git-workflow.md
**CRITICAL**: Keep the EXACT git workflow structure from OBHAI reference:
- Maintain the 4-branch environment strategy (main/staging/test/dev)
- Keep all branch protection rules and merge policies
- Preserve PR title conventions and commit message standards
- Update only project name references and technology examples
- Maintain all Git commands and workflow procedures exactly

#### .llm-context/development/testing-strategy.md
Adapt testing strategy for the technology stack:
- **Testing Frameworks**: Technology-appropriate tools
- **Test Types**: Platform-specific testing approaches
- **Coverage Targets**: Maintain percentage targets from reference
- **CI/CD Integration**: Adapt to technology build systems
- Keep exact structure and formatting

#### .llm-context/development/troubleshooting.md
Generate troubleshooting guide for the specific technology:
- **Build Issues**: Technology-specific build problems
- **Runtime Issues**: Platform-specific runtime errors
- **Development Environment**: IDE and tooling issues
- **Deployment Problems**: Technology-specific deployment issues
- Maintain exact formatting and structure from reference

### 4. Project Directory

#### .llm-context/project/architecture.md
Generate architecture documentation adapted for the technology:
- **Architectural Pattern**: Technology-appropriate patterns (MVVM, MVC, etc.)
- **Layer Structure**: Platform-specific layering
- **Component Design**: Technology-specific components
- **Data Flow**: Framework-appropriate data management
- Keep exact markdown formatting

#### .llm-context/project/business-requirements.md
Generate business requirements template adapted for project type:
- **Functional Requirements**: PROJECT_TYPE specific features
- **Non-Functional Requirements**: Platform performance standards
- **User Stories**: PROJECT_DESCRIPTION based scenarios
- **Acceptance Criteria**: Technology-testable criteria
- Maintain exact structure and formatting

#### .llm-context/project/technology-stack.md
Generate comprehensive technology stack documentation:
- **Core Technologies**: TECHNOLOGY_STACK breakdown
- **Development Tools**: Platform-specific tooling
- **Dependencies**: Technology-appropriate libraries
- **Infrastructure**: Deployment and hosting technologies
- **Version Requirements**: Specific version constraints

#### .llm-context/project/api-documentation.md
Generate API documentation template for the technology:
- **API Design**: Technology-appropriate API patterns
- **Endpoint Structure**: Framework-specific routing
- **Authentication**: Platform security standards
- **Data Models**: Technology data structures
- Adapt examples to PRIMARY_LANGUAGE syntax

#### .llm-context/project/deployment-guide.md
Generate deployment guide for the technology:
- **Build Process**: Technology-specific build steps
- **Environment Setup**: Platform deployment requirements
- **CI/CD Pipeline**: Technology build and deployment automation
- **Monitoring**: Platform-appropriate monitoring tools
- Update for TARGET_PLATFORM deployment targets

#### .llm-context/project/open-issues.md
Generate open issues template:
- Create placeholder structure for tracking project issues
- Include categories relevant to PROJECT_TYPE
- Maintain exact formatting from OBHAI reference
- Add technology-specific issue categories

### 5. Templates Directory

#### .llm-context/templates/USAGE.md
Generate usage instructions for the templates:
- Explain how to use each template
- Technology-specific customization instructions
- Maintenance and update procedures
- Keep exact formatting

#### .llm-context/templates/comprehensive-report-generator-prompt.md
**CRITICAL**: Copy the EXACT content from OBHAI reference with these ONLY changes:
- Update placeholder project names to use [PROJECT_NAME]
- Update technology stack examples to include PRIMARY_LANGUAGE
- Update compliance targets to include COMPLIANCE_REQUIREMENTS
- Keep ALL formatting, CSS, HTML structure, and scoring frameworks identical
- Maintain exact report template structure and styling
- Preserve all interactive features and responsive design

#### .llm-context/templates/UNIVERSAL_PROJECT_SETUP_PROMPT.md
Copy this exact prompt file to enable recursive project setup generation.

## ADAPTATION RULES

### What to Maintain Exactly (DO NOT CHANGE):
1. **Git Workflow Structure**: 4-branch strategy, merge policies, PR conventions
2. **Report Formatting**: All CSS, HTML structure, scoring matrices, decision frameworks
3. **Code Review Framework**: Scoring system, evaluation criteria, decision matrices
4. **Directory Structure**: Exact folder and file organization
5. **Markdown Formatting**: Headers, tables, code blocks, styling
6. **Template Structure**: All prompt templates and usage instructions

### What to Adapt (CHANGE BASED ON PROJECT):
1. **Technology Examples**: Code snippets, framework references, tool names
2. **Platform Standards**: OS-specific guidelines, platform best practices
3. **Language Conventions**: Syntax examples, naming conventions, style guides
4. **Build Tools**: Technology-specific build systems and commands
5. **Testing Frameworks**: Platform-appropriate testing tools and strategies
6. **Deployment Targets**: Platform-specific deployment procedures

### Technology-Specific Adaptations:

#### For Android Projects:
- Use Kotlin/Java examples
- Include Android SDK, Gradle, ProGuard references
- Add Play Store compliance guidelines
- Include Android Architecture Components

#### For iOS Projects:
- Use Swift/Objective-C examples
- Include Xcode, CocoaPods/SPM references
- Add App Store compliance guidelines
- Include iOS frameworks and patterns

#### For Web Projects:
- Use JavaScript/TypeScript examples
- Include npm/yarn, webpack/vite references
- Add browser compatibility guidelines
- Include web performance standards

#### For Backend/API Projects:
- Use appropriate language examples
- Include database and server references
- Add API design guidelines
- Include scalability considerations

#### For Desktop Projects:
- Use platform-appropriate examples
- Include desktop framework references
- Add OS-specific guidelines
- Include distribution considerations

## QUALITY REQUIREMENTS

### Content Quality:
- All content must be immediately actionable
- Examples must be technology-appropriate and current
- Guidelines must be specific to the technology stack
- Documentation must be comprehensive and clear

### Formatting Quality:
- Maintain exact markdown structure from reference
- Preserve all table formatting and alignment
- Keep consistent heading hierarchy
- Maintain code block syntax highlighting

### Consistency Requirements:
- Use PROJECT_NAME consistently throughout all files
- Maintain consistent terminology for the technology stack
- Keep cross-references between files accurate
- Ensure all placeholders are properly replaced

### Completeness Requirements:
- Generate all required files and directories
- Include all sections from reference templates
- Provide technology-specific examples for all concepts
- Maintain comprehensive coverage of all topics

## OUTPUT INSTRUCTIONS

1. **Create Complete Directory Structure**: Generate all folders and files as specified
2. **Maintain Reference Quality**: Match the professional quality of OBHAI reference
3. **Technology Adaptation**: Properly adapt all content to the specified technology stack
4. **Preserve Critical Elements**: Keep git workflow, report formatting, and review frameworks exactly as reference
5. **Ensure Usability**: All generated content should be immediately usable by development teams

## SUCCESS CRITERIA

The generated .llm-context should enable:
- ✅ Immediate project setup and team onboarding
- ✅ Consistent development practices across team members
- ✅ Professional project reporting and analysis
- ✅ Comprehensive code review and quality assurance
- ✅ Efficient git workflow and collaboration
- ✅ Technology-appropriate best practices and standards

Please analyze the project context provided above and generate the complete .llm-context directory structure with all files, maintaining the exact quality and formatting standards of the OBHAI Android Contractor reference implementation while adapting content appropriately for the specified technology stack and project requirements.
```

---

## Template Metadata

**Created**: September 8, 2025  
**Version**: 1.0  
**Based On**: OBHAI Android Contractor .llm-context Structure  
**Applicable To**: Any software project (Android, iOS, Web, Desktop, API, etc.)  
**Output**: Complete .llm-context directory with all files and templates  
**Estimated Generation Time**: 1-2 hours depending on project complexity  

---

## Usage Examples

### Example 1: React Native Mobile App
```
PROJECT_NAME: FoodDelivery Mobile App
PROJECT_TYPE: Mobile App
TECHNOLOGY_STACK: React Native, TypeScript, Redux, Firebase, Stripe
COMPANY_NAME: QuickEats Inc
PROJECT_DESCRIPTION: Cross-platform food delivery app with real-time tracking
TARGET_PLATFORM: Cross-Platform (iOS/Android)
COMPLIANCE_REQUIREMENTS: Play Store, App Store, PCI DSS
TEAM_SIZE: Medium (6 developers)
PROJECT_STAGE: Existing Codebase
GIT_REPOSITORY: GitHub
PRIMARY_LANGUAGE: TypeScript
```

### Example 2: Spring Boot API Service
```
PROJECT_NAME: E-commerce Backend API
PROJECT_TYPE: API Service
TECHNOLOGY_STACK: Spring Boot, Java, PostgreSQL, Redis, Docker
COMPANY_NAME: ShopSmart Corp
PROJECT_DESCRIPTION: Scalable e-commerce backend with microservices architecture
TARGET_PLATFORM: Cloud (AWS/Azure)
COMPLIANCE_REQUIREMENTS: GDPR, PCI DSS, SOX
TEAM_SIZE: Large (12 developers)
PROJECT_STAGE: New Project
GIT_REPOSITORY: GitLab
PRIMARY_LANGUAGE: Java
```

### Example 3: Flutter Cross-Platform App (Current Project)
```
PROJECT_NAME: Flutter Boilerplate
PROJECT_TYPE: Mobile App Boilerplate
TECHNOLOGY_STACK: Flutter, Dart, MVVM Clean Architecture, Custom DI, Firebase
COMPANY_NAME: Development Team
PROJECT_DESCRIPTION: Production-ready Flutter boilerplate with modular architecture
TARGET_PLATFORM: Cross-Platform (iOS/Android)
COMPLIANCE_REQUIREMENTS: Play Store, App Store, Mobile Security Best Practices
TEAM_SIZE: Medium (5-8 developers)
PROJECT_STAGE: Existing Codebase
GIT_REPOSITORY: Git
PRIMARY_LANGUAGE: Dart
```

### Example 4: Next.js Web Application
```
PROJECT_NAME: Corporate Dashboard
PROJECT_TYPE: Web App
TECHNOLOGY_STACK: Next.js, TypeScript, Prisma, PostgreSQL, Tailwind CSS
COMPANY_NAME: DataViz Solutions
PROJECT_DESCRIPTION: Enterprise analytics and reporting dashboard
TARGET_PLATFORM: Web
COMPLIANCE_REQUIREMENTS: SOX, GDPR
TEAM_SIZE: Medium (8 developers)
PROJECT_STAGE: Existing Codebase
GIT_REPOSITORY: Azure DevOps
PRIMARY_LANGUAGE: TypeScript
```

## Benefits of This Universal Template

### For Project Managers
- **Instant Setup**: Complete project structure in 1-2 hours
- **Consistent Standards**: Same quality across all projects
- **Technology Agnostic**: Works for any tech stack
- **Proven Framework**: Based on successful OBHAI implementation

### For Development Teams
- **Immediate Productivity**: No setup time, start coding immediately
- **Clear Guidelines**: Comprehensive development standards
- **Quality Assurance**: Built-in review and testing frameworks
- **Collaboration Tools**: Git workflow and team processes

### For Organizations
- **Standardization**: Consistent practices across all projects
- **Quality Control**: Professional reporting and analysis tools
- **Knowledge Transfer**: Easy onboarding and documentation
- **Scalability**: Framework grows with team and project needs

This universal template ensures every software project starts with the same high-quality foundation while being perfectly adapted to its specific technology stack and requirements.
