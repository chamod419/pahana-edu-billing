<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - PahanaEdu</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            min-height: 100vh;
            color: #1f2937;
            position: relative;
            padding: 24px;
        }

        /* Background Pattern */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="users-pattern" width="20" height="20" patternUnits="userSpaceOnUse"><circle cx="10" cy="10" r="1" fill="rgba(15,118,110,0.03)"/></pattern></defs><rect width="100" height="100" fill="url(%23users-pattern)"/></svg>');
            pointer-events: none;
            z-index: -1;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Header Section */
        .header {
            background: linear-gradient(135deg, #1e293b 0%, #0f766e 50%, #1e3a8a 100%);
            color: white;
            padding: 24px 32px;
            border-radius: 16px;
            margin-bottom: 24px;
            position: relative; /* keep relative for centered logo */
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent 30%, rgba(255, 255, 255, 0.1) 50%, transparent 70%);
            animation: shimmer 3s ease-in-out infinite;
        }

        @keyframes shimmer {
            0%, 100% { transform: translateX(-100%); }
            50% { transform: translateX(100%); }
        }

        .header-content {
            position: relative;
            z-index: 1;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .header-icon {
            font-size: 32px;
        }

        .header-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 20px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            white-space: nowrap;
        }

        .btn-primary {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            backdrop-filter: blur(10px);
        }

        .btn-primary:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
        }

        /* >>> NEW: Centered logo styles <<< */
        .header-center {
            position: absolute;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%); /* perfect center */
            z-index: 2; /* above shimmer */
            pointer-events: none; /* don't block header buttons */
        }
        .logo {
            width: 56px;
            height: 56px;
            margin: 0 auto;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.25);
            padding: 8px;
        }
        .logo img {
            max-width: 40px;
            max-height: 40px;
            object-fit: contain;
            display: block;
        }
        .logo-fallback {
            display: none;
            color: #1e293b;
            font-size: 20px;
            font-weight: 700;
            font-family: 'Segoe UI', sans-serif;
        }
        /* >>> END NEW <<< */

        /* Messages */
        .message {
            padding: 16px 24px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideIn 0.3s ease-out;
        }

        .message-success {
            background: linear-gradient(135deg, #dcfce7 0%, #bbf7d0 100%);
            color: #16a34a;
            border-left: 4px solid #16a34a;
        }

        .message-error {
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
            color: #dc2626;
            border-left: 4px solid #dc2626;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* Table Container */
        .table-container {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 
                0 10px 25px rgba(0, 0, 0, 0.08),
                0 0 0 1px rgba(0, 0, 0, 0.02);
            position: relative;
        }

        .table-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #1e293b, #0f766e, #1e3a8a, #166534);
            background-size: 200% 100%;
            animation: gradientMove 4s ease infinite;
        }

        @keyframes gradientMove {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }

        /* Table Styling */
        .users-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 15px;
        }

        .users-table th {
            background: #f8fafc;
            color: #374151;
            font-weight: 700;
            padding: 20px 24px;
            text-align: left;
            border-bottom: 2px solid #e5e7eb;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .users-table td {
            padding: 20px 24px;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
        }

        .users-table tbody tr { transition: all 0.2s ease; }
        .users-table tbody tr:hover {
            background: #f8fafc;
            transform: scale(1.001);
        }
        .users-table tbody tr:last-child td { border-bottom: none; }

        /* User Info Styling */
        .user-id {
            font-family: 'Monaco', 'Menlo', monospace;
            background: #f1f5f9;
            color: #64748b;
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }

        .username {
            font-weight: 600;
            color: #1e293b;
            font-size: 16px;
        }

        .role-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .role-admin {
            background: linear-gradient(135deg, #fef3c7 0%, #fed7aa 100%);
            color: #92400e;
        }

        .role-staff {
            background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
            color: #1e40af;
        }

        /* Action Buttons */
        .actions {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .btn-small {
            padding: 8px 12px;
            font-size: 13px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-edit {
            background: linear-gradient(135deg, #0f766e 0%, #14b8a6 100%);
            color: white;
        }
        .btn-edit:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(15, 118, 110, 0.3);
            background: linear-gradient(135deg, #14b8a6 0%, #06d6a0 100%);
        }

        .btn-delete {
            background: linear-gradient(135deg, #dc2626 0%, #ef4444 100%);
            color: white;
        }
        .btn-delete:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(220, 38, 38, 0.3);
            background: linear-gradient(135deg, #ef4444 0%, #f87171 100%);
        }
        .btn-delete:disabled {
            background: #e5e7eb;
            color: #9ca3af;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        .btn-delete:disabled:hover { transform: none; box-shadow: none; }

        .form-inline { display: inline; }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 40px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }
        .empty-icon { font-size: 64px; margin-bottom: 16px; opacity: 0.5; }
        .empty-title { font-size: 24px; font-weight: 700; color: #374151; margin-bottom: 8px; }
        .empty-text { color: #6b7280; font-size: 16px; margin-bottom: 24px; }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .users-table { font-size: 14px; }
            .users-table th, .users-table td { padding: 16px 20px; }
        }

        @media (max-width: 768px) {
            body { padding: 16px; }
            .header-content { flex-direction: column; align-items: stretch; text-align: center; }
            .header-actions { justify-content: center; }
            .page-title { font-size: 24px; justify-content: center; }
            .users-table { display: block; overflow-x: auto; white-space: nowrap; }
            .users-table th, .users-table td { padding: 12px 16px; min-width: 120px; }
            .actions { flex-direction: column; gap: 6px; }
            .btn-small { width: 100%; justify-content: center; }
        }

        @media (max-width: 480px) {
            .container { padding: 0; }
            .header { border-radius: 12px; margin: 0 0 16px 0; padding: 20px 24px; }
            .table-container { border-radius: 12px; }
            .empty-state { padding: 60px 24px; border-radius: 12px; }
        }
    </style>
</head>
<body>
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>
    
    <div class="container">
        <!-- Header Section -->
        <div class="header">
            <div class="header-content">
                <h1 class="page-title">
                    <span class="header-icon">👥</span>
                    Manage Users
                </h1>
                <div class="header-actions">
                    <a class="btn btn-primary" href="${ctx}/admin/users/new">✨ New User</a>
                    <a class="btn btn-secondary" href="${ctx}/dashboard">🏠 Dashboard</a>
                </div>
            </div>

            <!-- >>> NEW: Centered Logo <<< -->
            <div class="header-center">
                <div class="logo">
                    <img src="${ctx}/images/Pahanaedu.png" alt="PahanaEdu Logo"
                         onerror="this.style.display='none'; this.parentNode.querySelector('.logo-fallback').style.display='block';">
                    <div class="logo-fallback">PE</div>
                </div>
            </div>
            <!-- >>> END NEW <<< -->
        </div>

        <!-- Messages -->
        <c:if test="${not empty param.msg}">
            <div class="message message-success">
                <span>✅</span>
                <span>${param.msg}</span>
            </div>
        </c:if>
        
        <c:if test="${not empty param.error}">
            <div class="message message-error">
                <span>❌</span>
                <span>${param.error}</span>
            </div>
        </c:if>

        <!-- Users Table -->
        <c:choose>
            <c:when test="${not empty list}">
                <div class="table-container">
                    <table class="users-table">
                        <thead>
                            <tr>
                                <th>User ID</th>
                                <th>Username</th>
                                <th>Role</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${list}">
                                <tr>
                                    <td><span class="user-id">#${u.userId}</span></td>
                                    <td><span class="username"><c:out value="${u.username}"/></span></td>
                                    <td>
                                        <span class="role-badge ${u.role == 'ADMIN' ? 'role-admin' : 'role-staff'}">
                                            <c:out value="${u.role}"/>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <a class="btn-small btn-edit" href="${ctx}/admin/users/edit?id=${u.userId}">✏️ Edit</a>
                                            <form class="form-inline" action="${ctx}/admin/users/delete" method="post"
                                                onsubmit="return confirm('Are you sure you want to delete this user?\\n\\nUser: ${u.username}\\nRole: ${u.role}\\n\\nThis action cannot be undone!');">
                                                <input type="hidden" name="id" value="${u.userId}"/>
                                                <button class="btn-small btn-delete" type="submit"
                                                    ${sessionScope.user.userId==u.userId ? 'disabled title="Cannot delete your own account"' : ''}>
                                                    🗑️ Delete
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <div class="empty-icon">👤</div>
                    <h3 class="empty-title">No Users Found</h3>
                    <p class="empty-text">Get started by creating your first user account.</p>
                    <a class="btn btn-primary" href="${ctx}/admin/users/new">✨ Create First User</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        // Enhanced user experience
        document.addEventListener('DOMContentLoaded', function() {
            // Add loading states to action buttons
            const editButtons = document.querySelectorAll('.btn-edit');
            editButtons.forEach(btn => {
                btn.addEventListener('click', function() {
                    this.style.opacity = '0.7';
                    this.innerHTML = '⏳ Loading...';
                });
            });

            // Enhanced delete confirmation
            const deleteButtons = document.querySelectorAll('.btn-delete:not(:disabled)');
            deleteButtons.forEach(btn => {
                const form = btn.closest('form');
                form.addEventListener('submit', function(e) {
                    btn.style.opacity = '0.7';
                    btn.innerHTML = '⏳ Deleting...';
                    btn.disabled = true;
                });
            });

            // Auto-hide success messages after 5 seconds
            const successMessages = document.querySelectorAll('.message-success');
            successMessages.forEach(msg => {
                setTimeout(() => {
                    msg.style.opacity = '0';
                    msg.style.transform = 'translateY(-20px)';
                    setTimeout(() => msg.remove(), 300);
                }, 5000);
            });

            // Table row click to edit (optional UX enhancement)
            const tableRows = document.querySelectorAll('.users-table tbody tr');
            tableRows.forEach(row => {
                row.style.cursor = 'pointer';
                row.addEventListener('click', function(e) {
                    if (!e.target.closest('.actions')) {
                        const editBtn = this.querySelector('.btn-edit');
                        if (editBtn) editBtn.click();
                    }
                });
            });
        });
    </script>
</body>
</html>
