# Comprehensive Project Report Generator - Reusable Prompt

## Overview
This prompt template generates comprehensive project reports in both Markdown and HTML formats, following the exact structure and styling used in the Obhai Android Customer app analysis. It creates professional reports with compliance analysis, code quality assessment, and implementation planning.

## How to Use This Prompt

### Step 1: Copy and Customize
Copy this entire prompt and replace the placeholder values with your specific project details:
- `[PROJECT_NAME]` - Your project name
- `[PROJECT_VERSION]` - Current version number
- `[TECHNOLOGY_STACK]` - Your tech stack (Android/Kotlin, iOS/Swift, React Native, Flutter, etc.)
- `[COMPLIANCE_TARGET]` - Target compliance (Play Store, App Store, GDPR, SOX, etc.)
- `[REPORT_DATE]` - Current date
- `[PROJECT_PATH]` - Full path to your project directory

### Step 2: Execute with AI Assistant
Paste the customized prompt to your AI assistant to automatically generate both Markdown and HTML reports.

---

## THE REUSABLE PROMPT

```
I need you to create a comprehensive project report for my software project. Generate both Markdown and HTML versions following the exact format and structure shown in the examples.

## PROJECT CONTEXT
- **Project Name**: Flutter Boilerplate
- **Project Version**: [PROJECT_VERSION]
- **Technology Stack**: Flutter/Dart, MVVM Clean Architecture, Firebase, Custom DI
- **Compliance Target**: Play Store, App Store, Mobile Security Best Practices
- **Report Date**: [REPORT_DATE]
- **Project Path**: [PROJECT_PATH]

## REQUIRED DELIVERABLES

### 1. Create Reports Directory
Create a `reports/` directory in the project root with these exact files:
- `comprehensive-project-report.md`
- `comprehensive-project-report.html`

### 2. Markdown Report Structure
Create a comprehensive Markdown report with these EXACT sections:

#### Header Section
```markdown
# [PROJECT_NAME] - Comprehensive Project Report

**Project:** [PROJECT_NAME]  
**Version:** [PROJECT_VERSION]  
**Report Date:** [REPORT_DATE]  
**Focus:** [COMPLIANCE_TARGET] + Code Quality Assessment  

---
```

#### Required Sections (in this exact order):
1. **Executive Summary**
   - Key findings in bullet points
   - Timeline overview with single developer effort
   - Critical decisions and trade-offs
   - Success metrics summary

2. **🚨 IMMEDIATE PRIORITY: [COMPLIANCE_TARGET] (X weeks)**
   - Mandatory compliance tasks table
   - NOT Required for compliance table
   - Risk assessment with color coding

3. **Code Quality Assessment**
   - Overall scores table with weighted scoring:
     - Architecture (25%)
     - Code Quality (20%) 
     - Performance (15%)
     - Security (15%)
     - Testing (10%)
     - Dependencies (10%)
     - Documentation (5%)
   - Critical issues identified by category

4. **Open Issues Analysis** (if `.llm-context/project/open-issues.md` exists)
   - High priority customer/user issues
   - Detailed analysis with root causes
   - Solution approaches
   - Single developer effort estimates

5. **Detailed Compliance Analysis**
   - Specific compliance requirements
   - Current vs required state
   - Breaking changes to address

6. **Implementation Timeline**
   - Phase 1: Compliance (weeks breakdown)
   - Phase 2: Critical issues resolution
   - Phase 3: Code quality improvements
   - Phase 4: Optional enhancements

7. **Risk Assessment**
   - High-risk areas identification
   - Mitigation strategies

8. **Resource Requirements & Timeline**
   - Single developer effort estimates
   - Timeline options (compliance-only, incremental, full)

9. **Success Metrics**
   - Compliance targets
   - Code quality targets

10. **Recommendations**
    - Immediate actions (this week)
    - Strategic decisions
    - Long-term planning

11. **Next Steps Checklist**
    - Weekly breakdown with checkboxes

12. **Appendix: Technical Details**
    - File structure analysis
    - Key dependencies
    - Configuration details

### 3. HTML Report Requirements
Generate an HTML version with EXACTLY this structure and styling:

#### HTML Template Structure:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>[PROJECT_NAME] - Comprehensive Project Report</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Noto Sans', Helvetica, Arial, sans-serif;
            line-height: 1.6;
            color: #24292f;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            background-color: #ffffff;
        }
        
        h1, h2, h3, h4, h5, h6 {
            margin-top: 24px;
            margin-bottom: 16px;
            font-weight: 600;
            line-height: 1.25;
        }
        
        h1 {
            font-size: 2em;
            border-bottom: 1px solid #d0d7de;
            padding-bottom: 0.3em;
        }
        
        h2 {
            font-size: 1.5em;
            border-bottom: 1px solid #d0d7de;
            padding-bottom: 0.3em;
        }
        
        h3 {
            font-size: 1.25em;
        }
        
        table {
            border-collapse: collapse;
            width: 100%;
            margin: 16px 0;
        }
        
        th, td {
            border: 1px solid #d0d7de;
            padding: 6px 13px;
            text-align: left;
        }
        
        th {
            background-color: #f6f8fa;
            font-weight: 600;
        }
        
        tr:nth-child(2n) {
            background-color: #f6f8fa;
        }
        
        code {
            background-color: rgba(175, 184, 193, 0.2);
            padding: 0.2em 0.4em;
            border-radius: 6px;
            font-size: 85%;
        }
        
        pre {
            background-color: #f6f8fa;
            border-radius: 6px;
            padding: 16px;
            overflow: auto;
            font-size: 85%;
            line-height: 1.45;
        }
        
        .priority-critical { 
            background-color: #ffebee; 
            border-left: 4px solid #d32f2f; 
            padding: 12px; 
            margin: 8px 0;
        }
        
        .priority-high { 
            background-color: #fff3e0; 
            border-left: 4px solid #f57c00; 
            padding: 12px; 
            margin: 8px 0;
        }
        
        .priority-medium { 
            background-color: #fffbf0; 
            border-left: 4px solid #fbc02d; 
            padding: 12px; 
            margin: 8px 0;
        }
        
        .priority-low { 
            background-color: #f1f8e9; 
            border-left: 4px solid #689f38; 
            padding: 12px; 
            margin: 8px 0;
        }
        
        .risk-high { color: #d32f2f; font-weight: bold; }
        .risk-medium { color: #f57c00; font-weight: bold; }
        .risk-low { color: #689f38; font-weight: bold; }
        .status-done { color: #689f38; font-weight: bold; }
        .status-required { color: #d32f2f; font-weight: bold; }
        .status-optional { color: #757575; font-style: italic; }
        
        .timeline-box {
            background-color: #f6f8fa;
            border: 1px solid #d0d7de;
            border-radius: 6px;
            padding: 16px;
            margin: 16px 0;
        }
        
        .metadata {
            background-color: #f6f8fa;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        
        .executive-summary {
            font-size: 1.1em;
            background-color: #e8f5e8;
            border: 2px solid #689f38;
            border-radius: 8px;
            padding: 20px;
            margin: 20px 0;
        }
        
        .score-critical { background-color: #ffebee; color: #d32f2f; font-weight: bold; }
        .score-warning { background-color: #fff3e0; color: #f57c00; font-weight: bold; }
        .score-good { background-color: #f1f8e9; color: #689f38; font-weight: bold; }
        
        .checkbox {
            margin-right: 8px;
        }
        
        ul, ol {
            padding-left: 30px;
        }
        
        li {
            margin: 4px 0;
        }
        
        .nav-menu {
            background-color: #f6f8fa;
            border: 1px solid #d0d7de;
            border-radius: 6px;
            padding: 16px;
            margin: 20px 0;
        }
        
        .nav-menu ul {
            list-style: none;
            padding-left: 0;
        }
        
        .nav-menu li {
            margin: 8px 0;
        }
        
        .nav-menu a {
            text-decoration: none;
            color: #0969da;
        }
        
        .nav-menu a:hover {
            text-decoration: underline;
        }
        
        .budget-highlight {
            background-color: #e8f5e8;
            border: 2px solid #689f38;
            border-radius: 8px;
            padding: 16px;
            margin: 16px 0;
            text-align: center;
            font-weight: bold;
            font-size: 1.1em;
        }
    </style>
</head>
<body>

<h1>[PROJECT_NAME] - Comprehensive Project Report</h1>

<div class="metadata">
    <strong>Project:</strong> [PROJECT_NAME]<br>
    <strong>Version:</strong> [PROJECT_VERSION]<br>
    <strong>Report Date:</strong> [REPORT_DATE]<br>
    <strong>Focus:</strong> [COMPLIANCE_TARGET] + Code Quality Assessment
</div>

<div class="nav-menu">
    <h3>Quick Navigation</h3>
    <ul>
        <li><a href="#executive-summary">Executive Summary</a></li>
        <li><a href="#compliance">🚨 [COMPLIANCE_TARGET] (Priority)</a></li>
        <li><a href="#code-quality">Code Quality Assessment</a></li>
        <li><a href="#open-issues">Open Issues Analysis</a></li>
        <li><a href="#implementation-timeline">Implementation Timeline</a></li>
        <li><a href="#budget-resources">Budget & Resources</a></li>
        <li><a href="#recommendations">Recommendations</a></li>
    </ul>
</div>

<div id="executive-summary" class="executive-summary">
    <h2>Executive Summary</h2>
    <!-- Executive summary content -->
</div>

<!-- All other sections following the exact structure -->

</body>
</html>
```

#### Interactive Features Required:
1. **Navigation Menu**: Sticky sidebar with links to all sections
2. **Collapsible Sections**: Click to expand/collapse detailed sections
3. **Interactive Checklists**: Clickable checkboxes that persist state
4. **Color-coded Priority**: Visual indicators for risk levels
5. **Responsive Design**: Mobile-friendly layout
6. **Print-friendly**: Clean printing without navigation

## ANALYSIS REQUIREMENTS

### 1. Project Structure Analysis
- Analyze the complete project directory structure
- Identify key files, configurations, and dependencies
- Review `.llm-context/project/open-issues.md` if it exists
- Assess architecture patterns and code organization

### 2. Compliance Assessment
Based on [COMPLIANCE_TARGET], evaluate:
- **MANDATORY**: Tasks required for approval/certification
- **RECOMMENDED**: Best practices that improve approval chances
- **OPTIONAL**: Nice-to-have improvements
- **NOT REQUIRED**: Common misconceptions

### 3. Code Quality Scoring
Use the weighted scoring system:
- Score each category 1-10 with specific examples
- Calculate weighted total score
- Provide detailed justification for each score
- Include specific file references and line numbers where applicable

### 4. Open Issues Integration
If `.llm-context/project/open-issues.md` exists:
- Analyze all documented issues
- Prioritize by business and technical impact
- Provide single developer effort estimates
- Integrate into overall timeline and recommendations

### 5. Timeline Estimation
- Provide single developer effort estimates only
- Break down into weekly increments
- Account for development, testing, and validation
- Include multiple timeline options

## OUTPUT REQUIREMENTS

### File Locations
- **Markdown**: `[PROJECT_PATH]/reports/comprehensive-project-report.md`
- **HTML**: `[PROJECT_PATH]/reports/comprehensive-project-report.html`

### Quality Standards
- Professional presentation suitable for stakeholders
- Accurate technical analysis with specific examples
- Actionable recommendations with clear priorities
- Consistent formatting and styling
- Interactive HTML with full functionality

### Content Requirements
- Executive summary under 200 words
- All effort estimates as single developer time
- Specific file references with line numbers
- Color-coded priority levels throughout
- Complete implementation timeline with weekly breakdown
- Comprehensive appendix with technical details

## CUSTOMIZATION GUIDELINES

### For Different Technologies
- **Android**: Focus on Play Store compliance, SDK updates, permissions
- **iOS**: Emphasize App Store guidelines, iOS version compatibility
- **Web**: Prioritize accessibility, performance, security standards
- **React Native/Flutter**: Cross-platform considerations and platform-specific requirements

### For Different Compliance Targets
- **App Store Compliance**: iOS guidelines, privacy policies, content policies
- **Play Store Compliance**: Android SDK, permissions, security requirements
- **GDPR Compliance**: Data protection, privacy policies, user consent
- **SOX Compliance**: Financial controls, audit trails, security measures

### For Different Project Sizes
- **Small Projects**: Focus on essential compliance and critical issues
- **Medium Projects**: Include comprehensive quality improvements
- **Large Projects**: Add governance, architecture, and process improvements

## SUCCESS CRITERIA

The generated reports should enable:
- ✅ Clear understanding of compliance requirements and timeline
- ✅ Objective assessment of current project quality
- ✅ Actionable roadmap for improvements
- ✅ Professional presentation for stakeholders
- ✅ Interactive HTML for easy navigation and review
- ✅ Integration of existing project issues and improvements

Please analyze the project at [PROJECT_PATH] and generate both comprehensive-project-report.md and comprehensive-project-report.html following this exact format and structure.
```

---

## Template Metadata

**Created**: January 8, 2025  
**Version**: 2.0  
**Based On**: OBHAI Android Contractor Report Format (Finalized)  
**Applicable To**: Any software project requiring comprehensive analysis  
**Technologies**: Technology-agnostic (Android, iOS, Web, Desktop, etc.)  
**Output**: Professional Markdown + Interactive HTML reports  
**Estimated Generation Time**: 2-4 hours depending on project complexity  
**Last Updated**: September 8, 2025 - Exact formatting and styling locked  

---

## Usage Examples

### Example 1: Android Project Analysis
```
Project Name: ShopEasy Android App
Project Version: 2.1.4
Technology Stack: Android/Kotlin, MVVM, Room, Retrofit, Firebase
Compliance Target: Play Store Compliance
Report Date: January 15, 2025
Project Path: /Users/developer/projects/shopeasy-android
```

### Example 2: iOS Project Analysis
```
Project Name: ChatConnect iOS
Project Version: 1.3.2
Technology Stack: iOS/Swift, MVVM, Core Data, Alamofire, Firebase
Compliance Target: App Store Compliance
Report Date: January 15, 2025
Project Path: /Users/developer/projects/chatconnect-ios
```

### Example 3: Web Application Analysis
```
Project Name: CorpDashboard Web App
Project Version: 3.0.1
Technology Stack: React/TypeScript, Redux, Node.js, PostgreSQL
Compliance Target: GDPR Compliance
Report Date: January 15, 2025
Project Path: /Users/developer/projects/corp-dashboard
```

## Benefits of This Template

### For Project Managers
- **Consistent Reporting**: Standardized format across all projects
- **Objective Assessment**: Data-driven project evaluation
- **Clear Timelines**: Realistic effort estimates and milestones
- **Risk Management**: Early identification of potential issues

### For Development Teams
- **Clear Priorities**: Focused roadmap for improvements
- **Technical Guidance**: Specific recommendations with examples
- **Progress Tracking**: Interactive checklists and milestones
- **Knowledge Sharing**: Comprehensive documentation for team reference

### For Stakeholders
- **Professional Presentation**: Clean, interactive reports
- **Executive Summary**: Key findings at a glance
- **Multiple Options**: Different timeline and budget scenarios
- **Actionable Insights**: Clear next steps and recommendations

This reusable template ensures consistent, comprehensive, and professional project reports that can be applied to any software project while maintaining the exact format and quality standards established in the reference implementation.
