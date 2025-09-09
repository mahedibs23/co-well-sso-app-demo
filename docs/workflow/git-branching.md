# Git Branching & Workflow

> **Cross-Reference:** This document is part of the development workflow. See also:
> - [Commits](./commits.md) - Commit message standards
> - [Pull Requests](./pull-requests.md) - Pull request creation and review process
> - [Project Configuration](../../.llm-context/project-config.md) - Project details

## Overview

This document outlines the Git workflow and branching strategy for Flutter projects using this boilerplate. Our workflow uses a custom 4-branch environment strategy with strict merge policies and automated release management.

## 🌿 Branching Strategy

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

## 🚀 Feature Development Workflow

### Starting a New Feature

#### 1. Create Feature Branch
```bash
git checkout main
git pull origin main
git checkout -b feature/OBC-123-user-authentication
```

#### 2. Development Process
- Make commits following conventional commit format
- Push regularly to remote branch
- Only merge `main` branch if needed for updates

#### 3. Feature Deployment Journey

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

#### 4. Code Review Requirements
- At least 1 reviewer for each PR
- All CI checks must pass
- Address review feedback before merge
- Use squash and merge for feature branches

#### 5. Branch Cleanup
- Delete feature branch after full deployment
- Update local repository regularly

## 🔄 Merge Conflict Resolution

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

## 🎯 Selective Feature Promotion Workflow

### Test Environment - Multiple Features
```
feature/OBC-123 → test (PR)
feature/OBC-124 → test (PR)
feature/OBC-125 → test (PR)
feature/OBC-126 → test (PR)
feature/OBC-127 → test (PR)
```
**Result**: 5 features in test environment for QA testing

### Staging Environment - Selective Promotion
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

### Production Release - Staging to Main
```
# After UAT approval of staging
staging → main (PR)
```
**Result**: All UAT-approved features deployed to production

## 🚨 Hotfix Workflow

### Critical Production Issues

#### 1. Create Hotfix Branch
```bash
git checkout main
git pull origin main
git checkout -b hotfix/OBC-789-payment-crash
```

#### 2. Fix and Test
- Implement critical fix
- Test thoroughly in local environment
- Commit with clear message

#### 3. Emergency Deployment
```bash
# Create PR: hotfix/OBC-789-payment-crash → main
gh pr create --base main --head hotfix/OBC-789-payment-crash \
  --title "fix(payment)!: resolve critical payment crash" \
  --body "Emergency fix for payment processing crash affecting all users"
```

#### 4. Cherry-pick to Other Branches
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

## 🏷 Git Tagging and Release Management

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

## 📊 Workflow Automation

### GitHub Actions Integration

#### Branch Protection Rules
```yaml
# .github/branch-protection.yml
main:
  required_status_checks:
    - flutter-test
    - flutter-analyze
    - build-android
    - build-ios
  required_pull_request_reviews:
    required_approving_review_count: 2
  restrictions:
    users: []
    teams: ["senior-developers"]

staging:
  required_status_checks:
    - flutter-test
    - flutter-analyze
  required_pull_request_reviews:
    required_approving_review_count: 1

test:
  required_status_checks:
    - flutter-test
    - flutter-analyze
  required_pull_request_reviews:
    required_approving_review_count: 1
```

#### Automated Workflows
```yaml
# .github/workflows/feature-branch.yml
name: Feature Branch CI
on:
  push:
    branches: [feature/*, bugfix/*]
  pull_request:
    branches: [dev, test, staging, main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk --debug
```

### Release Automation
```yaml
# .github/workflows/release.yml
name: Release
on:
  push:
    tags: ['prod-v*']

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build release
        run: |
          flutter build apk --release
          flutter build appbundle --release
          flutter build ios --release --no-codesign
      - name: Create GitHub Release
        uses: actions/create-release@v1
        with:
          tag_name: ${{ github.ref }}
          release_name: Release ${{ github.ref }}
          draft: false
          prerelease: false
```

## 🔧 Git Configuration

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

### Git Aliases
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
    
    # Workflow aliases
    feature = "!f() { git checkout main && git pull && git checkout -b feature/$1; }; f"
    hotfix = "!f() { git checkout main && git pull && git checkout -b hotfix/$1; }; f"
    
    # Log aliases
    lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
```

## 📈 Best Practices Summary

### Branch Management
1. **Always branch from main** for new features
2. **Follow the 4-environment flow** strictly
3. **Use selective promotion** to staging
4. **Clean up branches** after deployment
5. **Document dependencies** clearly

### Collaboration
1. **Communicate changes** that affect others
2. **Review code thoroughly** but efficiently
3. **Resolve conflicts properly** using temp branches
4. **Share knowledge** through code reviews
5. **Document decisions** in commit messages

### Release Management
1. **Plan releases** with clear scope
2. **Test thoroughly** in each environment
3. **Tag releases** consistently per environment
4. **Monitor deployments** for issues
5. **Maintain rollback capability**

---

## 📝 Summary

This 4-environment Git workflow ensures:
- **Organized development** with clear environment purposes
- **Quality control** through multi-stage testing
- **Selective feature promotion** based on QA/UAT approval
- **Quick response** to production issues via hotfixes
- **Team collaboration** with consistent practices

For detailed implementation guidance, see [Commits](./commits.md) and [Pull Requests](./pull-requests.md).
