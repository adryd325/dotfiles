const OFF = 0;
const WARN = 1;
const ERROR = 2;

module.exports = {
  extends: ["eslint:recommended"],
  parserOptions: {
    ecmaVersion: 2018,
  },
  env: {
    browser: true,
    es6: true,
    node: true,
  },
  rules: {
    indent: OFF,
    semi: WARN,
    quotes: [WARN, "double", {avoidEscape: true, allowTemplateLiterals: true}],
    "no-empty": WARN,
    "array-callback-return": ERROR,
    "consistent-return": WARN,
    eqeqeq: OFF,
    "prefer-const": WARN,
    "no-unused-vars": [WARN, {args: "none", varsIgnorePattern: "^_"}],
    "no-console": OFF,
    "no-debugger": OFF,
    "require-atomic-updates": OFF,
  },
  globals: {
    hh: true,
    magicrequire: true,
    DiscordNative: true,
  },
};
