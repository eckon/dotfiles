# Agents

## Self-reflection

When giving a final response always provide a confidence score (0-100%).

## Tool calling

- when requesting programming language features, examples, improvements or help
  - then extent your context with `context7`
- when requesting data from the internet via cli tools that return in problems because of javascript
  - then use the `browser` tool to open the browser and continue there
- when requesting `transcription` of a audio file, always summarize the result in a short bullet point list
  - if applicable, group the lists with a helpful heading
  - if the language is not English please translate it beforehand
