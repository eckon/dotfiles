import type { Plugin } from '@opencode-ai/plugin';
import { execSync } from 'child_process';

export const TmuxNotificationPlugin: Plugin = async () => {
  return {
    event: async ({ event }) => {
      if (!process.env.TMUX) return;

      try {
        if (event.type === 'session.status') {
          execSync('tmux rename-window "AI ⏳"');
        }

        if (event.type === 'session.idle') {
          execSync('tmux rename-window "AI ✅"');
          execSync('tmux display-message "OpenCode: Task completed!"');
        }

        if (event.type === 'session.error') {
          execSync('tmux rename-window "AI ❌"');
          execSync('tmux display-message -d 5000 "OpenCode: Error occurred!"');
        }
      } catch {
        // Silently ignore tmux errors
      }
    },
  };
};
