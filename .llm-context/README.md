# LLM Context Management Guide

## Overview
This directory contains comprehensive project context and documentation to support efficient development, code review, and AI assistance for Flutter boilerplate projects. This serves as a template for any Flutter project development.

**For developer onboarding and tutorials, see [docs/](../docs/)**

## Integration with Documentation
- **Project configuration**: [project-config.md](project-config.md) - Single source of truth for project details
- **Developer guides**: [../docs/](../docs/) - Complete onboarding and development documentation
- **Cross-references**: Both systems reference shared configuration for consistency

## Directory Structure

```
.llm-context/
├── README.md                           # This file - AI context management guide
├── project-config.md                   # Central project configuration (single source of truth)
├── project/                            # Project metadata and requirements
│   ├── business-requirements.md        # Project requirements template
│   ├── technology-stack.md             # Flutter tech stack and dependencies
│   └── open-issues.md                  # Project maintenance items
├── context/                            # AI-specific context
│   └── preferences.md                  # AI assistant preferences
├── templates/                          # Reusable templates
│   ├── USAGE.md                        # Template usage guide
│   └── comprehensive-report-generator-prompt.md  # Report generation template
└── workflows/                          # Process definitions
    └── (future workflow files)         # Code review, release processes, etc.
```

## 📁 Directory Structure

### Development Guidelines
> **Note:** Development guidelines have been moved to [`docs/`](../docs/README.md) for better developer accessibility:
> - Best Practices → `docs/guides/best-practices.md`
> - Security Guide → `docs/guides/security.md`
> - Testing Strategy → `docs/guides/testing.md`
> - API Integration → `docs/guides/api-integration.md`
> - Deployment → `docs/guides/deployment.md`
> - Architecture → `docs/reference/architecture.md`
> - Coding Standards → `docs/reference/coding-standards.md`
> - Git Workflow → `docs/reference/git-workflow.md`
> - Code Review Guidelines → `docs/reference/code-review-guidelines.md`
> - Troubleshooting → `docs/reference/troubleshooting.md`
```

## How to Use This Context

### For Developers
1. **Start Here**: Read this README to understand the project structure
2. **Architecture**: Review `project/architecture.md` for system design
3. **Standards**: Follow guidelines in `development/` directory
4. **Templates**: Use templates from `templates/` directory for consistency

### For Code Reviews
1. Use `development/code-review-guidelines.md` for comprehensive review criteria
2. Apply scoring framework from the guidelines
3. Document decisions in `team/decision-log.md`
4. Use `templates/code-review-report-template.md` for assessments

### For AI Assistants
1. Reference `ai-context/preferences.md` for interaction guidelines
2. Use project context from `project/` directory for accurate assistance
3. Follow coding standards from `development/coding-standards.md`
4. Apply templates for consistent output formatting

## Maintenance
- Update documentation as the project evolves
- Review and refine guidelines quarterly
- Ensure all team members are familiar with the structure
- Keep AI context preferences current with team needs

## Quick Links
- [Architecture Overview](project/architecture.md)
- [Code Review Guidelines](development/code-review-guidelines.md)
- [Coding Standards](development/coding-standards.md)
- [Team Structure](team/team-structure.md)
- [AI Preferences](ai-context/preferences.md)
