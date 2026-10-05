import js from '@eslint/js';
import globals from 'globals';
import tseslint from 'typescript-eslint';

// NOTE: package.json pins `typescript` to ^6 on purpose.
// typescript-eslint does not support TS 7 (no programmatic API until TS 7.1).
// Revisit once typescript-eslint supports TS >= 7.1:
// https://github.com/typescript-eslint/typescript-eslint/issues/10940

export default tseslint.config(
  js.configs.recommended,
  ...tseslint.configs.recommended,
  {
    files: ['**/*.{js,mjs,cjs,ts,mts,cts}'],
    languageOptions: {
      globals: globals.browser,
    },
  },
);
