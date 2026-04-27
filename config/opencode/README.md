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

## Browser integration

Handling we browser is still a highly fluctuating topic, there are mcps, ai browsers, cli tools and more.
Here I want to quickly write some notes down for future reference

- skills -> browser cli
  - a basic setup that uses a cli tool to call browser actions
  - needs to install the cli tool
  - normally starts a new browser, so AI needs to emulate actions to get to wanted states (see bug x)
  - NOTE: the skills are setup globally in the `agents` folder to be coding agent independent
- mcp -> chrome dev tools
  - a more involved setup where chrome exposes a mcp server that can be used
  - chrome instance needs to start server, go to `chrome://inspect/#remote-debugging` and activate
  - then this sessions should be able to be run, if the devtool with `auto-connect` is started
    - `npx chrome-devtools-mcp --auto-connect`
  - allows attaching of open browser, so AI can be a pairing partner while working on the frontend
