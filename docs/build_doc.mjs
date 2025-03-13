import fetch from 'node-fetch'
import fs from 'fs';
import util from "util";

global.fetch = fetch;
import ollama from "ollama"
const defineArray = JSON.parse(fs.readFileSync('./doc.json', 'utf8'));

Array.prototype.groupBy = function (fn) {
  let o = {};
  for (const el of this) {
    let k = fn(el);
    let r = o[k] || [];
    o[k] = r;
    r.push(el);
  }
  return Object.keys(o).map(k => [k, o[k]]);
}

String.prototype.color = function (c) {
  return `\x1b[${c}m` + this + '\x1b[0m';
}

let fileMap = defineArray
  .filter(e => e.defines[0] && /docs[\\/].+\.lua$/i.test(e.defines[0].file))
  .groupBy(el => (el.defines[0].file.match(/[a-z\.]+$/i) + '').match(/^[^\.]+/))
  .filter(e => !/(CONST|types|docs|Ext|Module)/i.test(e[0]));

if (!fs.existsSync('./build'))
  fs.mkdirSync('./build')
fs.readdirSync('./build').forEach(e => fs.unlinkSync('./build/' + e));

function wla(fn, s, ...a) {
  let ss = util.format(s === null || s === undefined ? '' : s, ...a);
  fn(ss);
}

const typeStr = (s) => s && (s[s.length - 1] === '?' ? s + '[可选参数]' : s) || '';
let dataset = [];
let wlSet = {};

const wlSetWr = (group, name, desc, md) => {
  let g = wlSet[group] = wlSet[group] || {};
  if (g[name]) {
    g[name].md += "\n\n\n\n" + md;
    return;
  }
  g[name] = { desc, md };
}

async function main() {
  for (let [file, defines] of fileMap) {
    const log = (...a) => wla(console.log, ...a);
    log(`File > ${file} ${defines.length}`.color(33));
    defines = defines.groupBy(e => {
      let m = e.rawdesc && e.rawdesc.match(/\[@group (.*)\]/i);
      if (m) {
        return m[1];
      }
      return e.name;
    });
    for (const [group, defineList] of defines) {
      log("Group", group);
      let tmp = '';
      let tmp2 = '';
      let wl = (...a) => wla(s => ((tmp += '\n' + s), (tmp2 += '\n' + s), (s)), ...a);

      for (const define of defineList) {
        if (define.type == 'variable') {
          for (const oNode of define.defines.map(e => e.extends)) {
            switch (oNode.type) {
              case 'function':
                tmp2 = "";
                wl(`# ${define.name}`);
                wl(`# ${define.name}(${oNode.args.map(e => `${e.type === '...' ? '...[变长参数]' : e.name}: ${e.view}`).join(', ')})`);


                wl('## 函数功能');
                wl((oNode.desc || '').replace(/\[@group (.*)]/i, '').split('\n\n@*')[0]);

                wl('## 参数说明')
                for (const arg of oNode.args) {
                  wl(` - ${arg.type === '...' ? '...[变长参数]' : arg.name} 类型: ${typeStr(arg.view)} 说明: ${arg.rawdesc || '无'}`);
                }
                wl('## 返回值');
                if (oNode.returns) {
                  for (const ret of oNode.returns) {
                    if (ret.name && ret.name != 'ret') {
                      wl(`${oNode.returns.length > 1 ? ' - ' : ''}${ret.name} 类型: ${typeStr(ret.view)} 说明: ${ret.rawdesc || '无'}`);
                    } else {
                      wl(`${oNode.returns.length > 1 ? ' - ' : ''}类型: ${typeStr(ret.view)} 说明: ${ret.rawdesc || '无'}`);
                    }
                  }
                } else {
                  wl('无')
                }
                wl();
                wlSetWr(group, define.name, (oNode.desc || '').replace(/\[@group (.*)]/i, '').split('\n\n@*')[0], tmp2);
                break;
            }
          }
        }
      }
      if (tmp) {
        // const response = await ollama.chat({
        //   model: 'deepseek-r1:14b',
        //   messages: [{ role: 'assistant', content: "Char/Chara 一般指角色，包含NPC、宠物、玩家， BP指角色属性加点" }, { role: 'user', content: '分析以下cgmsv lua文档, 0. 请全程使用简体中文分析、如果遇到繁体中文请转换到简体中文再处理 \n 1. 从`函数功能`及`API名称`中提取关键字到Keywords, 不应该包含任何参数名字。当遇到回调函数时，请添加函数名称作为关键字之一 \n 2. 函数功能、API 请按原文输出避免任何修改或语言转换 \n3. Content 请直接输出Markdown内容避免任何修改或语言转换 \n 4. 请确保所有函数都在markdown中存在 \n 5. 使用json格式输出, 输出内容请勿包含任何xml格式或语言转换<example>[{"API":"接口名称", "Desc": "函数功能", "Keywords":["XXXX", "YYYYY", Content:"xxxxx"]}]</example> ```markdown\n' + tmp + "\n````" }],
        // })
        // try {
        //   let msg = /```json([\w\W]+)```/i.exec(response.message.content.substring(response.message.content.indexOf("</think>")))[1];
        //   let v = JSON.parse(msg);
        //   console.log(v);
        //   dataset.push(...v);
        // } catch (e) {
        //   console.log(e);
        //   console.log(response.message.content);
        // }
        fs.writeFileSync("./build/" + group + '.md', tmp);
      }
    }
  }

  {

    let tmp = '';
    let wl = (...a) => wla(s => ((tmp += '\n' + s), (s)), ...a);
    wl(`# Summary\n\n* [cgmsv引擎介绍](README.md)`)
    for (let [file, defines] of fileMap) {
      wl(`* ${file}库`);
      defines = defines.groupBy(e => {
        let m = e.rawdesc && e.rawdesc.match(/\[@group (.*)\]/i);
        if (m) {
          return m[1];
        }
        return e.name;
      });
      for (const [group, defineList] of defines) {
        if (fs.existsSync(`./build/${group}.md`))
          wl(`    * [${group}](${group}.md)`);
      }
      wl();
    }
    wl(`* 附录
    * [字符串](appendix.string.md)
    * [对象index](appendix.Obj.index.md)
    * [布尔型](appendix.bool.md)
    * [常量](appendix.const.md)
    * [战斗index](appendix.Battle.index.md)
    * [数值型](appendix.numeric.md)
    * [道具index](appendix.Item.index.md)`);
    dataset.push({ text: "```markdown\nCGMSV LUA " + tmp + "\n```" });
    fs.writeFileSync('./build/SUMMARY.md', tmp);
  }
  for (const gn of Object.keys(wlSet)) {
    let g = wlSet[gn];
    for (const fn of Object.keys(g)) {
      dataset.push({ text: "```markdown\n# " + gn.match(/^[^\.]+/)[0] + '库\n\n' + g[fn].md.trim() + '\n```' });
    }
  }
  dataset.push({ text: "CGMSV CONST常量表```lua\n" +  new util.TextDecoder('gbk').decode(fs.readFileSync("CONST.lua")) + "\n```" });
  fs.writeFileSync("./lua_api3.json", JSON.stringify(dataset));
}
main();