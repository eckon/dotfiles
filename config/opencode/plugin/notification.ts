import { Plugin } from "@opencode-ai/plugin";

// to use just open the url; leaking topic as nothing critical will be sent
const url = "https://ntfy.sh/eckon_OGfEX1Zm2ocC6QYU";

export const NotificationPlugin: Plugin = async ({ $ }) => {
  const notify = async (message: string) =>
    await $`curl --silent --output /dev/null -d ${message} ${url}`;

  return {
    // notify user, when AI is waiting for input/permission to enable leaving it in the background
    event: async ({ event }) => {
      switch (event.type) {
        case "session.idle":
          await notify("AI is done, waiting for new input");
          break;
        case "permission.updated":
          await notify(
            `AI is requesting permission "${event.properties.type}" > "${event.properties.metadata.command}"`,
          );
          break;
      }
    },
  };
};
