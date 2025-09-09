# Flutter Boilerplate - Git Workflow

## Overview
This document outlines the Git workflow and branching strategy for Flutter projects using this boilerplate. Our workflow uses a custom 4-branch environment strategy with strict merge policies and automated release management.

## Branching Strategy

### Environment Branches (Protected)

#### Branch Hierarchy and Feature Flow
```
MAIN ← STAGING ← feature branches (selective)
     ↑
     TEST ← feature branches (individual PRs)
     ↑
     DEV ← feature branches (PR/local merge)
     ↑
 feature branches (created from MAIN)
```

**Flow Rules**:
- ✅ **Feature Creation**: Always from `MAIN` branch
- ✅ **Dev Integration**: Feature → DEV (PR or local merge)
- ✅ **Test Deployment**: Feature → TEST (individual PRs)
- ✅ **Staging Promotion**: Feature → STAGING (selective individual PRs)
- ✅ **Production Release**: STAGING → MAIN (PR after UAT approval)
- ✅ **Sync Allowed**: `MAIN` → feature branches for alignment

#### `main` (Production Environment)
- **Purpose**: Production-ready Flutter code deployed to app stores
- **Protection**: Protected branch, requires PR with at least 1 reviewer, no force updates
- **Deployment**: Automatically builds and deploys to production (App Store/Play Store)
- **Merge Sources**: 
  - From `staging` branch via PR (after UAT approval)
  - To feature branches for alignment
- **Naming**: Always `main`
- **Access**: Only release managers can merge

#### `staging` (Staging Environment)
- **Purpose**: Pre-production Flutter testing and UAT (immediate mirror before production)
- **Protection**: Protected branch, requires PR with at least 1 reviewer, no force updates
- **Deployment**: Automatically builds staging flavor for customer UAT
- **Merge Sources**: 
  - From feature branches via individual PRs (selective promotion)
  - To feature branches for alignment
- **Naming**: Always `staging`
- **Access**: Senior developers and above can merge
- **Note**: Only UAT-approved features proceed to main

#### `test` (Testing Environment)
- **Purpose**: Internal QA testing and Flutter widget/integration testing
- **Protection**: Protected branch, requires PR with at least 1 reviewer, no force updates
- **Deployment**: Automatically builds test flavor for internal QA
- **Merge Sources**: 
  - From feature branches via individual PRs
  - To feature branches for alignment
- **Naming**: Always `test`
- **Access**: All developers can create PRs
- **Note**: Multiple features tested together, selective promotion to staging

#### `dev` (Development Environment)
- **Purpose**: Developer team integration and Flutter development experimentation
- **Protection**: Unprotected branch, allows direct pushes and force updates
- **Deployment**: Automatically builds dev flavor for development testing
- **Merge Sources**: 
  - From feature branches via PR or local merge
  - To feature branches for alignment
- **Naming**: Always `dev`
- **Access**: All developers can push directly
- **Note**: Experimental environment for Flutter development team

### Working Branches

#### Feature Branches
- **Purpose**: Develop new features
- **Branch From**: `main` branch only
- **Merge To**: 
  - `dev` (PR or local merge for developer testing)
  - `test` (individual PR for QA testing)
  - `staging` (individual PR for UAT - selective promotion)
  - `main` (via staging branch after UAT approval)
- **Naming Convention**: `feature/[ticket-id]-[brief-description]`
- **Examples**: 
  - `feature/OBC-123-user-authentication`
  - `feature/OBC-456-payment-integration`
- **Lifetime**: Until feature is complete and deployed to production
- **Sync Allowed**: `main` branch can be merged into feature branches for alignment
- **Feedback Handling**: All fixes applied within the same feature branch

#### Bugfix Branches
- **Purpose**: Fix bugs and issues
- **Branch From**: `main` branch only
- **Merge To**: Same flow as feature branches
- **Naming Convention**: `bugfix/[ticket-id]-[brief-description]`
- **Examples**: 
  - `bugfix/OBC-234-ui-alignment`
  - `bugfix/OBC-567-data-validation`
- **Lifetime**: Until bug is fixed and deployed to production
- **Sync Allowed**: `main` branch can be merged into bugfix branches for alignment

#### Hotfix Branches
- **Purpose**: Critical fixes for production issues
- **Branch From**: `main` branch
- **Merge To**: Directly to `main`, then cherry-pick to other branches
- **Naming Convention**: `hotfix/[ticket-id]-[brief-description]`
- **Examples**: 
  - `hotfix/OBC-789-payment-crash`
  - `hotfix/OBC-101-login-security`
- **Lifetime**: Until hotfix is deployed
- **Priority**: Highest priority, can bypass normal flow for critical issues

### Dependent Feature Branches

#### Feature Dependency Management
When feature B depends on feature A that hasn't been merged to `main`:

1. **Allowed Dependency**: Feature A can be merged into feature B
2. **Release Requirement**: Both features A and B must be released together
3. **Coordination**: Coordinate with team lead before creating dependencies
4. **Documentation**: Document dependencies in PR description and Jira tickets

**Example Workflow**:
```bash
# Feature A is in development
git checkout -b feature/OBC-100-user-profile main

# Feature B depends on Feature A
git checkout -b feature/OBC-101-profile-settings main
git merge feature/OBC-100-user-profile  # Allowed dependency

# Both features must be released together through all environments
```

## Pull Request Title Conventions

### PR Title Format for Changelog Generation
PR titles must follow conventional commit format with Jira ticket number as scope to enable automatic changelog generation:

```
<type>(JIRA-TICKET): <description>
```

#### Types
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, missing semicolons, etc.)
- **refactor**: Code refactoring without feature changes
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **chore**: Maintenance tasks, dependency updates
- **ci**: CI/CD pipeline changes
- **build**: Build system changes

#### Scopes (Optional)
- **auth**: Authentication related
- **payment**: Payment functionality
- **ui**: User interface
- **api**: API integration
- **db**: Database related
- **maps**: Maps and location
- **push**: Push notifications

#### Examples
```
feat(OBC-123): add biometric login support
fix(OBC-456): resolve crash on payment confirmation
docs(OBC-789): update authentication endpoint documentation
refactor(OBC-234): improve ride booking flow performance
chore(OBC-567): update Firebase SDK to v32.0.0
```

#### Breaking Changes
For breaking changes, add `!` after the type:
```
feat(OBC-890)!: change user authentication flow
```

## Commit Message Standards

### Conventional Commits Format
```
<type>(JIRA-TICKET): <description>

[optional body]

[optional footer(s)]
```

### Commit Types
- **feat**: New feature implementation
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, missing semi-colons, etc.)
- **refactor**: Code refactoring without feature changes
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **chore**: Build process or auxiliary tool changes
- **ci**: CI/CD configuration changes

### Examples
```bash
feat(OBC-123): add real-time driver tracking

Implement WebSocket connection for live driver location updates.
Includes error handling and reconnection logic.

Closes #OBC-123

fix(OBC-456): resolve credit card validation issue

The credit card number validation was incorrectly rejecting valid
Visa cards starting with 4000. Updated regex pattern to include
all valid Visa prefixes.

Fixes #OBC-456

docs(OBC-789): update authentication documentation

Add examples for JWT token refresh and error handling scenarios.

chore(OBC-234): update Firebase SDK to latest stable versions
Includes migration guide for breaking changes.
```

## Merge Conflict Resolution

### Standard Conflict Resolution Process

**IMPORTANT**: Never merge target branch into feature branch to resolve conflicts.
**ALLOWED**: Only left-to-right merges (MAIN → STAGING → TEST → DEV) into feature branches.

#### Step-by-Step Process

1. **Identify Conflict**: PR shows merge conflicts with target branch

2. **Create Temporary Branch**:
   ```bash
   # Create temp branch from target branch
   git checkout [target-branch]  # e.g., dev, test, staging, main
   git pull origin [target-branch]
   git checkout -b merge-conflict-resolve/[target]/[feature-name]
   
   # Example:
   git checkout test
   git pull origin test
   git checkout -b merge-conflict-resolve/test/feat123
   ```

3. **Merge Feature Branch Locally**:
   ```bash
   # Merge feature branch into temp branch
   git merge feature/OBC-123-feat123
   # Resolve conflicts in IDE
   git add .
   git commit -m "resolve: merge conflicts for feat123 into test"
   ```

4. **Create New PR**:
   ```bash
   git push origin merge-conflict-resolve/test/feat123
   # Create PR from temp branch to target branch
   gh pr create --base test --head merge-conflict-resolve/test/feat123 \
     --title "resolve: merge conflicts for feat123 into test" \
     --body "Resolving merge conflicts for feature OBC-123 deployment to test"
   ```

5. **Clean Up**:
   ```bash
   # After PR is merged, delete temp branch
   git branch -d merge-conflict-resolve/test/feat123
   git push origin --delete merge-conflict-resolve/test/feat123
   ```

### Allowed Conflict Resolution with Left-to-Right Sync

#### Sync from Higher Environment to Feature Branch
```bash
# If feature branch needs updates from main
git checkout feature/OBC-123-auth
git merge main  # Allowed: left-to-right merge
git push origin feature/OBC-123-auth

# If feature branch needs updates from staging
git checkout feature/OBC-123-auth
git merge staging  # Allowed: left-to-right merge
git push origin feature/OBC-123-auth
```

### Conflict Resolution Examples

#### Example 1: Feature to Dev Conflict
```bash
# Conflict when merging feature/OBC-123-auth to dev
git checkout dev
git pull origin dev
git checkout -b merge-conflict-resolve/dev/auth123
git merge feature/OBC-123-auth
# Resolve conflicts
git add .
git commit -m "resolve: merge conflicts for auth feature into dev"
git push origin merge-conflict-resolve/dev/auth123
# Create PR: merge-conflict-resolve/dev/auth123 → dev
```

#### Example 2: Feature to Test Conflict
```bash
# Conflict when merging feature/OBC-123-auth to test
git checkout test
git pull origin test
git checkout -b merge-conflict-resolve/test/auth123
git merge feature/OBC-123-auth
# Resolve conflicts
git add .
git commit -m "resolve: merge conflicts for auth feature into test"
git push origin merge-conflict-resolve/test/auth123
# Create PR: merge-conflict-resolve/test/auth123 → test
```

#### Example 3: Left-to-Right Sync Conflict
```bash
# Conflict when syncing main to staging
git checkout staging
git pull origin staging
git checkout -b merge-conflict-resolve/staging/main-sync
git merge main
# Resolve conflicts
git add .
git commit -m "resolve: merge conflicts for main sync to staging"
git push origin merge-conflict-resolve/staging/main-sync
# Create PR: merge-conflict-resolve/staging/main-sync → staging
```

## Workflow Processes

### Feature Development Workflow

1. **Create Feature Branch**
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/OBC-123-user-authentication
   ```

2. **Development**
   - Make commits following conventional commit format
   - Push regularly to remote branch
   - Only merge `main` branch if needed for updates

3. **Feature Deployment Journey**
   
   **Step 1: Deploy to Dev** (Developer Testing)
   ```bash
   # Option A: Create PR
   gh pr create --base dev --head feature/OBC-123-auth \
     --title "feat(OBC-123): add user authentication system" \
     --body "Deploy authentication feature to development environment"
   
   # Option B: Local merge (dev is unprotected)
   git checkout dev
   git merge feature/OBC-123-auth
   git push origin dev
   ```
   
   **Step 2: Deploy to Test** (Internal QA Testing)
   ```bash
   # After dev testing is complete
   gh pr create --base test --head feature/OBC-123-auth \
     --title "feat(OBC-123): add user authentication system" \
     --body "Deploy authentication feature to test environment for QA"
   ```
   
   **Step 3: Selective Promotion to Staging** (UAT)
   ```bash
   # Only after QA approval - selective promotion
   gh pr create --base staging --head feature/OBC-123-auth \
     --title "feat(OBC-123): add user authentication system" \
     --body "Deploy QA-approved authentication feature to staging for UAT"
   ```
   
   **Step 4: Production Release** (via Staging)
   ```bash
   # After UAT approval - staging to main
   gh pr create --base main --head staging \
     --title "release(OBC-RELEASE): deploy UAT-approved features to production" \
     --body "Production deployment of UAT-approved features from staging"
   ```

4. **Code Review Requirements**
   - At least 1 reviewer for each PR
   - All CI checks must pass
   - Address review feedback before merge
   - Use squash and merge for feature branches

5. **Branch Cleanup**
   - Delete feature branch after full deployment
   - Update local repository regularly

### Feature Branch Alignment Workflow

#### Main to Feature Branch Sync (Allowed)
```
MAIN → feature branches
```

**Purpose**: Keep feature branches aligned with latest production code

#### Alignment Commands

**Sync Main to Feature Branch**:
```bash
# When feature branch lags behind main
git checkout feature/OBC-123-auth
git merge main  # Always allowed for alignment
git push origin feature/OBC-123-auth
```

**Handle Feedback in Feature Branch**:
```bash
# Apply feedback fixes within the same feature branch
git checkout feature/OBC-123-auth
# Make fixes
git add .
git commit -m "fix(auth): address QA feedback on validation"
git push origin feature/OBC-123-auth
# Follow the same journey: dev → test → staging → main
```

### Selective Feature Promotion Workflow

#### Test Environment - Multiple Features
```
feature/OBC-123 → test (PR)
feature/OBC-124 → test (PR)
feature/OBC-125 → test (PR)
feature/OBC-126 → test (PR)
feature/OBC-127 → test (PR)
```
**Result**: 5 features in test environment for QA testing

#### Staging Environment - Selective Promotion
```
# QA approves only 3 features
feature/OBC-123 → staging (PR) ✅ QA Approved
feature/OBC-124 → staging (PR) ✅ QA Approved  
feature/OBC-126 → staging (PR) ✅ QA Approved

# Features not promoted (need more work)
feature/OBC-125 → ❌ QA Feedback
feature/OBC-127 → ❌ QA Feedback
```
**Result**: Only 3 QA-approved features in staging for UAT

#### Production Release - Staging to Main
```
# After UAT approval of staging
staging → main (PR)
```
**Result**: All UAT-approved features deployed to production

#### Example Selective Promotion
```bash
# Deploy only QA-approved features to staging
gh pr create --base staging --head feature/OBC-123-auth \
  --title "feat(OBC-123): add user authentication system" \
  --body "QA-approved: Deploy authentication feature to staging for UAT"

gh pr create --base staging --head feature/OBC-124-payment \
  --title "feat(OBC-124): add payment processing" \
  --body "QA-approved: Deploy payment feature to staging for UAT"

gh pr create --base staging --head feature/OBC-126-profile \
  --title "feat(OBC-126): add user profile management" \
  --body "QA-approved: Deploy profile feature to staging for UAT"

# Features OBC-125 and OBC-127 remain in test for further work
```

### Hotfix Workflow

#### Critical Production Issues

1. **Create Hotfix Branch**
   ```bash
   git checkout main
   git pull origin main
   git checkout -b hotfix/OBC-789-payment-crash
   ```

2. **Fix and Test**
   - Implement critical fix
   - Test thoroughly in local environment
   - Commit with clear message

3. **Emergency Deployment**
   ```bash
   # Create PR: hotfix/OBC-789-payment-crash → main
   gh pr create --base main --head hotfix/OBC-789-payment-crash \
     --title "fix(payment)!: resolve critical payment crash" \
     --body "Emergency fix for payment processing crash affecting all users"
   ```

4. **Cherry-pick to Other Branches**
   ```bash
   # After hotfix is deployed to production
   git checkout staging
   git cherry-pick [hotfix-commit-hash]
   git push origin staging
   
   git checkout test
   git cherry-pick [hotfix-commit-hash]
   git push origin test
   
   git checkout dev
   git cherry-pick [hotfix-commit-hash]
   git push origin dev
   ```

## Git Tagging and Release Management

### Environment-Specific Tagging Strategy

#### Tag Naming Convention
```
[environment]-v[MAJOR].[MINOR].[PATCH][-prerelease]
```

#### Environment Tags
- **dev-v1.2.3**: Deployed to development environment
- **test-v1.2.3**: Deployed to test environment  
- **staging-v1.2.3**: Deployed to staging environment
- **prod-v1.2.3**: Deployed to production environment

#### Semantic Versioning
- **MAJOR**: Breaking changes or major new features
- **MINOR**: New features, backward compatible
- **PATCH**: Bug fixes, backward compatible

#### Pre-release Tags
- **Alpha**: `dev-v1.2.0-alpha.1` (early development)
- **Beta**: `test-v1.2.0-beta.1` (feature complete, testing)
- **RC**: `staging-v1.2.0-rc.1` (release candidate)

### Automated Release Process

#### Development Environment Release
```bash
# After merging feature to dev
git checkout dev
git pull origin dev
git tag -a dev-v1.2.3 -m "Deploy v1.2.3 to development"
git push origin dev-v1.2.3
```

#### Test Environment Release
```bash
# After promoting dev to test
git checkout test
git pull origin test
git tag -a test-v1.2.3 -m "Deploy v1.2.3 to test environment"
git push origin test-v1.2.3
```

#### Staging Environment Release
```bash
# After promoting test to staging
git checkout staging
git pull origin staging
git tag -a staging-v1.2.3 -m "Deploy v1.2.3 to staging environment"
git push origin staging-v1.2.3
```

#### Production Environment Release
```bash
# After promoting staging to main
git checkout main
git pull origin main
git tag -a prod-v1.2.3 -m "Deploy v1.2.3 to production"
git push origin prod-v1.2.3
```

### GitHub Release Management

#### Automated Changelog Generation

1. **Configure Release Settings**
   - Enable "Generate release notes automatically"
   - Configure PR title patterns for categorization
   - Set up release templates

2. **Release Categories** (based on PR titles)
   ```yaml
   # .github/release.yml
   changelog:
     categories:
       - title: 🚀 New Features
         labels: ["feat"]
       - title: 🐛 Bug Fixes
         labels: ["fix"]
       - title: 📚 Documentation
         labels: ["docs"]
       - title: 🔧 Maintenance
         labels: ["chore"]
   ```

3. **Create Release**
   ```bash
   # After creating production tag
   gh release create prod-v1.2.3 \
     --title "Production Release v1.2.3" \
     --generate-notes \
     --target main
   ```

#### Release Template
```markdown
## 🚀 Release v1.2.3

### Environment Deployment Status
- ✅ Development: `dev-v1.2.3`
- ✅ Test: `test-v1.2.3`
- ✅ Staging: `staging-v1.2.3`
- ✅ Production: `prod-v1.2.3`

### What's Changed
<!-- Auto-generated from PR titles -->

### Deployment Notes
- Database migrations: [Yes/No]
- Configuration changes: [Yes/No]
- Breaking changes: [Yes/No]

### Rollback Plan
- Previous stable version: `prod-v1.2.2`
- Rollback command: `git checkout prod-v1.2.2`

**Full Changelog**: https://github.com/org/repo/compare/prod-v1.2.2...prod-v1.2.3
```

### Release Tracking

#### Environment Release History
```bash
# View releases for specific environment
git tag -l "prod-v*" --sort=-version:refname
git tag -l "staging-v*" --sort=-version:refname
git tag -l "test-v*" --sort=-version:refname
git tag -l "dev-v*" --sort=-version:refname
```

#### Release Comparison
```bash
# Compare releases between environments
git log --oneline staging-v1.2.3..prod-v1.2.2
git diff staging-v1.2.3 prod-v1.2.2
```
   git push origin feature/new-feature-name
   ```

3. **Keep Branch Updated**
   ```bash
   # Regularly sync with develop
   git checkout develop
   git pull origin develop
   git checkout feature/new-feature-name
   git rebase develop
   ```

4. **Create Pull Request**
   - Create PR from feature branch to `develop`
   - Fill out PR template completely
   - Request reviews from team members
   - Ensure CI checks pass

5. **Merge and Cleanup**
   ```bash
   # After PR approval and merge
   git checkout develop
   git pull origin develop
   git branch -d feature/new-feature-name
   git push origin --delete feature/new-feature-name
   ```

### Release Process
1. **Create Release Branch**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b release/v3.1.4
   ```

2. **Release Preparation**
   ```bash
   # Update version numbers
   # Update changelog
   # Final testing and bug fixes
   git commit -m "chore(release): prepare v3.1.4 release"
   ```

3. **Merge to Main**
   ```bash
   # Create PR from release branch to main
   # After approval, merge and tag
   git checkout main
   git pull origin main
   git tag -a v3.1.4 -m "Release version 3.1.4"
   git push origin v3.1.4
   ```

4. **Back-merge to Develop**
   ```bash
   git checkout develop
   git merge main
   git push origin develop
   ```

### Hotfix Process
1. **Create Hotfix Branch**
   ```bash
   git checkout main
   git pull origin main
   git checkout -b hotfix/critical-fix
   ```

2. **Implement Fix**
   ```bash
   # Make minimal changes to fix critical issue
   git commit -m "fix(critical): resolve production crash"
   ```

3. **Merge to Main and Develop**
   ```bash
   # Merge to main first
   git checkout main
   git merge hotfix/critical-fix
   git tag -a v3.1.3-hotfix.1 -m "Hotfix v3.1.3-hotfix.1"
   git push origin main
   git push origin v3.1.3-hotfix.1
   
   # Then merge to develop
   git checkout develop
   git merge hotfix/critical-fix
   git push origin develop
   ```

## Pull Request Guidelines

### PR Template
```markdown
## Description
Brief description of changes made.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed
- [ ] All tests passing

## Screenshots (if applicable)
Include screenshots of UI changes.

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Code is commented where necessary
- [ ] Documentation updated
- [ ] No new warnings introduced

## Related Issues
Closes #OBHAI-123
Related to #OBHAI-456
```

### Review Process
1. **Author Responsibilities**
   - Complete self-review before requesting reviews
   - Ensure CI checks pass
   - Respond to review comments promptly
   - Update PR based on feedback

2. **Reviewer Responsibilities**
   - Review within 24 hours
   - Provide constructive feedback
   - Test changes locally if needed
   - Approve only when satisfied with quality

3. **Merge Requirements**
   - At least 2 approvals for main branch
   - At least 1 approval for develop branch
   - All CI checks must pass
   - No merge conflicts

## Git Configuration

### Global Configuration
```bash
# Set up user information
git config --global user.name "Your Name"
git config --global user.email "your.email@company.com"

# Set up default branch name
git config --global init.defaultBranch main

# Set up pull strategy
git config --global pull.rebase true

# Set up push strategy
git config --global push.default simple
```

### Repository Configuration
```bash
# Set up commit template
git config commit.template .gitmessage

# Set up hooks
git config core.hooksPath .githooks
```

### Commit Message Template
```
# .gitmessage
# <type>[optional scope]: <description>
#
# [optional body]
#
# [optional footer(s)]
#
# Types: feat, fix, docs, style, refactor, perf, test, chore, ci
# Scope: component or area affected (optional)
# Description: imperative, present tense, lowercase, no period
#
# Body: explain what and why vs. how (optional)
#
# Footer: reference issues and breaking changes (optional)
```

## Git Hooks

### Pre-commit Hook
```bash
#!/bin/sh
# .githooks/pre-commit

echo "Running pre-commit checks..."

# Run ktlint
./gradlew ktlintCheck
if [ $? -ne 0 ]; then
    echo "❌ ktlint check failed. Please fix formatting issues."
    exit 1
fi

# Run unit tests
./gradlew testDebugUnitTest
if [ $? -ne 0 ]; then
    echo "❌ Unit tests failed. Please fix failing tests."
    exit 1
fi

echo "✅ Pre-commit checks passed."
```

### Commit Message Hook
```bash
#!/bin/sh
# .githooks/commit-msg

commit_regex='^(feat|fix|docs|style|refactor|perf|test|chore|ci)(\(.+\))?: .{1,50}'

if ! grep -qE "$commit_regex" "$1"; then
    echo "❌ Invalid commit message format."
    echo "Format: <type>[optional scope]: <description>"
    echo "Example: feat(auth): add biometric login"
    exit 1
fi

echo "✅ Commit message format is valid."
```

## Branch Protection Rules

### Main Branch Protection
- Require pull request reviews (2 reviewers)
- Dismiss stale reviews when new commits are pushed
- Require status checks to pass before merging
- Require branches to be up to date before merging
- Restrict pushes that create files larger than 100MB
- Restrict force pushes

### Develop Branch Protection
- Require pull request reviews (1 reviewer)
- Require status checks to pass before merging
- Allow force pushes by administrators only

## Release Management

### Version Numbering
Follow Semantic Versioning (SemVer): `MAJOR.MINOR.PATCH`

- **MAJOR**: Incompatible API changes
- **MINOR**: Backward-compatible functionality additions
- **PATCH**: Backward-compatible bug fixes

### Tagging Strategy
```bash
# Release tags
v3.1.4
v3.2.0
v4.0.0

# Pre-release tags
v3.2.0-alpha.1
v3.2.0-beta.2
v3.2.0-rc.1

# Hotfix tags
v3.1.4-hotfix.1
```

### Changelog Maintenance
```markdown
# Changelog

## [3.1.4] - 2024-01-15

### Added
- Real-time driver tracking feature
- Biometric authentication support
- Dark mode theme option

### Changed
- Improved location accuracy algorithm
- Updated payment gateway integration
- Enhanced error handling for network issues

### Fixed
- Resolved crash when GPS is disabled
- Fixed payment processing timeout issue
- Corrected ride history sorting

### Security
- Updated encryption for stored credentials
- Enhanced API request signing
```

## Conflict Resolution

### Merge Conflicts
```bash
# When conflicts occur during merge/rebase
git status  # Check conflicted files

# Edit files to resolve conflicts
# Look for conflict markers: <<<<<<<, =======, >>>>>>>

# After resolving conflicts
git add resolved-file.kt
git commit -m "resolve: merge conflict in feature branch"

# Continue rebase if applicable
git rebase --continue
```

### Best Practices for Avoiding Conflicts
- Keep feature branches small and focused
- Regularly sync with develop branch
- Communicate with team about overlapping work
- Use atomic commits for easier conflict resolution

## Git Aliases

### Useful Aliases
```bash
# Add to ~/.gitconfig
[alias]
    co = checkout
    br = branch
    ci = commit
    st = status
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = !gitk
    
    # Pretty log
    lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
    
    # Show files in last commit
    dl = "!git ll -1"
    
    # Show diff of last commit
    dlc = diff --cached HEAD^
    
    # Find a file path in codebase
    f = "!git ls-files | grep -i"
    
    # Search for a string in codebase
    grep = grep -Ii
    
    # List aliases
    la = "!git config -l | grep alias | cut -c 7-"
```

## Troubleshooting

### Common Issues

#### Large File Issues
```bash
# Remove large files from history
git filter-branch --force --index-filter \
'git rm --cached --ignore-unmatch path/to/large/file' \
--prune-empty --tag-name-filter cat -- --all
```

#### Accidental Commits
```bash
# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Amend last commit
git commit --amend -m "Updated commit message"
```

#### Branch Recovery
```bash
# Recover deleted branch
git reflog
git checkout -b recovered-branch <commit-hash>

# Recover lost commits
git fsck --lost-found
```

## Team Collaboration

### Communication
- Use descriptive branch names
- Write clear commit messages
- Comment on PRs constructively
- Notify team of breaking changes
- Share knowledge through code reviews

### Code Ownership
- Feature branches owned by creator
- Shared responsibility for develop branch
- Release manager owns release branches
- Senior developers handle hotfixes

### Conflict Resolution
- Discuss architectural changes before implementation
- Use pair programming for complex features
- Regular team sync meetings
- Document decisions in commit messages
