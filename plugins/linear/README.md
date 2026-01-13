# Linear

Linear issue tracking integration via MCP (Model Context Protocol).

## Installation

```bash
claude plugin install linear@october-plugins
```

## Setup

This plugin connects to Linear's hosted MCP server. After installation:

1. The plugin will prompt you to authenticate with Linear
2. Follow the OAuth flow to grant access to your Linear workspace
3. Once authenticated, Claude can interact with your Linear issues

## Features

- **Issue Management**: Create, update, and search issues
- **Project Tracking**: View and manage projects and cycles
- **Status Updates**: Change issue states and priorities
- **Workspace Search**: Search across all issues in your workspace
- **Team Collaboration**: Assign issues and manage team workflows

## Usage Examples

```
Create a bug issue for the login page not loading

What are my assigned issues?

Move issue FE-123 to "In Progress"

Search for issues related to authentication

Show me the current sprint's issues
```

## How It Works

This plugin uses Linear's official MCP server (`https://mcp.linear.app/mcp`) to provide Claude with direct access to your Linear workspace. All communication happens through the secure MCP protocol.

## Requirements

- Active Linear account
- Workspace access permissions for the operations you want to perform
