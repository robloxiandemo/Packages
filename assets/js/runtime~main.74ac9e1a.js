(()=>{"use strict";var e,t,r,f,o,a={},n={};function c(e){var t=n[e];if(void 0!==t)return t.exports;var r=n[e]={exports:{}};return a[e].call(r.exports,r,r.exports,c),r.exports}c.m=a,e=[],c.O=(t,r,f,o)=>{if(!r){var a=1/0;for(b=0;b<e.length;b++){r=e[b][0],f=e[b][1],o=e[b][2];for(var n=!0,d=0;d<r.length;d++)(!1&o||a>=o)&&Object.keys(c.O).every((e=>c.O[e](r[d])))?r.splice(d--,1):(n=!1,o<a&&(a=o));if(n){e.splice(b--,1);var i=f();void 0!==i&&(t=i)}}return t}o=o||0;for(var b=e.length;b>0&&e[b-1][2]>o;b--)e[b]=e[b-1];e[b]=[r,f,o]},c.n=e=>{var t=e&&e.__esModule?()=>e.default:()=>e;return c.d(t,{a:t}),t},r=Object.getPrototypeOf?e=>Object.getPrototypeOf(e):e=>e.__proto__,c.t=function(e,f){if(1&f&&(e=this(e)),8&f)return e;if("object"==typeof e&&e){if(4&f&&e.__esModule)return e;if(16&f&&"function"==typeof e.then)return e}var o=Object.create(null);c.r(o);var a={};t=t||[null,r({}),r([]),r(r)];for(var n=2&f&&e;"object"==typeof n&&!~t.indexOf(n);n=r(n))Object.getOwnPropertyNames(n).forEach((t=>a[t]=()=>e[t]));return a.default=()=>e,c.d(o,a),o},c.d=(e,t)=>{for(var r in t)c.o(t,r)&&!c.o(e,r)&&Object.defineProperty(e,r,{enumerable:!0,get:t[r]})},c.f={},c.e=e=>Promise.all(Object.keys(c.f).reduce(((t,r)=>(c.f[r](e,t),t)),[])),c.u=e=>"assets/js/"+({53:"935f2afb",174:"c3b7f829",233:"be0547bb",246:"b3f6f813",273:"af5cd4f0",283:"caa31cbe",327:"618ec9d1",374:"d3874e59",438:"9b4020ff",476:"ce5ff496",478:"ff842b8b",514:"1be78505",531:"100cbf86",553:"1ff659d4",561:"b57d94b2",656:"16e542bd",671:"0e384e19",711:"4f87ea27",788:"3ef85d53",817:"236fd2df",851:"72fe40c0",918:"17896441",950:"fa6ea632"}[e]||e)+"."+{53:"fe17ae86",174:"ad885bc7",233:"e1a9d90e",245:"4533cda9",246:"fdfee6dd",273:"d21c004c",283:"fa84ce0a",327:"53fe9ec3",343:"0365238a",374:"295630a0",438:"ebe1332d",476:"5947986c",478:"27c14c9c",514:"a99f56fd",531:"5ef52392",553:"59c3352d",561:"42166365",656:"5b334098",671:"7eacd3f3",711:"eae5b337",788:"192b0dd4",817:"60c3a31d",851:"07afda09",878:"055ad319",918:"44ed20db",950:"446bf290",972:"d6d4b8fb"}[e]+".js",c.miniCssF=e=>{},c.g=function(){if("object"==typeof globalThis)return globalThis;try{return this||new Function("return this")()}catch(e){if("object"==typeof window)return window}}(),c.o=(e,t)=>Object.prototype.hasOwnProperty.call(e,t),f={},o="docs:",c.l=(e,t,r,a)=>{if(f[e])f[e].push(t);else{var n,d;if(void 0!==r)for(var i=document.getElementsByTagName("script"),b=0;b<i.length;b++){var u=i[b];if(u.getAttribute("src")==e||u.getAttribute("data-webpack")==o+r){n=u;break}}n||(d=!0,(n=document.createElement("script")).charset="utf-8",n.timeout=120,c.nc&&n.setAttribute("nonce",c.nc),n.setAttribute("data-webpack",o+r),n.src=e),f[e]=[t];var l=(t,r)=>{n.onerror=n.onload=null,clearTimeout(s);var o=f[e];if(delete f[e],n.parentNode&&n.parentNode.removeChild(n),o&&o.forEach((e=>e(r))),t)return t(r)},s=setTimeout(l.bind(null,void 0,{type:"timeout",target:n}),12e4);n.onerror=l.bind(null,n.onerror),n.onload=l.bind(null,n.onload),d&&document.head.appendChild(n)}},c.r=e=>{"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},c.p="/Roblox-Modules/",c.gca=function(e){return e={17896441:"918","935f2afb":"53",c3b7f829:"174",be0547bb:"233",b3f6f813:"246",af5cd4f0:"273",caa31cbe:"283","618ec9d1":"327",d3874e59:"374","9b4020ff":"438",ce5ff496:"476",ff842b8b:"478","1be78505":"514","100cbf86":"531","1ff659d4":"553",b57d94b2:"561","16e542bd":"656","0e384e19":"671","4f87ea27":"711","3ef85d53":"788","236fd2df":"817","72fe40c0":"851",fa6ea632:"950"}[e]||e,c.p+c.u(e)},(()=>{var e={303:0,532:0};c.f.j=(t,r)=>{var f=c.o(e,t)?e[t]:void 0;if(0!==f)if(f)r.push(f[2]);else if(/^(303|532)$/.test(t))e[t]=0;else{var o=new Promise(((r,o)=>f=e[t]=[r,o]));r.push(f[2]=o);var a=c.p+c.u(t),n=new Error;c.l(a,(r=>{if(c.o(e,t)&&(0!==(f=e[t])&&(e[t]=void 0),f)){var o=r&&("load"===r.type?"missing":r.type),a=r&&r.target&&r.target.src;n.message="Loading chunk "+t+" failed.\n("+o+": "+a+")",n.name="ChunkLoadError",n.type=o,n.request=a,f[1](n)}}),"chunk-"+t,t)}},c.O.j=t=>0===e[t];var t=(t,r)=>{var f,o,a=r[0],n=r[1],d=r[2],i=0;if(a.some((t=>0!==e[t]))){for(f in n)c.o(n,f)&&(c.m[f]=n[f]);if(d)var b=d(c)}for(t&&t(r);i<a.length;i++)o=a[i],c.o(e,o)&&e[o]&&e[o][0](),e[o]=0;return c.O(b)},r=self.webpackChunkdocs=self.webpackChunkdocs||[];r.forEach(t.bind(null,0)),r.push=t.bind(null,r.push.bind(r))})()})();