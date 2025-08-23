<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <title>Staff Guide — PahanaEdu Help</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    :root{
      --deep:#1e3a8a; --mid:#1e293b; --teal:#0f766e; --emerald:#059669; --royal:#2563eb;
      --bg:#f8fafc; --panel:#ffffff; --border:#e5e7eb; --muted:#64748b; --text:#111827;
      --radius-xl:20px; --radius-lg:14px; --radius-md:10px;
      --sh1:0 12px 30px rgba(2,6,23,.10), 0 0 0 1px rgba(30,41,59,.06);
      --focus:0 0 0 3px rgba(15,118,110,.18);
      --hl:#fde68a;
    }
    *{box-sizing:border-box;margin:0;padding:0}
    body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,Calibri,sans-serif; color:var(--text); background:linear-gradient(135deg, var(--bg) 0%, #e2e8f0 100%);}
    .shell{max-width:1200px;margin:0 auto;padding:24px;display:grid;grid-template-columns:280px 1fr;gap:18px}
    @media (max-width:1024px){ .shell{grid-template-columns:1fr} }
    .hero{
      grid-column:1/-1; position:relative; color:#fff; background:linear-gradient(135deg,var(--mid),var(--teal) 55%,var(--deep));
      border-radius:var(--radius-xl); padding:24px 26px; box-shadow:var(--sh1)
    }
    .hero h1{font-size:26px}
    .sub{opacity:.92;margin-top:6px}
    .sidebar{position:sticky; top:16px; height:fit-content}
    .panel{background:var(--panel); border:1px solid var(--border); border-radius:16px; padding:14px; box-shadow:var(--sh1)}
    .toc h3{font-size:14px; color:var(--muted); text-transform:uppercase; letter-spacing:.6px; margin-bottom:8px}
    .toc a{display:block; color:var(--mid); text-decoration:none; font-weight:700; padding:8px 10px; border-radius:10px}
    .toc a:hover, .toc a.active{ background:#f0fdfa; color:#0f766e }
    .search{display:flex; gap:8px; margin-top:10px}
    .search input{flex:1; border:1px solid var(--border); border-radius:10px; padding:10px; outline:none}
    .search input:focus{box-shadow:var(--focus);border-color:#a7f3d0}
    .content .section{background:var(--panel); border:1px solid var(--border); border-radius:16px; padding:16px; box-shadow:var(--sh1); margin-bottom:14px}
    .content h2{font-size:18px; margin-bottom:8px}
    .muted{color:var(--muted)}
    .kbd{border:1px solid #cbd5e1;border-radius:6px;padding:2px 6px;background:#f1f5f9}
    .tips{display:grid; grid-template-columns:repeat(3,minmax(0,1fr)); gap:10px}
    @media (max-width:900px){ .tips{grid-template-columns:1fr} }
    .tip{border:1px solid var(--border); border-radius:12px; padding:12px}
    ul{margin-left:18px}
    mark{background:var(--hl); padding:0 4px; border-radius:4px}
    .top-actions{display:flex; gap:8px; flex-wrap:wrap}
    .btn{appearance:none;border:1px solid var(--border);background:#fff;color:var(--mid);font-weight:800;padding:10px 14px;border-radius:12px;text-decoration:none;display:inline-flex;align-items:center;gap:8px}
    .btn:hover{box-shadow:0 10px 24px rgba(0,0,0,.08)}
    .btn.primary{color:#fff;border-color:transparent;background:linear-gradient(135deg,var(--teal),var(--emerald))}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<div class="shell">
  <header class="hero">
    <div style="display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap">
      <div>
        <h1>Staff Guide</h1>
        <p class="sub">A clean, step-by-step reference for billing and daily operations.</p>
      </div>
      <nav class="top-actions" aria-label="Top actions">
        <a class="btn" href="${ctx}/dashboard">Dashboard</a>
        <a class="btn primary" href="${ctx}/billing/new">Generate Bill</a>
      </nav>
    </div>
  </header>

  <aside class="sidebar">
    <div class="panel toc" id="toc">
      <h3>On this page</h3>
      <!-- JS will populate -->
    </div>
    <div class="panel" style="margin-top:12px">
      <div class="search" aria-label="Filter sections">
        <input id="q" placeholder="Search this guide…"/>
      </div>
      <p class="muted" style="margin-top:8px">Tip: press <span class="kbd">/</span> to focus search</p>
    </div>
  </aside>

  <main class="content" id="content">
    <section class="section" id="quick-start">
      <h2>🚀 Quick Start</h2>
      <ol>
        <li><strong>Attach customer:</strong> enter <em>Account #</em> or search and attach.</li>
        <li><strong>Add items:</strong> choose the item, set quantity, then <em>Add</em>.</li>
        <li><strong>Discount:</strong> choose <em>Amount</em> or <em>%</em>. The system caps discount at subtotal.</li>
        <li><strong>Finalize:</strong> select payment method and <em>Finalize</em> (<span class="kbd">Ctrl</span> + <span class="kbd">Enter</span>).</li>
        <li><strong>Receipt:</strong> Print / Preview PDF / Download PDF / Print to POS.</li>
      </ol>
    </section>

    <section class="section" id="workflow">
      <h2>🧾 Billing Workflow</h2>
      <div class="tips">
        <div class="tip">
          <strong>Customer</strong>
          <ul>
            <li>Prefer attaching by account number for speed.</li>
            <li>Search supports name/phone/email/account.</li>
          </ul>
        </div>
        <div class="tip">
          <strong>Items</strong>
          <ul>
            <li>Filter with the item search box (press <span class="kbd">/</span>).</li>
            <li>Stock shows live in the selector.</li>
          </ul>
        </div>
        <div class="tip">
          <strong>Quantities</strong>
          <ul>
            <li>Use − / + buttons for quick edits.</li>
            <li>“Update” persists the new quantity.</li>
          </ul>
        </div>
      </div>
    </section>

    <section class="section" id="discounts">
      <h2>💸 Discounts</h2>
      <ul>
        <li>Pick one mode: <em>Amount</em> or <em>Percentage</em>.</li>
        <li>Discount cannot exceed <mark>Subtotal</mark>; excess gets capped automatically.</li>
        <li>The <strong>Estimated Net Total</strong> updates in real time before finalizing.</li>
      </ul>
    </section>

    <section class="section" id="payments">
      <h2>💳 Payment Methods</h2>
      <ul>
        <li>Supported methods: <strong>Cash</strong>, <strong>Card</strong>, <strong>Online</strong>.</li>
        <li>Choose the method before you finalize; it will appear on the receipt.</li>
      </ul>
    </section>

    <section class="section" id="printing">
      <h2>🖨️ Printing & PDFs</h2>
      <ul>
        <li>Use <em>Print</em> for the browser print dialog.</li>
        <li>Use <em>Preview PDF</em> or <em>Download PDF</em> if the browser print is blocked by pop-up settings.</li>
        <li><strong>Print to POS:</strong> requires a valid printer name on the server.</li>
      </ul>
    </section>

    <section class="section" id="lists">
      <h2>👥 Customers & 📦 Items</h2>
      <ul>
        <li>Customer status: <em>Active</em> / <em>Inactive</em>.</li>
        <li>Item status reflects stock; stock ≤ 0 is treated as inactive for display.</li>
        <li>List pages include search, segmented status filters, and category filters (items).</li>
      </ul>
    </section>

    <section class="section" id="shortcuts">
      <h2>⌨️ Keyboard Shortcuts</h2>
      <ul>
        <li><span class="kbd">/</span> — focus search boxes</li>
        <li><span class="kbd">Ctrl</span> + <span class="kbd">Enter</span> — finalize payment</li>
        <li>Use − / + in quantity steppers</li>
      </ul>
    </section>

    <section class="section" id="troubleshooting">
      <h2>🧰 Common Issues & Fixes</h2>
      <ul>
        <li><strong>No items in bill:</strong> Add items first, then finalize.</li>
        <li><strong>Image too large:</strong> Uploads must be ≤ 5 MB.</li>
        <li><strong>POS print fails:</strong> Check printer name and server printer status; use PDF as fallback.</li>
      </ul>
    </section>
  </main>
</div>

<script>
  // Build TOC from sections
  (function(){
    const content = document.getElementById('content');
    const toc = document.getElementById('toc');
    const sections = Array.from(content.querySelectorAll('.section'));
    const ul = document.createElement('div');
    sections.forEach(sec=>{
      const id = sec.id;
      const title = sec.querySelector('h2')?.innerText || id;
      const a = document.createElement('a');
      a.href = '#'+id; a.textContent = title;
      ul.appendChild(a);
    });
    toc.appendChild(ul);

    // Active section highlight
    const links = Array.from(toc.querySelectorAll('a'));
    const io = new IntersectionObserver((entries)=>{
      entries.forEach(e=>{
        const link = links.find(l=> l.getAttribute('href') === '#'+e.target.id);
        if (link){ e.isIntersecting ? link.classList.add('active') : link.classList.remove('active'); }
      });
    }, {rootMargin:'-40% 0px -55% 0px', threshold:.01});
    sections.forEach(s=>io.observe(s));
  })();

  // Local search (highlights + auto-open by scroll)
  (function(){
    const box = document.getElementById('q');
    const sections = Array.from(document.querySelectorAll('.section'));
    function clearMarks(root){
      root.querySelectorAll('mark').forEach(m=>{
        const t = document.createTextNode(m.textContent); m.replaceWith(t);
      });
    }
    function highlight(el, q){
      if(!q) return;
      const walk = document.createTreeWalker(el, NodeFilter.SHOW_TEXT, null);
      const nodes = [];
      while(walk.nextNode()) nodes.push(walk.currentNode);
      nodes.forEach(n=>{
        const idx = n.nodeValue.toLowerCase().indexOf(q);
        if(idx>-1){
          const span = document.createElement('span');
          const before = n.nodeValue.slice(0, idx);
          const mid = n.nodeValue.slice(idx, idx+q.length);
          const after = n.nodeValue.slice(idx+q.length);
          span.innerHTML = `${before}<mark>${mid}</mark>${after}`;
          n.parentNode.replaceChild(span, n);
        }
      });
    }
    function apply(){
      const q = (box.value||'').trim().toLowerCase();
      sections.forEach(sec=>{
        clearMarks(sec);
        sec.style.outline='none';
        if(!q) return;
        highlight(sec, q);
        if(sec.innerText.toLowerCase().includes(q)){
          sec.style.outline='2px solid #a7f3d0';
        }
      });
    }
    if(box){
      box.addEventListener('input', apply);
      document.addEventListener('keydown', e=>{
        if(e.key==='/' && !e.metaKey && !e.ctrlKey && !e.altKey){ e.preventDefault(); box.focus(); }
      });
    }
  })();
</script>
</body>
</html>
