const {chromium}=require('playwright');(async()=>{
const b=await chromium.launch();const p=await b.newPage({viewport:{width:1100,height:900}});
await p.goto('file:///home/claude/case-study/index.html');await p.waitForTimeout(800);
// force lazy images, open details, list all ideas in two columns
await p.evaluate(async()=>{document.querySelectorAll('img[loading=lazy]').forEach(i=>i.loading='eager');document.querySelectorAll('details').forEach(d=>d.open=true);
 
 await document.fonts.ready;});
await p.waitForTimeout(1500);
await p.emulateMedia({media:'print'});
await p.pdf({path:'/home/claude/case-study/Leela_Shankar_Alumni_Connections_Case_Study_v2_raw.pdf',format:'Letter',printBackground:true,preferCSSPageSize:true,displayHeaderFooter:true,headerTemplate:'<div></div>',footerTemplate:'<div style="font:9px Instrument Sans,sans-serif;color:#5C6168;width:100%;padding:0 12mm;display:flex;justify-content:space-between"><span>Leela Shankar · Alumni Connections, a Human-Centered Design Case Study</span><span>Page <span class="pageNumber"></span> of <span class="totalPages"></span></span></div>'});
await b.close();})()
