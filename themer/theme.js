/* eslint-disable import/extensions */
const path = require('path');
const fs = require('fs');
const minimist = require('minimist');
const itermColors = require('./models.js').itermColors;
const vscodeColors = require('./models.js').vscodeColors;
const itermFonts = require('./models.js').itermFonts;
const vscodeFonts = require('./models.js').vscodeFonts;
const themeExists = require('./util.js').themeExists;
const load = require('./util.js').load;
const loadRaw = require('./util.js').loadRaw;

const argv = minimist(process.argv.slice(2)); // For parsing arguments

const themerRoot = path.join(process.env.ADRYDDOTFILES, 'themer');

const saved = load(path.join(themerRoot, 'saved.json'), path.join(themerRoot, 'saved.defaults.json'));

const work = {};

let vscode = load(path.join(themerRoot, 'vscode.json'), path.join(themerRoot, 'vscode.defaults.json'));
let iterm = load(path.join(themerRoot, 'iterm.json'), path.join(themerRoot, 'iterm.defaults.json')).Profiles[0];
let prompt = loadRaw(path.join(themerRoot, 'termvar'), path.join(themerRoot, 'termvar.defaults'));
const params = {
  saveState: 0,
};

/*
 * Save State
 * 0: Saves changes to "current"
 * 1: Saves changes to "default"
 */
if (argv.color) {
  const type = 'color';
  work[type] = themeExists(argv[type], type, themerRoot, saved.default[type]);
  const theme = load(path.join(themerRoot, 'themes', type, work[type]));
  iterm = Object.assign(iterm, itermColors(theme));
  vscode = Object.assign(vscode, vscodeColors(theme));
}

if (argv.font) {
  const type = 'font';
  work[type] = themeExists(argv[type], type, themerRoot, saved.default[type]);
  const theme = load(path.join(themerRoot, 'themes', type, work[type]));
  iterm = Object.assign(iterm, itermFonts(theme));
  vscode = Object.assign(vscode, vscodeFonts(theme));
}

if (argv.prompt) {
  const type = 'prompt';
  work[type] = themeExists(argv[type], type, themerRoot, saved.default[type]);
  const location = path.join(themerRoot, 'themes', type, work[type]);
  prompt = `source ${location}`;
}

// creating theme to load

fs.writeFileSync(path.join(themerRoot, 'saved.json'), (() => {
  const theme = saved;
  if (params.saveState === 1) {
    theme.default = Object.assign(saved.default, work);
  }
  theme.current = Object.assign(saved.current, work);
  return JSON.stringify(theme);
})());

fs.writeFileSync(path.join(themerRoot, 'vscode.json'), JSON.stringify(vscode));
fs.writeFileSync(path.join(themerRoot, 'iterm.json'), JSON.stringify({ Profiles: [iterm] }));
fs.writeFileSync(path.join(themerRoot, 'termvar'), prompt);
