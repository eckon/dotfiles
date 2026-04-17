# OpenCode Configuration

Custom extensions and configurations for my AI assistant.

## Setup

For custom hooks, that need packages, I need to install them here.

Meaning `bun install` needs to be run in this directory.

## Plugins

Custom plugins that extend OpenCode functionality.

### Tmux Notification

**Location:** `plugins/tmux-notification.ts`

Renames tmux window and sends notifications based on OpenCode's status.

## Tools

The AI can access these tools automatically similar to MCP.

### Audio File Processing

**Setup Requirements:**

- Set `DEEPGRAM_API_KEY` environment variable
- Use `run-opencode-custom-tool.ts` for debugging

**Features:**

- **Transcription**: Converts audio to text with confidence scoring
- **Language Detection**: Identifies audio language with confidence scoring
