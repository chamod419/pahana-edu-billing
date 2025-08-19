<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <c:set var="pageTitle" value="${mode=='edit' ? 'Edit Customer' : 'New Customer'}"/>
  <title><c:out value="${pageTitle}"/> - PahanaEdu</title>

  <style>
    :root{
      /* === System Color Palette === */
      --deep-navy: #1e3a8a;     /* Primary */
      --forest-green: #166534;  /* Primary */
      --midnight-blue: #1e293b; /* Primary */
      --teal: #0f766e;          /* Primary */
      --royal-blue: #2563eb;    /* Primary */

      --warm-gold: #f59e0b;     /* Accent */
      --emerald: #059669;       /* Accent */
      --orange: #ea580c;        /* Accent */

      --white: #ffffff;         /* Background */
      --cream: #fefbf3;         /* Background */
      --light-gray: #f8fafc;    /* Background */
      --off-white: #fafaf9;     /* Background */

      --charcoal: #374151;      /* Text */
      --dark-gray: #1f2937;     /* Text */
      --slate-gray: #475569;    /* Text */
      --graphite: #111827;      /* Text */

      --radius-lg: 16px;
      --radius-md: 12px;
      --shadow-1: 0 10px 25px rgba(0,0,0,.08), 0 0 0 1px rgba(0,0,0,.02);
      --shadow-2: 0 20px 40px rgba(0,0,0,.12), 0 0 0 1px rgba(15,118,110,.08);
      --focus-ring: 0 0 0 3px rgba(15,118,110,.15);
    }

    *{box-sizing:border-box;margin:0;padding:0}
    body{
      font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(135deg, var(--light-gray) 0%, #e2e8f0 100%);
      min-height:100vh; color:var(--charcoal);
      padding:24px; position:relative; overflow-x:hidden;
    }
    /* subtle dot pattern */
    body::before{
      content:''; position:fixed; inset:0; pointer-events:none; z-index:-1;
      background:url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 60"><defs><pattern id="p" width="20" height="20" patternUnits="userSpaceOnUse"><circle cx="10" cy="10" r="1" fill="rgba(15,118,110,0.04)"/></pattern></defs><rect width="100%" height="100%" fill="url(%23p)"/></svg>');
    }

    .container{max-width:900px;margin:0 auto}

    /* Header (gradient + centered logo) */
    .header{
      position:relative; color:#fff; border-radius:var(--radius-lg);
      padding:22px 26px; margin-bottom:24px; overflow:hidden;
      background: linear-gradient(135deg, var(--midnight-blue) 0%, var(--teal) 50%, var(--deep-navy) 100%);
      box-shadow: 0 10px 25px rgba(30,41,59,.15), 0 0 0 1px rgba(255,255,255,.08) inset;
    }
    .header::before{
      content:''; position:absolute; inset:0;
      background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,.10) 50%, transparent 70%);
      animation: shimmer 3s ease-in-out infinite;
    }
    @keyframes shimmer{0%,100%{transform:translateX(-100%)}50%{transform:translateX(100%)}}

    .header-content{position:relative; z-index:1; display:flex; justify-content:space-between; align-items:center; gap:16px; flex-wrap:wrap}
    .title{font-size:26px; font-weight:800; letter-spacing:.2px}
    .header-actions{display:flex; gap:10px; flex-wrap:wrap}

    .header-center{
      position:absolute; left:50%; top:50%; transform:translate(-50%,-50%);
      z-index:2; pointer-events:none;
    }
    .logo{
      width:56px; height:56px; background:#fff; border-radius:50%;
      display:flex; align-items:center; justify-content:center; padding:8px;
      box-shadow:0 8px 20px rgba(0,0,0,.25);
    }
    .logo img{max-width:40px; max-height:40px; object-fit:contain; display:block}
    .logo-fallback{display:none; color:var(--midnight-blue); font-weight:800}

    /* Buttons */
    .btn{
      appearance:none; border:none; cursor:pointer; border-radius:10px;
      padding:10px 14px; font-weight:700; text-decoration:none; display:inline-flex; align-items:center; gap:8px;
      transition:.25s ease; background:#fff; color:var(--dark-gray); border:1px solid rgba(0,0,0,.08);
    }
    .btn:hover{transform:translateY(-1px); box-shadow:0 6px 16px rgba(0,0,0,.08)}
    .btn-primary{
      background: linear-gradient(135deg, var(--midnight-blue) 0%, var(--teal) 60%, var(--royal-blue) 100%);
      color:#fff; border:none; box-shadow:0 6px 16px rgba(15,118,110,.30);
    }
    .btn-primary:hover{box-shadow:0 10px 22px rgba(15,118,110,.35)}
    .btn-ghost{
      background: rgba(255,255,255,.18); color:#fff; border:1px solid rgba(255,255,255,.35);
      backdrop-filter: blur(8px);
    }
    .btn-ghost:hover{background:rgba(255,255,255,.28)}

    /* Messages */
    .msg{padding:14px 16px; border-radius:12px; font-weight:700; margin:16px 0; display:flex; gap:10px; align-items:center}
    .msg-success{background:linear-gradient(135deg,#dcfce7,#bbf7d0); color:#166534; border-left:4px solid #166534}
    .msg-error{background:linear-gradient(135deg,#fee2e2,#fecaca); color:#dc2626; border-left:4px solid #dc2626}

    /* Card / Form */
    .form-wrap{
      background:#fff; border-radius:var(--radius-lg); box-shadow:var(--shadow-1);
      padding:22px;
    }
    .badge{
      display:inline-block; font-size:12px; font-weight:800; padding:4px 10px; border-radius:999px; letter-spacing:.3px;
      background:linear-gradient(135deg,#fef3c7,#fed7aa); color:#92400e; border:1px solid rgba(146,64,14,.15);
    }
    .note{font-size:12px; color:#64748b}
    .divider{height:1px; background:#eef2f7; margin:10px 0 14px}

    .form-grid{
      display:grid; grid-template-columns:1fr 1fr; gap:16px;
    }
    .form-row.full{grid-column:1 / -1}
    label{display:block; font-weight:700; font-size:14px; color:var(--slate-gray); margin-bottom:6px}
    .req{color:var(--orange); margin-left:4px}
    input, select, textarea{
      width:100%; padding:12px 14px; font-size:16px; border-radius:10px; background:#fafafa;
      border:2px solid #e5e7eb; transition:border-color .2s, box-shadow .2s, background .2s;
    }
    textarea{resize:vertical}
    input:focus, select:focus, textarea:focus{outline:none; border-color:var(--teal); background:#fff; box-shadow:var(--focus-ring)}
    input:hover, select:hover, textarea:hover{border-color:#d1d5db; background:#fff}
    .hint{font-size:12px; color:#6b7280; margin-top:6px}

    .actions-bar{display:flex; gap:10px; justify-content:flex-end; margin-top:16px}

    /* Responsive */
    @media (max-width:780px){
      body{padding:16px}
      .form-grid{grid-template-columns:1fr}
      .title{font-size:22px}
    }
  </style>
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<c:set var="isEdit" value="${mode=='edit'}"/>

<div class="container">
  <!-- Header -->
  <div class="header">
    <div class="header-content">
      <h1 class="title">📇 <c:out value="${pageTitle}"/></h1>
      <div class="header-actions">
        <a class="btn btn-ghost" href="${ctx}/customers">👥 Back to Customers</a>
        <a class="btn btn-ghost" href="${ctx}/dashboard">🏠 Dashboard</a>
      </div>
    </div>

    <!-- Centered Logo -->
    <div class="header-center">
      <div class="logo">
        <img src="${ctx}/images/Pahanaedu.png" alt="PahanaEdu Logo"
             onerror="this.style.display='none'; this.parentNode.querySelector('.lf').style.display='block';">
        <div class="logo-fallback lf">PE</div>
      </div>
    </div>
  </div>

  <!-- Messages -->
  <c:if test="${not empty msg}">
    <div class="msg msg-success">✅ <span><c:out value="${msg}"/></span></div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="msg msg-error">❌ <span><c:out value="${error}"/></span></div>
  </c:if>
  <c:if test="${not empty param.error}">
    <div class="msg msg-error">❌ <span><c:out value="${param.error}"/></span></div>
  </c:if>

  <!-- Form Card -->
  <div class="form-wrap">
    <form id="customerForm" action="${ctx}/customers/save" method="post" autocomplete="off" data-mode="${mode}">
      <input type="hidden" name="customerId" value="${c.customerId}"/>

      <!-- Meta row -->
      <div class="form-row full" style="display:flex;align-items:center;gap:10px;margin-bottom:4px">
        <span class="badge"><c:out value="${isEdit ? 'Edit Mode' : 'Create Mode'}"/></span>
        <c:if test="${isEdit}">
          <span class="note">Customer ID:&nbsp;<strong>#<c:out value="${c.customerId}"/></strong></span>
        </c:if>
      </div>
      <div class="divider"></div>

      <div class="form-grid">
        <!-- Account Number -->
        <div class="form-row full">
          <label for="accountNumber">Account Number <span class="note">(optional)</span></label>
          <input id="accountNumber" name="accountNumber"
                 value="<c:out value='${c.accountNumber}'/>"
                 placeholder="Leave blank to auto-generate (e.g., C-0007)"/>
          <div class="hint">If empty, the system will assign an automatic code.</div>
        </div>

        <!-- Name -->
        <div class="form-row full">
          <label for="name">Name<span class="req">*</span></label>
          <input id="name" name="name" required
                 value="<c:out value='${c.name}'/>"
                 minlength="2" maxlength="120" placeholder="Customer full name"/>
        </div>

        <!-- Phone -->
        <div class="form-row">
          <label for="phone">Phone</label>
          <input id="phone" name="phone"
                 value="<c:out value='${c.phone}'/>"
                 pattern="[0-9+\-\s]{7,20}" placeholder="+94 77 123 4567"/>
          <div class="hint">Digits, +, - and spaces only (7–20 chars).</div>
        </div>

        <!-- Email -->
        <div class="form-row">
          <label for="email">Email</label>
          <input id="email" name="email" type="email"
                 value="<c:out value='${c.email}'/>"
                 placeholder="name@example.com"/>
        </div>

        <!-- Address -->
        <div class="form-row full">
          <label for="address">Address</label>
          <textarea id="address" name="address" rows="3" placeholder="Postal Code, Street, City"><c:out value='${c.address}'/></textarea>
        </div>

        <!-- Status -->
        <div class="form-row">
          <label for="status">Status</label>
          <select id="status" name="status">
            <option value="ACTIVE"  ${c.status=='ACTIVE' || empty c.status ? 'selected' : ''}>ACTIVE</option>
            <option value="INACTIVE"${c.status=='INACTIVE' ? 'selected' : ''}>INACTIVE</option>
          </select>
        </div>

        <!-- spacer -->
        <div class="form-row"></div>
      </div>

      <!-- Actions -->
      <div class="actions-bar">
        <a class="btn" href="${ctx}/customers">Cancel</a>
        <button id="saveBtn" class="btn btn-primary" type="submit">💾 Save</button>
      </div>
    </form>
  </div>
</div>

<script>
  (function(){
    const form = document.getElementById('customerForm');
    const saveBtn = document.getElementById('saveBtn');
    const nameEl = document.getElementById('name');
    const phoneEl = document.getElementById('phone');
    const emailEl = document.getElementById('email');
    const accEl = document.getElementById('accountNumber');

    // Focus name
    window.addEventListener('load', ()=> nameEl && nameEl.focus());

    // Light validation before submit
    form.addEventListener('submit', function(e){
      // trim text inputs
      [nameEl, phoneEl, emailEl, accEl].forEach(i => { if(i && typeof i.value==='string') i.value = i.value.trim(); });

      // phone pattern check (if provided)
      if (phoneEl && phoneEl.value && !new RegExp(phoneEl.getAttribute('pattern')).test(phoneEl.value)){
        e.preventDefault();
        alert('Please enter a valid phone number (digits, +, -, spaces; 7–20 chars).');
        phoneEl.focus();
        return;
      }

      // email validity (native for type=email, but be explicit)
      if (emailEl && emailEl.value && !emailEl.checkValidity()){
        e.preventDefault();
        alert('Please enter a valid email address.');
        emailEl.focus();
        return;
      }

      // disable double-submit
      saveBtn.disabled = true;
      saveBtn.textContent = 'Saving...';
      saveBtn.style.opacity = '.8';
    });
  })();
</script>
</body>
</html>
