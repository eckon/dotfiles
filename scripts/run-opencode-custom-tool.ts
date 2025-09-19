#!/usr/bin/env tsx

import transcriptionTool from '../config/opencode/tool/transcription';

// NOTE: run script via `npx tsx <script> <tool-name> [...arguments]
enum Tool {
  Transcription = 'transcription',
}

async function transcription(
  audioFilePath: string,
  audioFormat: string,
  language: string,
) {
  console.log(`Running ${Tool.Transcription} tool`);
  console.log('Provided Arguments:');
  console.log({ audioFilePath, language, audioFormat });

  return await transcriptionTool.execute(
    { audioFilePath, language, audioFormat },
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
    case Tool.Transcription: {
      const result = await transcription(args[1], args[2], args[3]);
      console.log(result);
      break;
    }
    default:
      console.log(`Provided tool "${toolName}" does not exist`);
      console.log('Available tools:', Object.values(Tool));
  }
}

main().catch(console.error);
