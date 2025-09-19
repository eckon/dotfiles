#!/usr/bin/env tsx

import * as audioTools from '../config/opencode/tool/audio';

// NOTE: run script via `npx tsx <script> <tool-name> [...arguments]
enum Tool {
  AudioTranscription = 'audio-transcription',
  AudioLanguageDetection = 'audio-language-detection',
}

async function runTranscription(audioFilePath: string, language: string) {
  console.log(`Running ${Tool.AudioTranscription} tool`);
  console.log('Provided Arguments:');
  console.log({ audioFilePath, language });

  return await audioTools.transcription.execute(
    { audioFilePath, language },
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    {} as any,
  );
}

async function runLanguageDetection(audioFilePath: string) {
  console.log(`Running ${Tool.AudioLanguageDetection} tool`);
  console.log('Provided Arguments:');
  console.log({ audioFilePath });

  return await audioTools.languageDetection.execute(
    { audioFilePath },
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    {} as any,
  );
}

async function main() {
  // for the function call ignore the first 2 arguments: 1. node 2. script name
  // rest are the tool-name and the arguments for the tool (these change depending on the tool)
  const args = process.argv.slice(2);
  const toolName = args[0];

  switch (toolName) {
    case Tool.AudioTranscription: {
      const result = await runTranscription(args[1], args[2]);
      console.log(result);
      break;
    }
    case Tool.AudioLanguageDetection: {
      const result = await runLanguageDetection(args[1]);
      console.log(result);
      break;
    }
    default:
      console.log(`Provided tool "${toolName}" does not exist`);
      console.log('Available tools:', Object.values(Tool));
  }
}

main().catch(console.error);
