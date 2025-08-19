<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><c:out value="${mode=='edit' ? 'Edit Item' : 'New Item'}"/></title>
  <style>
    :root{
      /* Brand palette */
      --deep-navy:#1e3a8a; --forest:#166534; --midnight:#1e293b; --teal:#0f766e; --royal:#2563eb;
      --gold:#f59e0b; --emerald:#059669; --orange:#ea580c;
      --white:#ffffff; --lg:#f8fafc;
      --charcoal:#374151; --dark:#1f2937; --muted:#94a3b8;
      --border:#e5e7eb;

      --radius-xl:24px; --radius-lg:16px; --radius-md:12px;
      --shadow-1:0 10px 25px rgba(0,0,0,.08), 0 0 0 1px rgba(0,0,0,.02);
      --focus:0 0 0 3px rgba(15,118,110,.15);
    }

    *{box-sizing:border-box;margin:0;padding:0}
    body{
      font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      color:var(--charcoal);
      background: linear-gradient(135deg, var(--lg) 0%, #e2e8f0 100%);
      min-height:100vh; padding:24px; overflow-x:hidden;
    }
    body::before{
      content:''; position:fixed; inset:0; pointer-events:none; z-index:-1;
      background:url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 60"><defs><pattern id="p" width="22" height="22" patternUnits="userSpaceOnUse"><circle cx="11" cy="11" r="1" fill="rgba(15,118,110,0.05)"/></pattern></defs><rect width="100%" height="100%" fill="url(%23p)"/></svg>');
    }

    .container{max-width:980px;margin:0 auto}

    /* ===== Header ===== */
    .header{
      background: linear-gradient(135deg, var(--midnight) 0%, var(--teal) 50%, var(--deep-navy) 100%);
      color:#fff; border-radius:var(--radius-xl); padding:24px 28px; margin-bottom:18px;
      position:relative; overflow:hidden; box-shadow:0 10px 25px rgba(30,41,59,.15), 0 0 0 1px rgba(255,255,255,.08) inset;
    }
    .header::before{
      content:''; position:absolute; inset:0;
      background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,.10) 50%, transparent 70%);
      animation: shimmer 3s ease-in-out infinite;
    }
    @keyframes shimmer{0%,100%{transform:translateX(-100%)}50%{transform:translateX(100%)}}
    .header-content{position:relative; z-index:1; display:flex; justify-content:space-between; align-items:center; gap:12px; flex-wrap:wrap}
    .title{font-size:26px; font-weight:800; display:flex; align-items:center; gap:10px}
    .btn{
      appearance:none; border:1px solid rgba(255,255,255,.35); background:rgba(255,255,255,.18);
      color:#fff; border-radius:12px; padding:10px 16px; font-weight:700; text-decoration:none;
      display:inline-flex; align-items:center; gap:8px; transition:.2s; backdrop-filter: blur(8px);
    }
    .btn:hover{transform:translateY(-1px)}
    .btn-primary{
      background:linear-gradient(135deg, var(--midnight) 0%, var(--teal) 60%, var(--royal) 100%);
      color:#fff; border:none; box-shadow:0 6px 16px rgba(15,118,110,.30);
    }
    .btn-ghost{background:rgba(255,255,255,.18); color:#fff}

    .header-center{position:absolute; left:50%; top:50%; transform:translate(-50%,-50%); z-index:2; pointer-events:none;}
    .logo{width:64px;height:64px;border-radius:50%;background:#fff;display:flex;align-items:center;justify-content:center;box-shadow:0 8px 20px rgba(0,0,0,.25);padding:8px}
    .logo img{max-width:48px;max-height:48px;display:block;object-fit:contain}

    /* ===== Card / Form ===== */
    .card{
      background:#fff; border:1px solid var(--border); border-radius:20px; box-shadow:var(--shadow-1);
      padding:24px; overflow:hidden;
    }
    .section-title{font-weight:800; font-size:16px; color:var(--dark); margin-bottom:8px}

    .grid-2{display:grid; grid-template-columns:1fr 1fr; gap:16px}
    .grid-3{display:grid; grid-template-columns:1fr 1fr 1fr; gap:16px}
    @media (max-width:720px){ .grid-2, .grid-3{grid-template-columns:1fr; } }

    .field{margin-bottom:14px}
    .label{display:flex; align-items:center; justify-content:space-between}
    .label span{font-weight:700; font-size:14px; color:var(--dark)}
    .req{color:#dc2626; margin-left:2px}

    .input, .select, .textarea{
      width:100%; padding:12px 14px; border:2px solid var(--border); border-radius:12px;
      font-size:14px; background:#fff; transition:border-color .2s, box-shadow .2s;
    }
    .input:focus, .select:focus, .textarea:focus{outline:none; border-color:var(--teal); box-shadow:var(--focus)}
    .hint{font-size:12px; color:var(--muted); margin-top:6px}

    .status-pill{
      display:inline-flex; align-items:center; gap:6px; padding:8px 12px; border-radius:999px; font-weight:800; font-size:12px; border:1px solid;
    }
    .active{background:#ecfdf5; color:#065f46; border-color:#a7f3d0}
    .inactive{background:#f3f4f6; color:#374151; border-color:#e5e7eb}

    /* Upload */
    .drop{
      border:2px dashed #cbd5e1; border-radius:14px; padding:16px; text-align:center; transition:border-color .2s, background .2s;
      background:#fafafa;
    }
    .drop:hover{border-color:#94a3b8}
    .drop input{display:none}
    .drop .browse{color:var(--teal); font-weight:800; cursor:pointer}
    .previews{display:flex; gap:16px; align-items:flex-start; flex-wrap:wrap; margin-top:10px}
    .preview{
      width:140px; height:140px; object-fit:cover; border:1px solid var(--border); border-radius:12px; background:#f8fafc;
    }

    .actions{margin-top:18px; display:flex; gap:10px; flex-wrap:wrap}
    .btn-save{background:linear-gradient(135deg, var(--teal) 0%, var(--emerald) 100%); color:#fff; border:none; padding:12px 18px; border-radius:12px; font-weight:800; cursor:pointer; box-shadow:0 4px 12px rgba(15,118,110,.25)}
    .btn-cancel{background:#fff; color:var(--dark); border:2px solid var(--border); padding:12px 18px; border-radius:12px; font-weight:800; text-decoration:none}

    .alert{
      padding:12px 14px; border-radius:12px; margin-bottom:14px; font-weight:700; display:flex; align-items:center; gap:10px;
    }
    .alert-err{background:linear-gradient(135deg,#fee2e2,#fecaca); color:#b91c1c; border:1px solid #fecaca}
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="categoriesCSV" value="Stationery,Accessories,Books,Printing,Services"/>
<c:set var="cats" value="${fn:split(categoriesCSV, ',')}"/>

<div class="container">
  <!-- Header -->
  <div class="header">
    <div class="header-content">
      <h1 class="title">
        🧾 <c:out value="${mode=='edit' ? 'Edit Item' : 'New Item'}"/>
      </h1>
      <div>
        <a class="btn btn-ghost" href="${ctx}/items">← Back to Items</a>
      </div>
    </div>
    <div class="header-center">
      <div class="logo">
        <img src="${ctx}/images/Pahanaedu.png" alt="PahanaEdu Logo"
             onerror="this.style.display='none'; this.parentNode.innerHTML='<strong>PE</strong>';">
      </div>
    </div>
  </div>

  <!-- Error -->
  <c:if test="${not empty error}">
    <div class="alert alert-err">❌ <span><c:out value="${error}"/></span></div>
  </c:if>

  <!-- Form Card -->
  <div class="card">
    <form id="itemForm" action="${ctx}/items/save" method="post" enctype="multipart/form-data" novalidate>
      <input type="hidden" name="itemId" value="${i.itemId}"/>
      <input type="hidden" name="existingImage" value="${i.imageUrl}"/>

      <div class="field">
        <label class="label" for="name"><span>Name <span class="req">*</span></span></label>
        <input id="name" name="name" class="input" required value="<c:out value='${i.name}'/>" placeholder="e.g., Blue Pen"/>
      </div>

      <div class="grid-3">
        <div class="field">
          <label class="label" for="unitPrice"><span>Unit Price (Rs.) <span class="req">*</span></span></label>
          <input id="unitPrice" class="input" type="number" step="0.01" min="0" name="unitPrice" required value="${i.unitPrice}" placeholder="0.00"/>
          <div class="hint">Use dot (.) for cents — e.g., 120.50</div>
        </div>

        <div class="field">
          <label class="label" for="stockQty"><span>Stock Qty <span class="req">*</span></span></label>
          <input id="stockQty" class="input" type="number" min="0" name="stockQty" required value="${i.stockQty}" oninput="updateStatus()"/>
          <div class="hint">Only whole numbers</div>
        </div>

        <div class="field">
          <label class="label" for="category"><span>Category <span class="req">*</span></span></label>
          <select id="category" class="select" name="category" required>
            <c:forEach var="cat" items="${cats}">
              <c:set var="catTrim" value="${fn:trim(cat)}"/>
              <option value="${catTrim}" ${i.category==catTrim ? 'selected' : ''}>${catTrim}</option>
            </c:forEach>
          </select>
        </div>
      </div>

      <div class="grid-2">
        <div class="field">
          <label class="label"><span>Auto Status</span></label>
          <div id="autoStatus" class="status-pill ${i.stockQty gt 0 ? 'active' : 'inactive'}">
            <c:out value="${(i.stockQty gt 0) ? 'ACTIVE' : 'INACTIVE'}"/>
          </div>
          <div class="hint">Stock &gt; 0 → ACTIVE, Stock = 0 → INACTIVE (calculated automatically)</div>
        </div>

        <div class="field">
          <label class="label" for="imageFile"><span>Image File</span></label>
          <div id="drop" class="drop">
            <label for="imageFile">
              <span class="browse">Click to browse</span> or drag &amp; drop (JPG/PNG/GIF, ≤ 5MB)
            </label>
            <input id="imageFile" name="imageFile" type="file" accept="image/*"/>
          </div>
          <div class="previews">
            <c:if test="${not empty i.imageUrl}">
              <div>
                <div class="hint">Current image</div>
                <img class="preview" src="${ctx}/uploads/${i.imageUrl}" alt="current image"/>
              </div>
            </c:if>
            <div id="newPreviewWrap" style="display:none">
              <div class="hint">New image (selected)</div>
              <img id="newPreview" class="preview" alt="new preview"/>
            </div>
          </div>
        </div>
      </div>

      <div class="field">
        <label class="label" for="description">
          <span>Description</span>
          <small id="descCount" class="hint">0/500</small>
        </label>
        <textarea id="description" class="textarea" name="description" rows="4" maxlength="500"
                  placeholder="Optional short description..."><c:out value='${i.description}'/></textarea>
      </div>

      <div class="actions">
        <button class="btn-save" type="submit">💾 Save</button>
        <a class="btn-cancel" href="${ctx}/items">Cancel</a>
      </div>
    </form>
  </div>
</div>

<script>
  // Live status pill based on stock
  function updateStatus(){
    var el = document.getElementById('autoStatus');
    var v = parseInt(document.getElementById('stockQty').value || '0', 10);
    el.textContent = (v > 0) ? 'ACTIVE' : 'INACTIVE';
    el.classList.remove('active','inactive');
    el.classList.add(v > 0 ? 'active' : 'inactive');
  }

  (function(){
    // Init desc counter
    const desc = document.getElementById('description');
    const counter = document.getElementById('descCount');
    const updateCount = () => counter.textContent = (desc.value||'').length + '/500';
    if(desc){ desc.addEventListener('input', updateCount); updateCount(); }

    // Drag & drop + preview
    const drop = document.getElementById('drop');
    const input = document.getElementById('imageFile');
    const wrap = document.getElementById('newPreviewWrap');
    const img  = document.getElementById('newPreview');

    function setPreview(file){
      if(!file) return;
      // Validate size (≤5MB)
      if(file.size > 5 * 1024 * 1024){
        alert('File too large. Please select an image ≤ 5MB.');
        input.value = '';
        wrap.style.display = 'none';
        return;
      }
      const reader = new FileReader();
      reader.onload = e => { img.src = e.target.result; wrap.style.display='block'; };
      reader.readAsDataURL(file);
    }

    if(input){
      input.addEventListener('change', e => setPreview(e.target.files[0]));
    }
    if(drop){
      ['dragenter','dragover'].forEach(evt =>
        drop.addEventListener(evt, e => { e.preventDefault(); e.stopPropagation(); drop.style.background='#f1f5f9'; })
      );
      ['dragleave','drop'].forEach(evt =>
        drop.addEventListener(evt, e => { e.preventDefault(); e.stopPropagation(); drop.style.background='#fafafa'; })
      );
      drop.addEventListener('drop', e => {
        const file = e.dataTransfer.files && e.dataTransfer.files[0];
        if(file){
          input.files = e.dataTransfer.files; // keep for form submit
          setPreview(file);
        }
      });
    }

    // Basic front-end guard rails
    const form = document.getElementById('itemForm');
    form.addEventListener('submit', function(e){
      const name = document.getElementById('name').value.trim();
      if(!name){
        e.preventDefault(); alert('Please enter a name.');
        document.getElementById('name').focus(); return;
      }
      const price = parseFloat(document.getElementById('unitPrice').value || '0');
      if(isNaN(price) || price < 0){
        e.preventDefault(); alert('Unit Price must be a positive number.'); return;
      }
      const qty = parseInt(document.getElementById('stockQty').value || '0', 10);
      if(isNaN(qty) || qty < 0){
        e.preventDefault(); alert('Stock Qty must be 0 or greater.'); return;
      }
    });

    // Initialize status pill once (for edit mode)
    updateStatus();
  })();
</script>
</body>
</html>
