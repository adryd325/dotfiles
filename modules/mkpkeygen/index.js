// keygen for something that had such simple checking I decided to just crack it
// Usage: node index.js <email> <key>
const crypto = require('crypto');
const argv = process.argv.slice(2);

if (argv.length !== 2) {
    process.exit(1);
}

// I'm not even fucking kiding
const key = crypto.createHash('md5')
    .update(`${argv[0]}${argv[1]}`)
    .digest('hex')
    .match(/.{1,5}/g)
    .slice(0, 5)
    .join("-");

console.log(key);