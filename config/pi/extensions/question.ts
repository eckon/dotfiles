/**
 * Question Tool - Ask the user a followup question with selectable options
 * and an option to type a custom answer.
 */

import type { ExtensionAPI } from '@earendil-works/pi-coding-agent';
import {
  Editor,
  type EditorTheme,
  Key,
  matchesKey,
  Text,
  truncateToWidth,
} from '@earendil-works/pi-tui';
import { Type } from 'typebox';

interface QuestionDetails {
  question: string;
  options: string[];
  answer: string | null;
  wasCustom?: boolean;
}

const QuestionParams = Type.Object({
  question: Type.String({
    description: 'The followup question to ask the user',
  }),
  options: Type.Array(Type.String(), {
    description: 'Options for the user to choose from',
  }),
});

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: 'ask_user',
    label: 'Ask User',
    description:
      'Ask the user a followup question when you need clarification or input to proceed. ' +
      'Provide a clear question and a list of suggested options. ' +
      'The user can pick one of the options or type a custom answer.',
    promptSnippet:
      'Ask the user a followup question with selectable options or custom input',
    promptGuidelines: [
      'Use ask_user when you need clarification or user input before proceeding, rather than guessing',
    ],
    parameters: QuestionParams,

    async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
      if (!ctx.hasUI) {
        return {
          content: [
            {
              type: 'text',
              text: 'Error: UI not available (non-interactive mode)',
            },
          ],
          details: {
            question: params.question,
            options: params.options,
            answer: null,
          } as QuestionDetails,
        };
      }

      if (params.options.length === 0) {
        return {
          content: [{ type: 'text', text: 'Error: No options provided' }],
          details: {
            question: params.question,
            options: [],
            answer: null,
          } as QuestionDetails,
        };
      }

      const allLabels = [...params.options, 'Type custom answer...'];

      const result = await ctx.ui.custom<{
        answer: string;
        wasCustom: boolean;
        index?: number;
      } | null>((tui, theme, _kb, done) => {
        let optionIndex = 0;
        let editMode = false;
        let cachedLines: string[] | undefined;

        const editorTheme: EditorTheme = {
          borderColor: s => theme.fg('accent', s),
          selectList: {
            selectedPrefix: t => theme.fg('accent', t),
            selectedText: t => theme.fg('accent', t),
            description: t => theme.fg('muted', t),
            scrollInfo: t => theme.fg('dim', t),
            noMatch: t => theme.fg('warning', t),
          },
        };
        const editor = new Editor(tui, editorTheme);

        editor.onSubmit = value => {
          const trimmed = value.trim();
          if (trimmed) {
            done({ answer: trimmed, wasCustom: true });
          } else {
            editMode = false;
            editor.setText('');
            refresh();
          }
        };

        function refresh() {
          cachedLines = undefined;
          tui.requestRender();
        }

        function handleInput(data: string) {
          if (editMode) {
            if (matchesKey(data, Key.escape)) {
              editMode = false;
              editor.setText('');
              refresh();
              return;
            }
            editor.handleInput(data);
            refresh();
            return;
          }

          if (matchesKey(data, Key.up) || matchesKey(data, 'k')) {
            optionIndex = Math.max(0, optionIndex - 1);
            refresh();
            return;
          }
          if (matchesKey(data, Key.down) || matchesKey(data, 'j')) {
            optionIndex = Math.min(allLabels.length - 1, optionIndex + 1);
            refresh();
            return;
          }

          if (matchesKey(data, Key.enter)) {
            if (optionIndex === allLabels.length - 1) {
              editMode = true;
              refresh();
            } else {
              done({
                answer: params.options[optionIndex],
                wasCustom: false,
                index: optionIndex + 1,
              });
            }
            return;
          }

          if (matchesKey(data, Key.escape)) {
            done(null);
          }
        }

        function render(width: number): string[] {
          if (cachedLines) return cachedLines;

          const lines: string[] = [];
          const add = (s: string) => lines.push(truncateToWidth(s, width));

          add(theme.fg('accent', '─'.repeat(width)));
          add(theme.fg('text', ` ${params.question}`));
          lines.push('');

          for (let i = 0; i < allLabels.length; i++) {
            const selected = i === optionIndex;
            const isCustom = i === allLabels.length - 1;
            const prefix = selected ? theme.fg('accent', '> ') : '  ';

            if (isCustom && editMode) {
              add(prefix + theme.fg('accent', `${i + 1}. ${allLabels[i]} ✎`));
            } else if (selected) {
              add(prefix + theme.fg('accent', `${i + 1}. ${allLabels[i]}`));
            } else {
              add(`  ${theme.fg('text', `${i + 1}. ${allLabels[i]}`)}`);
            }
          }

          if (editMode) {
            lines.push('');
            add(theme.fg('muted', ' Your answer:'));
            for (const line of editor.render(width - 2)) {
              add(` ${line}`);
            }
          }

          lines.push('');
          if (editMode) {
            add(theme.fg('dim', ' Enter to submit • Esc to go back'));
          } else {
            add(
              theme.fg(
                'dim',
                ' ↑↓/j/k navigate • Enter to select • Esc to cancel',
              ),
            );
          }
          add(theme.fg('accent', '─'.repeat(width)));

          cachedLines = lines;
          return lines;
        }

        return {
          render,
          invalidate: () => {
            cachedLines = undefined;
          },
          handleInput,
        };
      });

      if (!result) {
        return {
          content: [{ type: 'text', text: 'User cancelled the selection' }],
          details: {
            question: params.question,
            options: params.options,
            answer: null,
          } as QuestionDetails,
        };
      }

      if (result.wasCustom) {
        return {
          content: [{ type: 'text', text: `User answered: ${result.answer}` }],
          details: {
            question: params.question,
            options: params.options,
            answer: result.answer,
            wasCustom: true,
          } as QuestionDetails,
        };
      }

      return {
        content: [
          {
            type: 'text',
            text: `User selected option ${result.index}: ${result.answer}`,
          },
        ],
        details: {
          question: params.question,
          options: params.options,
          answer: result.answer,
          wasCustom: false,
        } as QuestionDetails,
      };
    },

    renderCall(args, theme, _context) {
      let text =
        theme.fg('toolTitle', theme.bold('ask_user ')) +
        theme.fg('muted', args.question ?? '');
      const opts = Array.isArray(args.options) ? args.options : [];
      if (opts.length) {
        const numbered = [...opts, 'Type custom answer...'].map(
          (o, i) => `${i + 1}. ${o}`,
        );
        text += `\n${theme.fg('dim', `  Options: ${numbered.join(', ')}`)}`;
      }
      return new Text(text, 0, 0);
    },

    renderResult(result, _options, theme, _context) {
      const details = result.details as QuestionDetails | undefined;
      if (!details) {
        const text = result.content[0];
        return new Text(text?.type === 'text' ? text.text : '', 0, 0);
      }

      if (details.answer === null) {
        return new Text(theme.fg('warning', 'Cancelled'), 0, 0);
      }

      if (details.wasCustom) {
        return new Text(
          theme.fg('success', '✓ ') +
            theme.fg('muted', '(custom) ') +
            theme.fg('accent', details.answer),
          0,
          0,
        );
      }

      const idx = details.options.indexOf(details.answer) + 1;
      const display = idx > 0 ? `${idx}. ${details.answer}` : details.answer;
      return new Text(
        theme.fg('success', '✓ ') + theme.fg('accent', display),
        0,
        0,
      );
    },
  });
}
