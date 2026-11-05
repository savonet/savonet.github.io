"use strict";(self.webpackChunksite=self.webpackChunksite||[]).push([["20339"],{9526(e,t,r){r.d(t,{A:()=>n});var s=r(74848);r(96540);var a=r(19863);function n({children:e,fallback:t}){return(0,a.A)()?(0,s.jsx)(s.Fragment,{children:e?.()}):t??null}},93378(e,t,r){r.r(t),r.d(t,{default:()=>c});var s=r(74848),a=r(96540),n=r(2323),i=r(9526),l=r(66497);let d={page:"page_Z4jp",missing:"missing_gJhG",panes:"panes_R5Cq",pane:"pane_wa0y",paneTitle:"paneTitle_eSVk",editor:"editor_nGvc",toolbar:"toolbar_JPt6",spacer:"spacer_yFNR",primary:"primary_HMQu",quiet:"quiet_N2oE",hint:"hint_Gurd",kbd:"kbd_Jfvq",loading:"loading_Ps3F",spinner:"spinner_LOUg",spin:"spin_NAEy",switcher:"switcher_RpjB",hiddenSmall:"hiddenSmall_CMVE"};function o(){let e=(0,l.Ay)("/try/playground.bundle.js"),t=(0,l.Ay)("/try/interactive_js.bc.js"),r=(0,a.useRef)(null),n=(0,a.useRef)(!1);return(0,a.useEffect)(()=>{let s=r.current;if(!s||n.current)return;n.current=!0;let a=["clear","format","execute"].map(e=>{let t;return t=`#${e}`,s.querySelector(t)}),i=e=>{let t=s.querySelector("[data-loading]");t&&(t.textContent=e)};for(let[r,s]of[[t,"preload"],[e,"modulepreload"]]){let e=document.createElement("link");e.rel=s,"preload"===s&&(e.as="script"),e.href=r,document.head.appendChild(e)}let l=document.createElement("script");l.src=t,l.onerror=()=>i("The interpreter is built by Liquidsoap\u2019s CI and is missing from this build."),l.onload=()=>{let t=document.createElement("script");t.type="module",t.src=e,t.onerror=()=>i("The editor bundle is missing from this build."),t.onload=()=>window.onload?.(new Event("load")),document.body.appendChild(t)},document.body.appendChild(l);let o=setInterval(()=>{if(s.querySelector(".cm-editor")){for(let e of(clearInterval(o),a))e&&(e.disabled=!1);s.querySelector("[data-loading]")?.setAttribute("hidden",""),s.querySelector("[data-shortcut]")?.removeAttribute("hidden")}},100),c=/mac/i.test(navigator.platform),u=s.querySelector("[data-mod]");u&&(u.textContent=c?"\u2318":"Ctrl");let p=e=>{"Enter"===e.key&&(c?e.metaKey:e.ctrlKey)&&(e.preventDefault(),s.querySelector("#execute")?.click())};document.addEventListener("keydown",p);let b=s.querySelector("#code"),h=s.querySelector("#results"),m=e=>()=>{b?.classList.toggle(d.hiddenSmall,"code"!==e),h?.classList.toggle(d.hiddenSmall,"results"!==e)},y=m("code"),v=m("results");return s.querySelector("#switch-code")?.addEventListener("click",y),s.querySelector("#switch-results")?.addEventListener("click",v),()=>{clearInterval(o),document.removeEventListener("keydown",p)}},[e,t]),(0,s.jsx)("main",{className:d.page,ref:r,dangerouslySetInnerHTML:{__html:`
  <div class="${d.switcher}">
    <button type="button" id="switch-code">See Code</button>
    <button type="button" id="switch-results">See Results</button>
  </div>

  <div class="${d.panes}">
    <section class="${d.pane}" id="code">
      <div class="${d.paneTitle}">Script</div>
      <div class="${d.editor}" id="input">
        <textarea rows="20" cols="70" spellcheck="false"
          aria-label="Liquidsoap script"># Interpreter loading.. \u{23F3}</textarea>
      </div>
      <div class="${d.toolbar}">
        <label class="${d.hint}" for="themes">Theme</label>
        <select id="themes" aria-label="Editor theme"></select>
        <span class="${d.spacer}"></span>
        <span class="${d.loading}" data-loading>
          <span class="${d.spinner}" aria-hidden="true"></span> Loading the interpreter\u{2026}
        </span>
        <span class="${d.hint}" data-shortcut hidden>
          <kbd class="${d.kbd}" data-mod></kbd> <kbd class="${d.kbd}">\u{21B5}</kbd>
        </span>
        <button type="button" id="clear" class="${d.quiet}" disabled>Clear</button>
        <button type="button" id="format" disabled>Format</button>
        <button type="button" id="execute" class="${d.primary}" disabled>Execute</button>
      </div>
    </section>

    <section class="${d.pane} ${d.hiddenSmall}" id="results">
      <div class="${d.paneTitle}">Output</div>
      <div class="${d.editor}">
        <textarea id="output" rows="20" cols="70" readonly aria-label="Script output"></textarea>
      </div>
    </section>
  </div>
`}})}function c(){return(0,s.jsx)(n.A,{title:"Playground",description:"Run Liquidsoap scripts in your browser. The interpreter runs locally, nothing is sent to a server.",children:(0,s.jsx)(i.A,{children:()=>(0,s.jsx)(o,{})})})}}}]);