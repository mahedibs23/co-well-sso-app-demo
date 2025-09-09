# Pull Request Guidelines

> **Cross-Reference:** This document is part of the development workflow. See also:
> - [Commits](./commits.md) - Commit message standards
> - [Git Branching](./git-branching.md) - Branching strategy and version control
> - [Code Review Guidelines](../reference/code-review-guidelines.md) - Review standards and checklists

## Overview

This guide establishes standards for creating, reviewing, and merging pull requests in the Flutter Boilerplate project to ensure code quality, maintainability, and effective team collaboration.

## 📝 PR Creation Guidelines

### Before Creating a PR

#### Pre-submission Checklist
- [ ] Code follows [coding standards](../reference/coding-standards.md)
- [ ] All tests pass locally (`flutter test`)
- [ ] Code analysis passes (`flutter analyze`)
- [ ] Code is properly formatted (`dart format`)
- [ ] Documentation is updated if needed
- [ ] Commits follow [commit guidelines](./commits.md)

#### Branch Preparation
```bash
# Ensure branch is up to date
git checkout main
git pull origin main
git checkout feature/your-feature
git rebase main

# Run final checks
flutter test
flutter analyze
dart format --set-exit-if-changed .
```

### PR Title Format

#### Standard Format
```
<type>(<scope>): <description>
```

#### Examples
```
feat(auth): implement OAuth login integration
fix(api): resolve timeout issues in user service
docs(setup): update installation guide for Flutter 3.16
refactor(ui): extract reusable button components
```

### PR Description Template

```markdown
## 📋 Summary
Brief description of what this PR accomplishes.

## 🎯 Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring

## 🔗 Related Issues
Closes #123
Fixes #456
Refs #789

## 🧪 Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

### Test Coverage
- Describe what was tested
- Include screenshots for UI changes
- Note any edge cases covered

## 📱 Screenshots (if applicable)
| Before | After |
|--------|-------|
| ![before](url) | ![after](url) |

## 🚀 Deployment Notes
- Any special deployment considerations
- Environment variable changes
- Database migrations needed
- Breaking changes and migration guide

## ✅ Checklist
- [ ] Code follows project coding standards
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added/updated and passing
- [ ] No new warnings or errors
- [ ] Backward compatibility maintained (or breaking changes documented)
```

## 👥 PR Review Process

### Review Assignment

#### Automatic Assignment
- **Small changes** (< 50 lines): 1 reviewer
- **Medium changes** (50-200 lines): 2 reviewers
- **Large changes** (> 200 lines): 2+ reviewers + architecture review

#### Reviewer Selection
- **Code owners**: Automatically assigned for specific areas
- **Domain experts**: For specialized functionality
- **Fresh eyes**: Someone unfamiliar with the code for perspective

### Review Timeline

#### Response Times
- **Initial review**: Within 24 hours
- **Follow-up reviews**: Within 8 hours
- **Urgent fixes**: Within 2 hours (hotfixes)

#### Review Priorities
1. **Critical bugs** and security fixes
2. **Blocking features** for current sprint
3. **Regular features** and improvements
4. **Documentation** and refactoring

## 🔍 Review Criteria

### Code Quality Checklist

#### Functionality
- [ ] Code does what it's supposed to do
- [ ] Edge cases are handled appropriately
- [ ] Error handling is implemented
- [ ] Performance considerations addressed

#### Design & Architecture
- [ ] Follows established patterns
- [ ] Proper separation of concerns
- [ ] Reusable components where appropriate
- [ ] No unnecessary complexity

#### Testing
- [ ] Adequate test coverage
- [ ] Tests are meaningful and effective
- [ ] Tests follow testing best practices
- [ ] No flaky or unreliable tests

#### Security
- [ ] No security vulnerabilities introduced
- [ ] Sensitive data properly handled
- [ ] Input validation implemented
- [ ] Authentication/authorization respected

#### Performance
- [ ] No performance regressions
- [ ] Efficient algorithms and data structures
- [ ] Proper resource management
- [ ] Memory leaks prevented

### Code Style Checklist
- [ ] Consistent formatting and naming
- [ ] Clear and descriptive variable/function names
- [ ] Appropriate comments and documentation
- [ ] No dead or commented-out code
- [ ] Follows Flutter/Dart conventions

## 💬 Review Communication

### Providing Feedback

#### Constructive Comments
```markdown
# Good examples
"Consider using a const constructor here for better performance"
"This could be simplified using the null-aware operator (?.)"
"Great implementation! One suggestion: extract this logic into a separate method for reusability"

# Avoid
"This is wrong"
"Bad code"
"Why did you do this?"
```

#### Comment Categories
- **🔴 Must fix**: Blocking issues that prevent merge
- **🟡 Should fix**: Important improvements that should be addressed
- **🟢 Consider**: Suggestions for improvement (non-blocking)
- **💡 Idea**: Future improvements or alternative approaches

### Responding to Feedback

#### Author Guidelines
- **Acknowledge all feedback** - Even if you disagree
- **Ask for clarification** if comments are unclear
- **Explain your reasoning** for implementation choices
- **Be open to suggestions** and alternative approaches
- **Update the PR** promptly after addressing feedback

#### Response Examples
```markdown
# Acknowledging and implementing
"Good catch! Fixed in latest commit."

# Explaining reasoning
"I chose this approach because it handles the edge case where..."

# Asking for clarification
"Could you elaborate on the performance concern here?"

# Proposing alternatives
"I see your point. What do you think about this alternative approach?"
```

## 🔄 Review Workflow

### Review States

#### Draft PR
- Work in progress, not ready for review
- Use for early feedback and collaboration
- Clearly mark as "WIP" or use GitHub draft feature

#### Ready for Review
- All pre-submission checks completed
- Author believes code is ready to merge
- Reviewers should provide thorough feedback

#### Changes Requested
- Reviewer has identified issues that must be addressed
- Author should address feedback and re-request review
- Clear communication about what was changed

#### Approved
- Reviewer believes code is ready to merge
- All concerns have been addressed
- Code meets quality standards

### Merge Strategies

#### Squash and Merge (Preferred)
- **Use for**: Feature branches with multiple commits
- **Benefits**: Clean history, single commit per feature
- **When**: Most feature development

#### Merge Commit
- **Use for**: Release branches, important milestones
- **Benefits**: Preserves branch context
- **When**: Release merges, hotfix merges

#### Rebase and Merge
- **Use for**: Small, clean commits that add value individually
- **Benefits**: Linear history without merge commits
- **When**: Well-crafted commit sequences

## 🚀 Merge Requirements

### Automated Checks
- [ ] All CI/CD pipelines pass
- [ ] Code coverage meets minimum threshold
- [ ] No merge conflicts
- [ ] Branch is up to date with target

### Manual Requirements
- [ ] Required number of approvals received
- [ ] All conversations resolved
- [ ] Breaking changes documented
- [ ] Deployment plan confirmed (if needed)

## 🔧 PR Automation

### GitHub Actions Integration

#### Automated Checks
```yaml
# .github/workflows/pr-checks.yml
name: PR Checks
on:
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
      - run: flutter build apk --debug
```

#### PR Templates
```markdown
<!-- .github/pull_request_template.md -->
## 📋 Summary
<!-- Brief description of changes -->

## 🎯 Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## ✅ Checklist
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] Code follows style guidelines
```

### Branch Protection Rules
```yaml
# Branch protection configuration
main:
  required_status_checks:
    - flutter-test
    - flutter-analyze
    - build-check
  required_pull_request_reviews:
    required_approving_review_count: 2
    dismiss_stale_reviews: true
  restrictions:
    teams: ["core-developers"]
```

## 📊 PR Metrics and Quality

### Tracking Metrics
- **Review time**: Time from PR creation to first review
- **Merge time**: Time from PR creation to merge
- **Review iterations**: Number of review cycles
- **Defect rate**: Issues found post-merge

### Quality Indicators
- **Small PRs**: Easier to review and less error-prone
- **Good descriptions**: Clear context and reasoning
- **Comprehensive tests**: Adequate coverage and quality
- **Clean commits**: Well-structured commit history

## 🎯 Best Practices Summary

### For Authors
1. **Keep PRs small** and focused
2. **Write clear descriptions** with context
3. **Test thoroughly** before submitting
4. **Respond promptly** to feedback
5. **Self-review** before requesting review

### For Reviewers
1. **Review promptly** within SLA
2. **Provide constructive** feedback
3. **Focus on important** issues
4. **Explain reasoning** behind suggestions
5. **Approve when ready** - don't nitpick

### For Teams
1. **Establish clear** review standards
2. **Automate what possible** with CI/CD
3. **Track metrics** for improvement
4. **Foster positive** review culture
5. **Learn from** post-merge issues

---

## 📝 Summary

Effective pull request management ensures:
- **High code quality** through thorough review
- **Knowledge sharing** across the team
- **Consistent standards** and practices
- **Faster delivery** with fewer bugs
- **Better collaboration** and communication

For detailed implementation guidance, see [Git Branching](./git-branching.md) and [Commits](./commits.md).
