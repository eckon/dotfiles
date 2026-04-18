import type { Plugin } from '@opencode-ai/plugin';
import { execSync } from 'child_process';

export const TmuxNotificationPlugin: Plugin = async () => {
  let tmuxPaneId: string | null = null;

  // Capture the pane ID where OpenCode is running
  if (process.env.TMUX) {
    try {
      tmuxPaneId = execSync('tmux display-message -p "#{pane_id}"', {
        encoding: 'utf8',
      }).trim();
    } catch {
      // Could not get pane ID
    }
  }

  return {
    event: async ({ event }) => {
      if (!process.env.TMUX || !tmuxPaneId) return;

      try {
        if (event.type === 'session.status') {
          execSync(`tmux rename-window -t ${tmuxPaneId} "AI ⏳"`);
        }

        if (event.type === 'session.idle') {
          execSync(`tmux rename-window -t ${tmuxPaneId} "AI ✅"`);
          execSync(`tmux display-message -t ${tmuxPaneId} "OpenCode: Task completed!"`);
        }

        if (event.type === 'session.error') {
          execSync(`tmux rename-window -t ${tmuxPaneId} "AI ❌"`);
          execSync(
            `tmux display-message -t ${tmuxPaneId} -d 5000 "OpenCode: Error occurred!"`
          );
        }
      } catch {
        // Silently ignore tmux errors
      }
    },
  };
};
