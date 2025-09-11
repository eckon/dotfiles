import { Plugin } from "@opencode-ai/plugin";

// to use just open the url; leaking topic as nothing critical will be sent
const url = "https://ntfy.sh/eckon_OGfEX1Zm2ocC6QYU";

const disabled = true;
const minSeconds = 0;
let lastSessionUpdate = new Date();

export const NotificationPlugin: Plugin = async ({ $ }) => {
  if (disabled) {
    return {};
  }

  const elapsedTimeSeconds = (): number => {
    const diff = new Date().getTime() - lastSessionUpdate.getTime();
    return Math.floor(diff / 1000);
  };

  const elapsedTime = (): string => {
    const seconds = elapsedTimeSeconds();
    const minutes = Math.floor(seconds / 60);
    const hours = Math.floor(minutes / 60);

    if (hours > 0) {
      return `${hours}h ${minutes % 60}m ${seconds % 60}s`;
    } else if (minutes > 0) {
      return `${minutes}m ${seconds % 60}s`;
    } else {
      return `${seconds}s`;
    }
  };

  const notify = async (message: string) => {
    // to not spam the user with notifications, just do it with longer running tasks
    if (elapsedTimeSeconds() <= minSeconds) {
      return;
    }

    return await $`curl --silent --output /dev/null -d ${message} ${url}`;
  };

  return {
    event: async ({ event }) => {
      switch (event.type) {
        // notify user, when AI is waiting for input to enable leaving it in the background
        case "session.idle":
          await notify(`(${elapsedTime()}) AI is done, waiting for new input`);
          break;
        // notify user, when AI is waiting for permission to enable leaving it in the background
        case "permission.updated":
          await notify(
            `(${elapsedTime()}) AI is requesting permission "${event.properties.type}" > "${event.properties.metadata.command}"`,
          );
          break;
        // get time of the last interaction with the session
        case "session.updated":
          lastSessionUpdate = new Date();
          break;
      }
    },
  };
};
