const fs = require('fs');
let defineArray = require('./doc.json');
const util = require("util");

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
    let wl = (...a) => wla(s => ((tmp += '\n' + s), (s)), ...a);

    for (const define of defineList) {
      if (define.type == 'variable') {
        for (const oNode of define.defines.map(e => e.extends)) {
          switch (oNode.type) {
            case 'function':
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
              break;
          }
        }
      }
    }
    if (tmp) {
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
  fs.writeFileSync('./build/SUMMARY.md', tmp);
}
