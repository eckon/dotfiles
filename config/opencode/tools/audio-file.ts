import { tool } from '@opencode-ai/plugin';
import { readFileSync, existsSync } from 'fs';
import { extname } from 'path';
import { DeepgramResponse, SyncPrerecordedResponse } from '@deepgram/sdk';

// NOTE: use custom script `run-opencode-custom-tool.ts` to debug setup

const getApiToken = (): string => {
  const apiKey = process.env.DEEPGRAM_API_KEY;
  if (!apiKey) {
    throw new Error('DEEPGRAM_API_KEY environment variable is not set.');
  }

  return apiKey;
};

const getAudioFormat = (filePath: string): string =>
  extname(filePath).toLowerCase().replace('.', '');

export const transcription = tool({
  description: 'Transcribe an audio file and get its contents',
  args: {
    language: tool.schema
      .string()
      .describe(
        'Language code (e.g., "en" for English, "de" for German, "pt" for Portuguese)',
      )
      .default('en'),
    audioFilePath: tool.schema
      .string()
      .describe('Path to the audio file with extension'),
  },
  async execute(args) {
    try {
      if (!existsSync(args.audioFilePath)) {
        throw new Error(`Audio file not found: ${args.audioFilePath}`);
      }

      const response = await fetch(
        `https://api.deepgram.com/v1/listen?model=nova-2&smart_format=true&language=${args.language}`,
        {
          method: 'POST',
          headers: {
            Authorization: `Token ${getApiToken()}`,
            'Content-Type': `audio/${getAudioFormat(args.audioFilePath)}`,
          },
          body: readFileSync(args.audioFilePath),
        },
      );

      if (!response.ok) {
        throw new Error(
          `API request failed with status ${response.status}: ${await response.text()}`,
        );
      }

      const deepgramResponse: DeepgramResponse<SyncPrerecordedResponse> = {
        result: await response.json(),
        error: null,
      };

      const output =
        deepgramResponse.result.results.channels[0].alternatives[0];

      const transcript = output.transcript;
      if (!transcript) {
        throw new Error(
          'No transcription found in the response. The provided language might be incorrect.',
        );
      }

      const confidence = output.confidence ?? 0;
      if (confidence < 0.95) {
        throw new Error(
          `Confidence (${confidence}) is lower than 95% - therefore it will be ignored. The provided language might be incorrect.`,
        );
      }

      return `Confidence: ${confidence}\n\nTranscript:\n${transcript}`;
    } catch (error) {
      return `Error: ${error instanceof Error ? error.message : 'Unknown error occurred'}`;
    }
  },
});

export const languageDetection = tool({
  description: 'Identify the language of an audio file',
  args: {
    audioFilePath: tool.schema
      .string()
      .describe('Path to the audio file with extension'),
  },
  async execute(args) {
    try {
      if (!existsSync(args.audioFilePath)) {
        throw new Error(`Audio file not found: ${args.audioFilePath}`);
      }

      const response = await fetch(
        `https://api.deepgram.com/v1/listen?model=nova-2&detect_language=true`,
        {
          method: 'POST',
          headers: {
            Authorization: `Token ${getApiToken()}`,
            'Content-Type': `audio/${getAudioFormat(args.audioFilePath)}`,
          },
          body: readFileSync(args.audioFilePath),
        },
      );

      if (!response.ok) {
        throw new Error(
          `API request failed with status ${response.status}: ${await response.text()}`,
        );
      }

      const deepgramResponse: DeepgramResponse<SyncPrerecordedResponse> = {
        result: await response.json(),
        error: null,
      };

      const detectedLanguage =
        deepgramResponse.result.results.channels[0].detected_language;

      if (!detectedLanguage) {
        throw new Error('No language detected in the response.');
      }

      const confidence =
        deepgramResponse.result.results.channels[0].language_confidence ?? 0;
      if (confidence < 0.75) {
        throw new Error(
          `Confidence (${confidence}) is lower than 75% - therefore it will be ignored.`,
        );
      }

      return `Confidence: ${confidence}\n\nDetected Language: ${detectedLanguage}`;
    } catch (error) {
      return `Error: ${error instanceof Error ? error.message : 'Unknown error occurred'}`;
    }
  },
});
