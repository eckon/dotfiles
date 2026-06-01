import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execSync } from "node:child_process";

export default function (pi: ExtensionAPI) {
  let tmuxPaneId: string | null = null;

  // Capture the pane ID where pi is running
  if (process.env.TMUX) {
    try {
      tmuxPaneId = execSync('tmux display-message -p "#{pane_id}"', {
        encoding: "utf8",
      }).trim();
    } catch {
      // Could not get pane ID
    }
  }

  if (!tmuxPaneId) return;

  pi.on("agent_start", async () => {
    try {
      execSync(`tmux rename-window -t ${tmuxPaneId} "AI ⏳"`);
    } catch {
      // Silently ignore tmux errors
    }
  });

  pi.on("agent_end", async () => {
    try {
      execSync(`tmux rename-window -t ${tmuxPaneId} "AI ✅"`);
      execSync(
        `tmux display-message -t ${tmuxPaneId} "pi: Task completed!"`,
      );
    } catch {
      // Silently ignore tmux errors
    }
  });
}
