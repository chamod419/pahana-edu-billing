<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <c:set var="pageTitle" value="${mode=='edit' ? 'Edit User' : 'New User'}"/>
  <title><c:out value="${pageTitle}"/> - PahanaEdu</title>

  <style>
    :root{
      /* === Theme (as requested) === */
      --deep-navy: #1e3a8a;
      --forest-green: #166534;
      --midnight-blue: #1e293b;
      --teal: #0f766e;
      --royal-blue: #2563eb;

      --warm-gold: #f59e0b;
      --emerald: #059669;
      --orange: #ea580c;

      --white: #ffffff;
      --cream: #fefbf3;
      --light-gray: #f8fafc;
      --off-white: #fafaf9;

      --charcoal: #374151;
      --dark-gray: #1f2937;
      --slate-gray: #475569;
      --graphite: #111827;

      --radius-lg: 16px;
      --radius-md: 12px;
      --shadow-1: 0 10px 25px rgba(0,0,0,.10), 0 0 0 1px rgba(0,0,0,.02);
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
    /* subtle dot pattern bg */
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
    .actions{display:flex; gap:10px; flex-wrap:wrap}

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

    /* Card / Form */
    .form-wrap{
      background:#fff; border-radius:var(--radius-lg); box-shadow:var(--shadow-1);
      padding:22px;
    }
    .form-grid{
      display:grid; grid-template-columns:1fr 1fr; gap:16px;
    }
    .form-row.full{grid-column:1 / -1}
    label{display:block; font-weight:700; font-size:14px; color:var(--slate-gray); margin-bottom:6px}
    .req{color:var(--orange); margin-left:4px}
    input, select{
      width:100%; padding:12px 14px; font-size:16px; border-radius:10px; background:#fafafa;
      border:2px solid #e5e7eb; transition:border-color .2s, box-shadow .2s, background .2s;
    }
    input:focus, select:focus{outline:none; border-color:var(--teal); background:#fff; box-shadow:var(--focus-ring)}
    input:hover, select:hover{border-color:#d1d5db; background:#fff}

    .hint{font-size:12px; color:#6b7280; margin-top:6px}
    .badge{
      display:inline-block; font-size:12px; font-weight:800; padding:4px 10px; border-radius:999px; letter-spacing:.3px;
      background:linear-gradient(135deg,#fef3c7,#fed7aa); color:#92400e; border:1px solid rgba(146,64,14,.15);
    }

    .divider{height:1px; background:#eef2f7; margin:10px 0 4px}

    .actions-bar{display:flex; gap:10px; justify-content:flex-end; margin-top:16px}
    .note{font-size:12px; color:#64748b}

    /* Messages */
    .msg{padding:14px 16px; border-radius:12px; font-weight:700; margin:16px 0; display:flex; gap:10px; align-items:center}
    .msg-success{background:linear-gradient(135deg,#dcfce7,#bbf7d0); color:#166534; border-left:4px solid #166534}
    .msg-error{background:linear-gradient(135deg,#fee2e2,#fecaca); color:#dc2626; border-left:4px solid #dc2626}

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
      <h1 class="title"><c:out value="${pageTitle}"/></h1>
      <div class="actions">
        <a class="btn btn-ghost" href="${ctx}/admin/users">👥 Back to Users</a>
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
    <form id="userForm" action="${ctx}/admin/users/save" method="post" autocomplete="off" data-mode="${mode}">
      <input type="hidden" name="userId" value="${u.userId}"/>

      <!-- Top meta -->
      <div class="form-row full" style="display:flex;align-items:center;gap:10px;margin-bottom:4px">
        <span class="badge"><c:out value="${isEdit ? 'Edit Mode' : 'Create Mode'}"/></span>
        <c:if test="${isEdit}">
          <span class="note">User ID:&nbsp;<strong>#<c:out value="${u.userId}"/></strong></span>
        </c:if>
      </div>
      <div class="divider"></div>

      <div class="form-grid">
        <!-- Username -->
        <div class="form-row full">
          <label for="username">Username<span class="req">*</span></label>
          <input id="username" name="username" required
                 value="<c:out value='${u.username}'/>"
                 minlength="3" maxlength="100" autocomplete="username"
                 placeholder="e.g. anuradha.s or staff01"/>
          <div class="hint">Use 3–100 chars. Letters, numbers, period, dash, or underscore are recommended.</div>
        </div>

        <!-- Role -->
        <div class="form-row">
          <label for="role">Role<span class="req">*</span></label>
          <select id="role" name="role" required>
            <option value="ADMIN" ${u.role=='ADMIN' ? 'selected' : ''}>ADMIN</option>
            <option value="STAFF" ${u.role=='STAFF' ? 'selected' : ''}>STAFF</option>
          </select>
          <div class="hint">Choose access level for this user.</div>
        </div>

        <!-- Passwords (create vs edit) -->
        <c:choose>
          <c:when test="${!isEdit}">
            <div class="form-row">
              <label for="password">Password<span class="req">*</span></label>
              <input id="password" name="password" type="password" required minlength="6"
                     autocomplete="new-password" placeholder="Enter a strong password"/>
              <div class="hint">Minimum 6 characters. Use mix of letters & numbers if possible.</div>
            </div>
            <div class="form-row">
              <label for="confirm">Confirm Password<span class="req">*</span></label>
              <input id="confirm" name="confirm" type="password" required minlength="6"
                     autocomplete="new-password" placeholder="Re-enter password"/>
            </div>
          </c:when>
          <c:otherwise>
            <div class="form-row">
              <label for="password">New Password <span class="note">(optional)</span></label>
              <input id="password" name="password" type="password" minlength="6"
                     autocomplete="new-password" placeholder="Leave blank to keep current password"/>
            </div>
            <div class="form-row">
              <label for="confirm">Confirm New Password</label>
              <input id="confirm" name="confirm" type="password" minlength="6"
                     autocomplete="new-password" placeholder="Re-enter new password (if changed)"/>
            </div>
          </c:otherwise>
        </c:choose>

        <!-- Spacer to complete grid -->
        <div class="form-row full"></div>
      </div>

      <!-- Actions -->
      <div class="actions-bar">
        <a class="btn" href="${ctx}/admin/users">Cancel</a>
        <button id="saveBtn" class="btn btn-primary" type="submit">💾 Save</button>
      </div>
    </form>
  </div>
</div>

<script>
  // UX niceties
  (function(){
    const form = document.getElementById('userForm');
    const saveBtn = document.getElementById('saveBtn');
    const username = document.getElementById('username');
    const pass = document.getElementById('password');
    const confirm = document.getElementById('confirm');

    // Focus username
    window.addEventListener('load', ()=> username && username.focus());

    // Client-side confirm match
    function passwordsEntered(){
      return pass && confirm && pass.value.length > 0 || confirm.value.length > 0;
    }
    form.addEventListener('submit', function(e){
      // Trim username
      if (username) username.value = username.value.trim();

      // When creating: both required, when editing: if any filled both must match
      const mode = (form.dataset.mode || '').toLowerCase();
      const creating = mode !== 'edit';

      if (creating){
        if (!pass.value || !confirm.value || pass.value !== confirm.value){
          e.preventDefault();
          alert('Passwords do not match. Please re-check.');
          return;
        }
      }else{
        if (passwordsEntered() && pass.value !== confirm.value){
          e.preventDefault();
          alert('New password and confirmation do not match.');
          return;
        }
      }
      // Disable double submit
      saveBtn.disabled = true;
      saveBtn.textContent = 'Saving...';
      saveBtn.style.opacity = '.8';
    });

    // Simple toggle with double-click on password fields (optional, neat trick)
    ;[pass, confirm].forEach(function(inp){
      if(!inp) return;
      inp.addEventListener('dblclick', function(){
        this.type = this.type === 'password' ? 'text' : 'password';
      });
      inp.addEventListener('blur', function(){ this.type = 'password'; });
    });
  })();
</script>
</body>
</html>
