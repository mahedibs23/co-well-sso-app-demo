# Commit Standards

> **Cross-Reference:** This document is part of the development workflow. See also:
> - [Git Branching](./git-branching.md) - Branching strategy and version control
> - [Pull Requests](./pull-requests.md) - Pull request creation and review process
> - [Project Configuration](../../.llm-context/project-config.md) - Project details

## Overview

This guide establishes consistent commit message standards and practices for the Flutter Boilerplate project to ensure clear project history and effective collaboration.

## 📝 Commit Message Format

### Standard Format
```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Example
```
feat(auth): add user login functionality

Implement JWT-based authentication with secure token storage
- Add login form with email/password validation
- Integrate with authentication API endpoint
- Store tokens using flutter_secure_storage
- Add automatic token refresh mechanism

Closes #123
```

## 🏷 Commit Types

### Primary Types
- **`feat`** - New feature for the user
- **`fix`** - Bug fix for the user
- **`docs`** - Documentation changes
- **`style`** - Code style changes (formatting, missing semicolons, etc.)
- **`refactor`** - Code refactoring without changing functionality
- **`test`** - Adding or updating tests
- **`chore`** - Maintenance tasks, dependency updates

### Additional Types
- **`perf`** - Performance improvements
- **`ci`** - CI/CD configuration changes
- **`build`** - Build system or external dependency changes
- **`revert`** - Reverting a previous commit

## 🎯 Scope Guidelines

### Common Scopes
- **`auth`** - Authentication and authorization
- **`api`** - API integration and data layer
- **`ui`** - User interface components
- **`navigation`** - App navigation and routing
- **`storage`** - Local data storage and caching
- **`config`** - Configuration and environment setup
- **`deps`** - Dependencies and package management
- **`tests`** - Test-related changes
- **`docs`** - Documentation updates

### Examples by Feature
```bash
# Authentication feature
feat(auth): implement OAuth login flow
fix(auth): resolve token refresh timing issue
test(auth): add unit tests for login validation

# API integration
feat(api): add user profile endpoint integration
fix(api): handle network timeout errors
refactor(api): extract common HTTP client configuration

# UI components
feat(ui): create reusable button component
fix(ui): resolve responsive layout issues on tablets
style(ui): update color scheme to match design system
```

## ✍️ Description Guidelines

### Writing Good Descriptions
- **Use imperative mood**: "add feature" not "added feature"
- **Be concise**: Limit to 50 characters when possible
- **Be specific**: Describe what the commit does, not what was wrong
- **Start with lowercase**: Unless it's a proper noun
- **No period**: Don't end with a period

### Good Examples
```bash
✅ feat(auth): add biometric authentication support
✅ fix(api): resolve timeout issues in user service
✅ docs(setup): update installation instructions for macOS
✅ refactor(storage): simplify user preferences management
✅ test(auth): add integration tests for login flow
```

### Bad Examples
```bash
❌ Fixed bug                           # Too vague
❌ feat(auth): Added login feature.    # Past tense, has period
❌ Update stuff                        # No type, vague
❌ feat: authentication and user management and profile updates  # Too long
❌ WIP                                 # Not descriptive
```

## 📄 Commit Body Guidelines

### When to Include a Body
- Complex changes that need explanation
- Breaking changes
- Multiple related changes in one commit
- Context about why the change was made

### Body Format
- Separate from description with a blank line
- Use bullet points for multiple items
- Explain the "what" and "why", not the "how"
- Wrap lines at 72 characters

### Example with Body
```
refactor(api): restructure user service architecture

Reorganize user-related API calls for better maintainability:
- Extract common HTTP client configuration
- Implement retry mechanism for failed requests
- Add request/response interceptors for logging
- Separate authentication logic from user operations

This change improves code reusability and makes testing easier.
The API surface remains unchanged for existing consumers.
```

## 🔗 Footer Guidelines

### Common Footers
- **`Closes #123`** - Closes an issue
- **`Fixes #456`** - Fixes a bug report
- **`Refs #789`** - References an issue
- **`BREAKING CHANGE:`** - Indicates breaking changes
- **`Co-authored-by:`** - Multiple authors

### Breaking Changes
```
feat(api): update user authentication endpoint

BREAKING CHANGE: The authentication endpoint now requires
email instead of username. Update all login forms to use
email field.

Migration guide:
- Replace username input with email input
- Update validation to check email format
- Test login flow with email credentials
```

### Co-authoring
```
feat(ui): implement dark mode theme

Co-authored-by: Jane Doe <jane@example.com>
Co-authored-by: John Smith <john@example.com>
```

## 🚀 Commit Best Practices

### Atomic Commits
- **One logical change per commit**
- **Complete and functional changes**
- **Easy to review and revert**

```bash
# Good - separate commits for separate concerns
feat(auth): add login form validation
feat(auth): integrate with authentication API
feat(auth): add token storage mechanism

# Bad - multiple unrelated changes
feat(auth): add login, fix navigation bug, update dependencies
```

### Commit Frequency
- **Commit early and often**
- **Don't wait for perfect code**
- **Use feature branches for work in progress**

### Testing Before Commits
```bash
# Run tests before committing
flutter test
flutter analyze

# Check formatting
dart format --set-exit-if-changed .

# Verify build
flutter build apk --debug
```

## 🔧 Git Hooks and Automation

### Pre-commit Hook Example
```bash
#!/bin/sh
# .git/hooks/pre-commit

# Run tests
echo "Running tests..."
flutter test || exit 1

# Check formatting
echo "Checking code formatting..."
dart format --set-exit-if-changed . || exit 1

# Run static analysis
echo "Running static analysis..."
flutter analyze || exit 1

echo "Pre-commit checks passed!"
```

### Commit Message Validation
```bash
#!/bin/sh
# .git/hooks/commit-msg

commit_regex='^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert)(\(.+\))?: .{1,50}'

if ! grep -qE "$commit_regex" "$1"; then
    echo "Invalid commit message format!"
    echo "Format: <type>(<scope>): <description>"
    echo "Example: feat(auth): add user login functionality"
    exit 1
fi
```

## 📊 Commit Message Examples by Scenario

### Feature Development
```bash
feat(auth): implement user registration flow
feat(auth): add email verification step
feat(auth): integrate with OAuth providers
test(auth): add unit tests for registration validation
docs(auth): update authentication guide
```

### Bug Fixes
```bash
fix(api): resolve timeout issues in user service
fix(ui): correct button alignment on small screens
fix(storage): handle null values in user preferences
fix(navigation): prevent duplicate route pushes
```

### Maintenance and Refactoring
```bash
chore(deps): update flutter to 3.16.0
refactor(api): extract common HTTP client configuration
style(ui): apply consistent spacing in forms
perf(storage): optimize database query performance
```

### Documentation and Configuration
```bash
docs(setup): update installation instructions
docs(api): add authentication examples
ci(github): add automated testing workflow
build(android): update target SDK version
```

## 🎯 Integration with Development Workflow

### Branch Naming Convention
```bash
# Feature branches
feature/user-authentication
feature/api-integration
feature/dark-mode-theme

# Bug fix branches
fix/login-validation-error
fix/navigation-memory-leak

# Hotfix branches
hotfix/critical-security-patch
```

### Commit Flow Example
```bash
# Start feature branch
git checkout -b feature/user-authentication

# Make atomic commits
git add src/auth/login_form.dart
git commit -m "feat(auth): add login form UI components"

git add src/auth/auth_service.dart
git commit -m "feat(auth): implement authentication service"

git add test/auth/auth_service_test.dart
git commit -m "test(auth): add unit tests for authentication service"

# Push and create PR
git push origin feature/user-authentication
```

## 📚 Tools and Resources

### Helpful Tools
- **Conventional Commits**: [conventionalcommits.org](https://www.conventionalcommits.org/)
- **Commitizen**: Interactive commit message helper
- **Git hooks**: Automate validation and testing

### IDE Integration
- **VS Code**: Git Lens extension for commit history
- **Android Studio**: Built-in Git integration
- **Command line**: Git aliases for common patterns

### Git Aliases
```bash
# Add to ~/.gitconfig
[alias]
    cm = commit -m
    ca = commit -am
    co = checkout
    br = branch
    st = status
    lg = log --oneline --graph --decorate
```

---

## 📝 Summary

Following these commit guidelines ensures:
- **Clear project history** - Easy to understand what changed and why
- **Better collaboration** - Consistent format helps team communication
- **Automated tooling** - Enables changelog generation and release automation
- **Easier debugging** - Atomic commits make it easier to identify issues
- **Professional development** - Industry-standard practices

For more information on the overall development workflow, see [Git Branching](./git-branching.md) and [Pull Requests](./pull-requests.md).
