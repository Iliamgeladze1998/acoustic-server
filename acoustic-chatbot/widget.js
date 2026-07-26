/**
 * Acoustic.ge AI Chatbot Widget
 * Auto-initializes when loaded. No dependencies.
 * Backend: http://178.104.173.138:5560
 */
(function () {
  'use strict';

  var SERVER = 'http://178.104.173.138:5560';
  var history = [];
  var isOpen = false;
  var isTyping = false;

  // Prevent double init
  if (window.__acousticChatInit) return;
  window.__acousticChatInit = true;

  // Inject styles
  var css = `
#acoustic-chat-btn{position:fixed;bottom:24px;right:24px;z-index:99998;width:60px;height:60px;border-radius:50%;background:linear-gradient(135deg,#0d6666,#1b9a9a);color:#fff;border:none;cursor:pointer;box-shadow:0 4px 20px rgba(6,63,63,.3);display:flex;align-items:center;justify-content:center;transition:transform .3s cubic-bezier(.22,1,.36,1),box-shadow .3s;}
#acoustic-chat-btn:hover{transform:scale(1.08);box-shadow:0 6px 28px rgba(6,63,63,.4);}
#acoustic-chat-btn svg{width:28px;height:28px;}
#acoustic-chat-btn .badge{position:absolute;top:-2px;right:-2px;width:20px;height:20px;background:#f6a623;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:11px;font-weight:700;color:#fff;animation:acChatPulse 2s infinite;}
@keyframes acChatPulse{0%,100%{opacity:1;transform:scale(1)}50%{opacity:.6;transform:scale(1.15)}}

#acoustic-chat-window{position:fixed;bottom:96px;right:24px;z-index:99999;width:380px;max-width:calc(100vw - 48px);height:560px;max-height:calc(100vh - 130px);background:#fff;border-radius:20px;box-shadow:0 8px 40px rgba(6,63,63,.2);display:none;flex-direction:column;overflow:hidden;animation:acChatSlideUp .35s cubic-bezier(.22,1,.36,1);font-family:'Noto Sans Georgian','Inter',-apple-system,sans-serif;}
@keyframes acChatSlideUp{from{opacity:0;transform:translateY(20px)}to{opacity:1;transform:none}}
#acoustic-chat-window.open{display:flex;}

#ac-chat-header{background:linear-gradient(135deg,#063f3f,#0d6666);color:#fff;padding:16px 20px;display:flex;align-items:center;gap:12px;flex:none;}
#ac-chat-header .avatar{width:40px;height:40px;border-radius:50%;background:rgba(255,255,255,.15);display:flex;align-items:center;justify-content:center;flex:none;}
#ac-chat-header .avatar svg{width:22px;height:22px;}
#ac-chat-header .info{flex:1;}
#ac-chat-header .info h3{font-size:15px;font-weight:700;margin:0;}
#ac-chat-header .info p{font-size:11px;color:rgba(255,255,255,.7);margin:2px 0 0;display:flex;align-items:center;gap:5px;}
#ac-chat-header .info p .dot{width:7px;height:7px;border-radius:50%;background:#4ade80;animation:acChatPulse 2s infinite;}
#ac-chat-header .close{width:32px;height:32px;border-radius:50%;background:rgba(255,255,255,.1);border:none;color:#fff;cursor:pointer;display:flex;align-items:center;justify-content:center;flex:none;transition:background .2s;}
#ac-chat-header .close:hover{background:rgba(255,255,255,.2);}
#ac-chat-header .close svg{width:18px;height:18px;}

#ac-chat-messages{flex:1;overflow-y:auto;padding:16px;display:flex;flex-direction:column;gap:10px;background:#f7fbfb;scrollbar-width:thin;scrollbar-color:#cfe6e6 transparent;}
#ac-chat-messages::-webkit-scrollbar{width:5px;}
#ac-chat-messages::-webkit-scrollbar-thumb{background:#cfe6e6;border-radius:5px;}

.ac-msg{max-width:85%;padding:10px 14px;border-radius:14px;font-size:13.5px;line-height:1.5;animation:acMsgIn .3s ease;}
@keyframes acMsgIn{from{opacity:0;transform:translateY(6px)}to{opacity:1;transform:none}}
.ac-msg.bot{align-self:flex-start;background:#fff;border:1px solid #e6efee;color:#15201e;border-bottom-left-radius:4px;box-shadow:0 1px 3px rgba(0,0,0,.04);}
.ac-msg.user{align-self:flex-end;background:linear-gradient(135deg,#0d6666,#108080);color:#fff;border-bottom-right-radius:4px;}
.ac-msg.typing{align-self:flex-start;background:#fff;border:1px solid #e6efee;color:#96a5a3;font-style:italic;}
.ac-msg.typing .dots{display:inline-flex;gap:3px;margin-left:4px;}
.ac-msg.typing .dots span{width:5px;height:5px;border-radius:50%;background:#0d6666;animation:acTypingDot 1.4s infinite;}
.ac-msg.typing .dots span:nth-child(2){animation-delay:.2s;}
.ac-msg.typing .dots span:nth-child(3){animation-delay:.4s;}
@keyframes acTypingDot{0%,60%,100%{opacity:.2;transform:translateY(0)}30%{opacity:1;transform:translateY(-4px)}}

#ac-chat-input{flex:none;padding:12px 16px;border-top:1px solid #e6efee;background:#fff;display:flex;gap:8px;align-items:center;}
#ac-chat-input input{flex:1;padding:10px 14px;border:1.5px solid #e6efee;border-radius:999px;font-size:13.5px;font-family:inherit;outline:none;transition:border-color .2s;background:#f7fbfb;color:#15201e;}
#ac-chat-input input:focus{border-color:#1b9a9a;background:#fff;}
#ac-chat-input input::placeholder{color:#96a5a3;}
#ac-chat-input button{width:40px;height:40px;border-radius:50%;background:linear-gradient(135deg,#0d6666,#1b9a9a);border:none;color:#fff;cursor:pointer;display:flex;align-items:center;justify-content:center;flex:none;transition:transform .2s,opacity .2s;}
#ac-chat-input button:hover{transform:scale(1.08);}
#ac-chat-input button:disabled{opacity:.4;cursor:not-allowed;transform:none;}
#ac-chat-input button svg{width:19px;height:19px;}

#ac-chat-quick{padding:8px 16px 4px;display:flex;flex-wrap:wrap;gap:6px;background:#fff;border-top:1px solid #f0f5f5;flex:none;}
#ac-chat-quick .chip{padding:6px 12px;border:1px solid #e6efee;border-radius:999px;font-size:11.5px;color:#5b6b69;cursor:pointer;transition:all .2s;background:#f7fbfb;}
#ac-chat-quick .chip:hover{border-color:#1b9a9a;color:#0d6666;background:#eef7f7;}

@media(max-width:640px){
  #acoustic-chat-window{bottom:0;right:0;width:100vw;height:100vh;max-height:100vh;border-radius:0;}
  #acoustic-chat-btn{bottom:16px;right:16px;}
}
`;

  var styleEl = document.createElement('style');
  styleEl.textContent = css;
  document.head.appendChild(styleEl);

  // Create button
  var btn = document.createElement('button');
  btn.id = 'acoustic-chat-btn';
  btn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg><span class="badge">?</span>';
  document.body.appendChild(btn);

  // Create window
  var win = document.createElement('div');
  win.id = 'acoustic-chat-window';
  win.innerHTML = `
    <div id="ac-chat-header">
      <div class="avatar"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg></div>
      <div class="info">
        <h3>აკუსტიკა</h3>
        <p><span class="dot"></span> ონლაინ — პასუხობს AI</p>
      </div>
      <button class="close" onclick="document.getElementById('acoustic-chat-window').classList.remove('open')"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6 6 18M6 6l12 12"/></svg></button>
    </div>
    <div id="ac-chat-messages">
      <div class="ac-msg bot">გამარჯობა! 🎸 მე აკუსტიკის ასისტენტი ვარ. რით შემიძლია დაგეხმარო? მომეკითხეთ პროდუქციის, ფასების, მიტანის ან სერვისის შესახებ.</div>
    </div>
    <div id="ac-chat-quick">
      <div class="chip" onclick="acQuickSend('რა გიტარები გაქვთ?')">რა გიტარები გაქვთ?</div>
      <div class="chip" onclick="acQuickSend('სამუშაო საათები')">სამუშაო საათები</div>
      <div class="chip" onclick="acQuickSend('მიტანა თბილისში')">მიტანა</div>
      <div class="chip" onclick="acQuickSend('სერვისი')">სერვისი</div>
    </div>
    <div id="ac-chat-input">
      <input type="text" id="ac-chat-text" placeholder="დაწერეთ შეკითხვა..." onkeydown="if(event.key==='Enter')acSend()">
      <button id="ac-chat-send" onclick="acSend()"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m22 2-7 20-4-9-9-4z"/><path d="M22 2 11 13"/></svg></button>
    </div>
  `;
  document.body.appendChild(win);

  btn.addEventListener('click', function () {
    isOpen = !isOpen;
    if (isOpen) {
      win.classList.add('open');
      btn.querySelector('.badge').style.display = 'none';
      setTimeout(function () { document.getElementById('ac-chat-text').focus(); }, 300);
    } else {
      win.classList.remove('open');
    }
  });

  function addMessage(text, type) {
    var msgs = document.getElementById('ac-chat-messages');
    var div = document.createElement('div');
    div.className = 'ac-msg ' + type;
    div.textContent = text;
    msgs.appendChild(div);
    msgs.scrollTop = msgs.scrollHeight;
    return div;
  }

  function addTyping() {
    var msgs = document.getElementById('ac-chat-messages');
    var div = document.createElement('div');
    div.className = 'ac-msg typing';
    div.id = 'ac-typing-indicator';
    div.innerHTML = 'აკუსტიკა წერს<span class="dots"><span></span><span></span><span></span></span>';
    msgs.appendChild(div);
    msgs.scrollTop = msgs.scrollHeight;
  }

  function removeTyping() {
    var el = document.getElementById('ac-typing-indicator');
    if (el) el.remove();
  }

  window.acQuickSend = function (text) {
    document.getElementById('ac-chat-text').value = text;
    acSend();
  };

  window.acSend = function () {
    var input = document.getElementById('ac-chat-text');
    var text = input.value.trim();
    if (!text || isTyping) return;

    addMessage(text, 'user');
    history.push({ role: 'user', content: text });
    input.value = '';
    isTyping = true;
    document.getElementById('ac-chat-send').disabled = true;
    addTyping();

    fetch(SERVER + '/api/chat', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message: text, history: history.slice(-6) })
    })
      .then(function (r) { return r.json(); })
      .then(function (data) {
        removeTyping();
        isTyping = false;
        document.getElementById('ac-chat-send').disabled = false;
        var reply = data.reply || 'უკაცრავად, ვერ შევძელი პასუხის გაცემა.';
        addMessage(reply, 'bot');
        history.push({ role: 'bot', content: reply });
        input.focus();
      })
      .catch(function (err) {
        removeTyping();
        isTyping = false;
        document.getElementById('ac-chat-send').disabled = false;
        addMessage('კავშირის შეცდომა. გთხოვთ კიდევ სცადოთ.', 'bot');
        input.focus();
      });
  };
})();
