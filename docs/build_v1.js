const fs = require('fs');
const { TextDecoder } = require('util');

let dirs = fs.readdirSync("./");
let td = new TextDecoder('gbk')
let dataset = [];
for (const d of dirs) {
    if (/\.lua$/i.test(d)) {
        let lua = td.decode(fs.readFileSync(d));
        // console.log(lua);
        lua = lua.split(/\r\n/);
        let tmp = [];
        for (const line of lua) {
            if (/---@meta _/i.test(line)) {
                continue;
            }
            // console.log(line);
            if (line.trim() === "") {
                if (tmp.length > 0) {
                    dataset.push({ text: tmp.join("\n") });
                    tmp = [];
                }
            } else {
                tmp.push(line);
            }
        }
        if (tmp.length > 0) {
            dataset.push({ text: tmp.join("\n") });
            tmp = [];
        }
    }
}

fs.writeFileSync("lua_api4.json", JSON.stringify(dataset));