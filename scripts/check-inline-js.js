const fs = require("node:fs");

const html = fs.readFileSync("index.html", "utf8");
const match = html.match(/<script>([\s\S]*)<\/script>\s*<\/body>/);

if (!match) {
  throw new Error("Could not find the inline app script in index.html.");
}

new Function(match[1]);
console.log("inline script syntax ok");

