# Admin Dashboard Template

A comprehensive, responsive administrative dashboard reference implementation built exclusively with the HEBRING CSS Framework.

## Overview

This template demonstrates how HEBRING can compose into a realistic, application-style interface. It serves as a starting point for developers building admin panels, SaaS products, or internal tools.

## Architecture

This is a **consumer** of the HEBRING ecosystem.
It strictly separates the global HEBRING framework APIs from the local template layout.

- **HEBRING Provides**: Typography, spacing tokens, colors, UI components (`hb-button`, `hb-card`, `hb-table`), utility classes, and interaction ecosystems (`hb-menu`, `hb-popover`).
- **Template Provides**: The macro-layout (Sidebar + Header + Main Area) defined locally via CSS Grid in `assets/admin.css`.

## Features

- **Responsive Application Shell**: A sidebar that collapses into a drawer on mobile viewports.
- **Header**: Global search area and user/notification popover menus.
- **Dashboard View**: Metric cards with various UI states (success, error, loading), data tables, and an activity feed.
- **Framework-Neutral**: Built entirely with HTML, CSS, and minimal vanilla JavaScript for the mobile toggle. No React, Vue, or build steps are required.

## Usage

To use this template:
1. Ensure the `hebring` package is installed in your project.
2. Copy the HTML structure.
3. Import the required HEBRING styles (`dist/hebring.css`, `ecosystem/ui/menu.css`, `ecosystem/ui/popover.css`).
4. Copy `assets/admin.css` into your project and customize it for your specific macro-layout needs.

*Note: The JavaScript provided in `assets/admin.js` is merely for demonstration. In a real application, you should replace this with your framework's native state management (e.g., React `useState`, Vue `ref`, etc.).*
