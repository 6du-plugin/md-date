require! <[
  dayjs  
]>
require! {
  \js-yaml : yaml
  \fs-extra : fs
}

日期 = '日期'

module.exports = (buf)~>
  filepath = buf.path
  buf = buf.toString(\utf-8)
  buf = buf.replace(/\r\n/g,"\n").replace(/\r/g,"\n")
  pos = buf.indexOf("\n------\n")
  if pos + 1
    console.log filepath
    ptxt = buf.slice(0,pos)
    atxt = buf.slice(pos)
    spos = ptxt.lastIndexOf('\n---\n')

    if spos + 1
      spos = spos+5
      head = ptxt.slice(0, spos)
      meta = ptxt.slice(spos)
    else
      head = ""
      meta = ptxt

    meta = yaml.safeLoad meta
    if not (日期 of meta)
      date = (await fs.stat(filepath)).ctime
    else
      date = meta[日期]
      delete meta[日期]

    li = []
    for k,v of meta
      li.push "#k : #v"
    li.sort()
    li.push "#{日期} : "+date.toISOString().replace('T',' ').split(".")[0]

    meta = li.join '\n'
    ptxt = head+'\n'+meta+"\n"
    return ptxt+atxt
  return buf

