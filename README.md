# Ralph - AI-Powered Development Assistant

Ralph is an automated development assistant that uses Claude Code to iteratively work through features defined in a Product Requirements Document (PRD). It processes features one at a time, validates code quality, tracks progress, and commits work automatically.

## Table of Contents

- [Prerequisites](#prerequisites)
  - [Node.js](#1-nodejs)
  - [Claude Code](#2-claude-code)
  - [GLM Coding Plan Setup](#3-glm-coding-plan-setup)
- [Project Setup](#project-setup)
  - [Required Directory Structure](#required-directory-structure)
  - [Creating the `.ai` Directory](#creating-the-ai-directory)
  - [PRD File Format](#prd-file-format)
  - [Progress File](#progress-file)
- [Usage](#usage)
  - [Installing Ralph as a Global Command](#installing-ralph-as-a-global-command)
  - [Using Ralph](#using-ralph)
- [How It Works](#how-it-works)
- [Example Workflow](#example-workflow)
- [Troubleshooting](#troubleshooting)
  - [Claude Code Not Found](#claude-code-not-found)
  - [API Key Issues](#api-key-issues)
  - [Network Errors](#network-errors)
  - [Permission Denied (Mac/Linux)](#permission-denied-maclinux)
  - [Missing .ai Directory](#missing-ai-directory)
  - [Script Not Executable (Mac/Linux)](#script-not-executable-maclinux)
- [Best Practices](#best-practices)
- [Additional Resources](#additional-resources)

## Prerequisites

Before using Ralph, you need to set up the following:

### 1. Node.js

- **Mac**: Install via [Homebrew](https://brew.sh/) or download from [nodejs.org](https://nodejs.org/)
  ```bash
  brew install node
  ```
- **Windows**: Download and install from [nodejs.org](https://nodejs.org/)
  - Requires Node.js >= v18.0.0

### 2. Claude Code

Claude Code is the CLI tool that Ralph uses to interact with Claude AI.

#### Installation

**Mac:**
```bash
# Install Claude Code globally
npm install -g @anthropic-ai/claude-code
```

**Windows:**
```powershell
# Open PowerShell as Administrator, then:
npm install -g @anthropic-ai/claude-code
```

If you encounter permission errors:
- **Mac/Linux**: Use `sudo npm install -g @anthropic-ai/claude-code`
- **Windows**: Run PowerShell as Administrator
- **Alternative**: Use `npx @anthropic-ai/claude-code` without global installation

### 3. GLM Coding Plan Setup

Ralph requires a GLM Coding Plan API key configured through the Coding Tool Helper.

#### Get Your API Key

1. Visit the [Z.AI Open Platform API Keylist](https://z.ai/manage-apikey/apikey-list).
2. Create a new API key for this.

#### Install Coding Tool Helper

**Mac:**
```bash
# Option 1: Run directly (recommended for occasional use)
npx @z_ai/coding-helper

# Option 2: Install globally (for frequent use)
npm install -g @z_ai/coding-helper
coding-helper
```

**Windows:**
```powershell
# Option 1: Run directly
npx @z_ai/coding-helper

# Option 2: Install globally (run PowerShell as Administrator)
npm install -g @z_ai/coding-helper
coding-helper
```

#### Configure Your Plan

1. Run `npx @z_ai/coding-helper` or `coding-helper`
2. Follow the interactive wizard:
   - Select UI language
   - Choose a coding plan (Global or other available plans)
   - Enter your API key
   - Select Claude Code to manage
   - Auto-install tools if needed
   - Load plan into Claude Code
   - Complete setup

#### Quick Configuration Commands

```bash
# Configure API key interactively
coding-helper auth

# Or set it directly (replace <token> with your actual API key)
coding-helper auth glm_coding_plan_global <token>

# Reload plan into Claude Code
coding-helper auth reload claude

# Check system configuration
coding-helper doctor
```

For more details, see the [Coding Tool Helper Documentation](https://docs.z.ai/devpack/extension/coding-tool-helper).

## Project Setup

### Required Directory Structure

Ralph expects the following structure in your repository:

```
your-repo/
├── .ai/
│   ├── prd.json          # Product Requirements Document
│   └── progress.txt      # Progress tracking file
└── start.sh              # Ralph script
```

### Creating the `.ai` Directory

**Mac/Linux:**
```bash
mkdir -p .ai
```

**Windows:**
```cmd
mkdir .ai
```

### PRD File Format

Create `.ai/prd.json` with your features:

```json
[
  {
    "category": "ui (Example)",
    "description": "Delete video shows confirmation dialog before deleting",
    "scope": "Video list pages, video detail pages",
    "steps": [
      "Navigate to a video",
      "Click delete button",
      "Verify 'Are you sure?' confirmation dialog appears",
      "Click cancel",
      "Verify video is not deleted",
      "Click delete again and confirm",
      "Verify video is deleted"
    ],
    "passes": false
  }
]
```

**Field Descriptions:**
- `category`: The category or type of feature (e.g., "ui", "api", "backend")
- `description`: A brief description of what the feature should do
- `scope`: The areas or components of the application this feature affects
- `steps`: An array of step-by-step instructions or acceptance criteria
- `passes`: Boolean indicating whether the feature has been completed and verified

### Progress File

Create `.ai/progress.txt` (can be empty initially):

```bash
# Mac/Linux
touch .ai/progress.txt

# Windows
type nul > .ai/progress.txt
```

## Usage

### Installing Ralph as a Global Command

To use `ralph` from any repository, you need to add it to your shell configuration or PATH.

#### Mac/Linux

**Option 1: Add to Shell Config (Recommended)**

Add this function to your `~/.zshrc` or `~/.bash_profile`:
```bash
ralph() {
    /path/to/ralph/start.sh "$@"
}
```
Replace `/path/to/ralph` with the actual path to your ralph directory.

Then reload your shell:
```bash
source ~/.zshrc  # or source ~/.bash_profile
```

**Option 2: Add Directory to PATH**

1. Navigate to the ralph directory:
   ```bash
   cd /path/to/ralph
   ```

2. Rename `start.sh` to `ralph`:
   ```bash
   mv start.sh ralph
   chmod +x ralph
   ```

3. Add the ralph directory to your PATH in `~/.zshrc` or `~/.bash_profile`:
   ```bash
   export PATH="/path/to/ralph:$PATH"
   ```
   Replace `/path/to/ralph` with the actual path.

4. Reload your shell:
   ```bash
   source ~/.zshrc  # or source ~/.bash_profile
   ```

#### Windows

**Option 1: Using Git Bash (Recommended)**

1. Navigate to the ralph directory:
   ```bash
   cd /c/path/to/ralph
   ```

2. Rename `start.sh` to `ralph`:
   ```bash
   mv start.sh ralph
   chmod +x ralph
   ```

3. Add the ralph directory to your PATH. Add this to your `~/.bashrc`:
   ```bash
   export PATH="/c/path/to/ralph:$PATH"
   ```
   Replace `/c/path/to/ralph` with the actual path to your ralph directory.

4. Reload your shell:
   ```bash
   source ~/.bashrc
   ```

**Option 2: Using PowerShell/CMD**

1. Create a batch file wrapper. Create `ralph.bat` in a directory in your PATH (e.g., `C:\Users\YourName\bin\`):
   ```batch
   @echo off
   bash C:\path\to\ralph\start.sh %*
   ```

2. Add the directory to your Windows PATH:
   - Open System Properties → Environment Variables
   - Add `C:\Users\YourName\bin` (or your chosen directory) to PATH
   - Restart your terminal

**Option 3: Using WSL**

Follow the Mac/Linux instructions above, but within your WSL environment.

### Using Ralph

Once installed, you can use `ralph` from any repository:

```bash
# Navigate to any repository
cd /path/to/your/project

# Run ralph with default 30 iterations
ralph

# Or specify a custom number of iterations
ralph 10
```

Ralph will automatically:
- Look for `.ai/prd.json` in the current repository
- Use `.ai/progress.txt` for tracking progress
- Work through features one at a time
- Exit early if the PRD is complete

## How It Works

1. **Feature Selection**: Ralph analyzes the PRD and selects the highest-priority feature to work on
2. **Implementation**: Claude Code implements the feature
3. **Validation**: 
   - Runs type checking (`npx/npm/pnpm typecheck`)
   - Runs tests (`npx/npm/pnpm test`)
4. **Documentation**: Updates the PRD and appends progress to `progress.txt`
5. **Commit**: Creates a git commit for the completed feature
6. **Completion**: If all features are complete, Ralph exits with a completion message

## Example Workflow

```bash
# Navigate to your project repository
cd ~/projects/my-app

# Start with 10 iterations (explicit)
ralph 10

# Or use default (30 iterations)
ralph

# Ralph will:
# - Iteration 1: Work on highest priority feature
# - Iteration 2: Work on next feature
# - ... continues until PRD is complete or iterations run out
```

## Troubleshooting

### Claude Code Not Found

**Error**: `command not found: claude`

**Solution**:
- Verify Claude Code is installed: `npm list -g @anthropic-ai/claude-code`
- Check your PATH includes npm global bin directory
- **Mac**: Add to `~/.zshrc` or `~/.bash_profile`:
  ```bash
  export PATH="$PATH:$(npm config get prefix)/bin"
  ```
- **Windows**: Add npm global path to System Environment Variables

### API Key Issues

**Error**: API Key invalid or authentication failures

**Solution**:
```bash
# Reconfigure your API key
coding-helper auth

# Or set directly
coding-helper auth glm_coding_plan_global <your-token>

# Reload into Claude Code
coding-helper auth reload claude

# Check configuration
coding-helper doctor
```

### Network Errors

**Error**: Network timeout or connection errors

**Solution**:
- Check your internet connection
- If using a proxy, configure Node.js proxy settings:
  ```bash
  # Mac/Linux
  export HTTP_PROXY=http://your.proxy.server:port
  export HTTPS_PROXY=http://your.proxy.server:port
  
  # Windows (PowerShell)
  $env:HTTP_PROXY="http://your.proxy.server:port"
  $env:HTTPS_PROXY="http://your.proxy.server:port"
  ```

### Permission Denied (Mac/Linux)

**Error**: `EACCES: permission denied`

**Solution**:
- Use `sudo` for global npm installs: `sudo npm install -g ...`
- Or use `npx` to avoid global installs
- Consider using [nvm](https://github.com/nvm-sh/nvm) to manage Node.js versions

### Missing .ai Directory

**Error**: `'.ai' directory not found`

**Solution**:
- Ensure you're in the repository root
- Create the directory: `mkdir -p .ai`
- Create required files: `prd.json` and `progress.txt`

### Script Not Executable (Mac/Linux)

**Error**: `Permission denied`

**Solution**:
```bash
chmod +x start.sh
```

## Best Practices

1. **Start Small**: Begin with 1-2 iterations to test your setup
2. **Review Commits**: Check git commits after each iteration
3. **Monitor Progress**: Review `progress.txt` to understand what Ralph is working on
4. **Update PRD**: Keep your PRD file updated with accurate feature descriptions
5. **Version Control**: Commit your PRD and progress files to track changes

## Additional Resources

- [Claude Code Documentation](https://docs.anthropic.com/claude/docs/claude-code)
- [Coding Tool Helper Documentation](https://docs.z.ai/devpack/extension/coding-tool-helper)
- [Z.AI Open Platform](https://platform.z.ai/)