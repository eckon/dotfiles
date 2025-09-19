import { tool } from '@opencode-ai/plugin';
import { readFileSync } from 'fs';

export default tool({
  description: 'Transcribe an audio file and get its contents',
  args: {
    language: tool.schema
      .string()
      .describe('Language code like "en" or "de"')
      .default('en'),
    audioFilePath: tool.schema
      .string()
      .describe('Path to the audio file with extension'),
    audioFormat: tool.schema
      .string()
      .describe('Format of the audio file')
      .default('ogg'),
  },
  async execute(args) {
    const apiKey = process.env.DEEPGRAM_API_KEY;
    if (!apiKey) {
      return 'Error: DEEPGRAM_API_KEY environment variable is not set. Please set it with your Deepgram API key.';
    }

    try {
      const audioData = readFileSync(args.audioFilePath);
      const response = await fetch(
        `https://api.deepgram.com/v1/listen?model=nova-2&smart_format=true&language=${args.language}`,
        {
          method: 'POST',
          headers: {
            Authorization: `Token ${apiKey}`,
            'Content-Type': `audio/${args.audioFormat}`,
          },
          body: audioData,
        },
      );

      if (!response.ok) {
        const errorText = await response.text();
        return `Error: API request failed with status ${response.status}: ${errorText}`;
      }

      const result = await response.json();
      const transcript =
        result?.results?.channels?.[0]?.alternatives?.[0]?.transcript;

      if (!transcript) {
        return 'Error: No transcription found in the response. The provided language might be incorrect.';
      }

      return transcript;
    } catch (error) {
      return `Error: ${error instanceof Error ? error.message : 'Unknown error occurred'}`;
    }
  },
});
