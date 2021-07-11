import fs from "fs";
import path from "path";
import url from "url";

const AR_DIR = path.join(path.dirname(url.fileURLToPath(import.meta.url)), "..");

const scriptsToPatch = (
    await fs.promises.readFile(path.join(AR_DIR, ".static-const"), {
        encoding: "utf-8",
    })
).split("\n");

const constants = await fs.promises.readFile(path.join(AR_DIR, "constants.sh"), { encoding: "utf-8" });
const match = new RegExp(`# --- BEGIN CONSTANTS ---(.|\n)+# --- END CONSTANTS ---`);
const replacement = () => {
    return `# --- BEGIN CONSTANTS --- \n${constants}# --- END CONSTANTS ---`;
};

for (const script of scriptsToPatch) {
    if (script === "") continue;
    const scriptPath = path.join(AR_DIR, script);
    const scriptData = await fs.promises.readFile(scriptPath, { encoding: "utf-8" });
    fs.promises.writeFile(scriptPath, scriptData.replace(match, replacement));
}
//asdf