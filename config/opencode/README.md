# OpenCode Configuration

Custom extensions and configurations for my AI assistant.

## Setup

For custom hooks, that need packages, I need to install them here.

Meaning `bun install` needs to be run in this directory.

## Tools

The AI can access these tools automatically similar to MCP.

### Audio File Processing

**Setup Requirements:**

- Set `DEEPGRAM_API_KEY` environment variable
- Use `run-opencode-custom-tool.ts` for debugging

**Features:**

- **Transcription**: Converts audio to text with confidence scoring
- **Language Detection**: Identifies audio language with confidence scoring

## Plugins

### Notification System

**Setup Requirements:**

- Configure notification service endpoint (see plugin)
- Enable plugin (see plugin)

**Purpose:**

- Sends alerts to external services when the AI is waiting for user input.

## Additional Features

These are not used extensively and can be ignored for now

- Agents
  - Sub-agents that provide specialized context for specific tasks (automatically triggered).
- Commands
  - Slash commands (`/`) for quick access to preconfigured prompts.
