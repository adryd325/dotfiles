/* eslint-disable no-console */
const fs = require('fs');
const path = require('path');

function colorConvert(color) {
  const rgb = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(color);
  const convertedColor = {};
  convertedColor['Red Component'] = parseInt(rgb[1], 16) / 255;
  convertedColor['Green Component'] = parseInt(rgb[2], 16) / 255;
  convertedColor['Blue Component'] = parseInt(rgb[3], 16) / 255;
  convertedColor['Color Space'] = 'sRGB';
  // https://eslint.org/docs/rules/prefer-destructuring#when-not-to-use-itqqw
  // eslint-disable-next-line prefer-destructuring
  convertedColor.hex = color;
  return convertedColor;
}

function load(file, fallback) {
  if (fs.existsSync(file)) {
    try {
      return JSON.parse(fs.readFileSync(file));
    } catch (e) {
      console.error(e);
    }
  }
  if (fallback) {
    if (fs.existsSync(fallback)) {
      try {
        return JSON.parse(fs.readFileSync(fallback));
      } catch (e) {
        console.error(e);
      }
    }
  }
  return undefined;
}

function loadRaw(file, fallback) {
  if (fs.existsSync(file)) {
    try {
      return fs.readFileSync(file);
    } catch (e) {
      console.error(e);
    }
  }
  if (fallback) {
    if (fs.existsSync(fallback)) {
      try {
        return fs.readFileSync(fallback);
      } catch (e) {
        console.error(e);
      }
    }
  }
  return undefined;
}

function themeExists(theme, type, root, fallback) {
  if (fs.existsSync(path.join(root, 'themes', type, `${theme}`))) {
    return theme;
  }
  console.warn(`the ${type} theme "${theme}" doesn't exist.`);
  console.warn('Loading default theme');
  return fallback;
}

module.exports = {
  colorConvert,
  themeExists,
  load,
  loadRaw,
};
