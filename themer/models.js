/* eslint-disable import/extensions */
/* eslint-disable arrow-parens */
const colorConvert = require('./util.js').colorConvert;

const allowedItermColorVariables = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  'backgroundColor',
  'foregroundColor',
  'linkColor',
  'cursorColor',
  'cursorTextColor',
  'selectionColor',
  'selectedTextColor',
];

const zshPrompt = {};

function itermFonts(theme) {
  const work = {};
  work['Horizontal Spacing'] = theme.horizontalSpacing;
  work['Vertical Spacing'] = theme.verticalSpacing;
  work['Normal Font'] = `${theme.normalFont} ${theme.normalFontSize}`;
  work['Non Ascii Font'] = `${theme.nonAsciiFont} ${theme.nonAsciiFontSize}`;
  work['Use Non-ASCII Font'] = theme.useNonAsciiFont;
  work['Draw Powerline Glyphs'] = !theme.hasPowerline;
  work['ASCII Anti Aliased'] = theme.antialiased;
  work['Non-ASCII Anti Aliased'] = theme.antialiased;
  return work;
}

function vscodeFonts(theme) {
  const work = {};
  work['editor.fontFamily'] = `${theme.normalFont}, ${theme.nonAsciiFont}, monospace`;
  work['editor.fontSize'] = theme.normalFontSize;
  work['editor.fontLignatures'] = theme.supportsLingatures;
  return work;
}

function itermColors(theme) {
  const work = {};
  const colors = [];
  Object.entries(theme).forEach((i) => {
    if (allowedItermColorVariables.includes(i[0])) {
      colors[i[0]] = colorConvert(i[1]);
    }
  });
  for (let i = 0; i <= 15; i += 1) {
    work[`Ansi ${i} Color`] = colors[i];
  }
  work['Background Color'] = colors.backgroundColor;
  work['Foreground Color'] = colors.foregroundColor;
  work['Link Color'] = colors.linkColor;
  work['Cursor Color'] = colors.cursorColor;
  work['Cursor Text Color'] = colors.cursorTextColor;
  work['Selection Color'] = colors.selectionColor;
  work['Selected Text Color'] = colors.selectedTextColor;
  return work;
}

function vscodeColors(theme) {
  const work = {};
  work['workbench.colorTheme'] = theme.vscodeName;
  return work;
}

module.exports = {
  vscodeColors, itermColors, vscodeFonts, itermFonts, zshPrompt,
};
