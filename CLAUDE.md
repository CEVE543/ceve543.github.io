# CLAUDE.md

The syllabus provides specific policies for how I do and do not use "AI" tools in this course.

This file provides guidance to Claude Code when working with this repository.

## Project Overview

This is a publicly available Quarto website for CEVE 543 (Statistical-Physical Methods for Hydroclimate Extremes and Catastrophes) at Rice University, taught by James Doss-Gollin.
The site is built using Quarto and includes course materials, assignments, labs, and schedules.
Both the course repository and all course materials are publicly accessible.

## Development Commands

To build and preview the site:

- `quarto preview` starts development server on port 5543
- `quarto render` builds the entire site to `_site/` directory
- `quarto render [file.qmd]` renders a specific file

The project uses Julia 1.11.5 for computational content with a minimal environment (no dependencies in Manifest.toml).

## Content Structure

The main pages include `index.qmd`, `syllabus.qmd`, `schedule.qmd`, `assignments.qmd`, and `labs.qmd`.
Assignments are located in `assignments/` and labs in `labs/`, both using Git submodules from the CEVE543 GitHub organization (e.g., CEVE543/PS0, CEVE543/Lab-1).
Each assignment and lab contains `index.qmd` and `README.md` files.

Lecture materials (slides or notes) are located in `lectures/` with each lecture in a dated subdirectory (e.g., `lectures/2025-10-15/`).
Each lecture includes `index.qmd` as the main file.
Slide decks use `format: revealjs` and may use shared template partials (`title-slide.html`, `mathjax-config.html`) located in the `lectures/` directory.
Lecture notes may use standard HTML format instead of revealjs when whiteboard teaching is preferred.
All lectures must be manually linked from `schedule.qmd` in the appropriate date row.

Configuration files include `_quarto.yml` for main Quarto settings, `_variables.yml` for course variables, `references.bib` for citations, and `_assets/` for static assets including logos and CSS themes.

The site uses computational caching (`freeze: auto`, `cache: true`), a custom theme based on Simplex with SCSS, KaTeX for mathematical expressions, and supports Julia code execution.
Output formats are primarily HTML for the website with secondary PDF generation for assignments and labs.

## Git Workflow

The repository uses Git submodules for assignments and labs, with the main branch being `Fall25`.
Individual assignments and labs are separate repositories from the CEVE543 GitHub organization linked as submodules.
Changes to assignment or lab content should be made in their respective submodule repositories.

## Instructor Materials

Detailed instructor materials are available in the `./instructor/` directory (symlinked from a separate location and included in .gitignore to keep them private).
This includes:

- `index.qmd` - detailed instructor version of the syllabus with course philosophy and pedagogical approach
- `module1-detailed.qmd` and `module2-detailed.qmd` - comprehensive lesson plans for each module
- `exams/` directory for exam materials

The typical workflow involves updating the instructor materials first, then asking Claude to synchronize changes to the public student-facing versions to maintain consistency between detailed planning and public materials.

## Content and Style Guidelines

Use Quarto markdown (.qmd) for all content and reference course variables using `{{< var variable.name >}}` syntax.
Mathematical content uses KaTeX syntax, code blocks support Julia execution, and citations reference `references.bib` using standard academic format.

### Markdown Formatting Standards

Always include blank lines after headers and before/after all lists (both ordered and unordered).
Use proper header hierarchy with `#` for main titles, `##` for major sections, and `###` for subsections.
Avoid excessive bolding and write in natural, flowing prose rather than artificial bullet-point formats.

Write no more than one sentence per line of Markdown.
This improves version control diffs and makes editing easier.

Write content naturally and conversationally rather than using rigid "bulleted lists with bold first words" formatting that appears artificial.
Focus on clear communication over stylistic formatting conventions.

### Mathematical Notation

Always use LaTeX math syntax for mathematical symbols, Greek letters, and units rather than relying on Unicode characters.
For example, write `$\tau$` instead of τ, `$^\circ$C` instead of °C, and `$\alpha$` instead of α.
This ensures consistent rendering across all output formats and avoids font-dependent display issues.
- Do not rely on println statements for all output in notebooks