# Agents

## Tool calling

- when requesting programming language features, examples, improvements or help
  - then extent your context with `context7`
- when requesting data from the internet via cli tools that return in problems because of javascript
  - then use the `browser` tool to open the browser and continue there
- when requesting to transcribe an audio file, use the workflow described in [[#audio transcription]]

## Audio transcription

NOTE: the API token is stored in the `DEEPGRAM_API_KEY` environment variable

**NEVER EXPOSE THE API KEY**

1. Insert the relevant audio file into the --data-binary argument, therefore replace the <audio-file> placeholder
2. Update the audio format to the one you want to transcribe, therefore replace the <audio-format> placeholder
3. Insert the language, if not further specified, always ask the user for it

```bash
curl -X POST \
  -H "Authorization: Token $DEEPGRAM_API_KEY" \
  -H 'content-type: audio/<audio-format>' \
  --data-binary "@<audio-file>" \
  "https://api.deepgram.com/v1/listen?model=nova-2&smart_format=true&language=<language>" \
| jq -r '.results.channels[0].alternatives[0].transcript'
```
