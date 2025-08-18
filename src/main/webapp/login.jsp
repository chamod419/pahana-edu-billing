<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - PahanaEdu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/app.css"/>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            width: 100%;
            max-width: 400px;
            position: relative;
        }

        .login-header {
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            padding: 40px 30px 30px;
            text-align: center;
            color: white;
            position: relative;
        }

        .login-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="50" cy="10" r="0.5" fill="rgba(255,255,255,0.05)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.3;
        }

        .logo {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            position: relative;
            z-index: 1;
        }

        .logo img {
            max-width: 60px;
            max-height: 60px;
            object-fit: contain;
        }

        .login-title {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 5px;
            position: relative;
            z-index: 1;
        }

        .login-subtitle {
            font-size: 14px;
            opacity: 0.9;
            font-weight: 300;
            position: relative;
            z-index: 1;
        }

        .login-form {
            padding: 40px 30px;
        }

        .message {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            font-weight: 500;
        }

        .error {
            background-color: #fee2e2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }

        .msg {
            background-color: #dcfce7;
            color: #16a34a;
            border: 1px solid #bbf7d0;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #374151;
            font-size: 14px;
        }

        .form-input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
            background-color: #fafafa;
        }

        .form-input:focus {
            outline: none;
            border-color: #4f46e5;
            background-color: white;
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
        }

        .form-input:hover {
            border-color: #d1d5db;
            background-color: white;
        }

        .login-button {
            width: 100%;
            padding: 14px 20px;
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .login-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(79, 70, 229, 0.3);
        }

        .login-button:active {
            transform: translateY(0);
        }

        .login-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .login-button:hover::before {
            left: 100%;
        }

        .login-footer {
            text-align: center;
            padding: 20px 30px;
            background-color: #f9fafb;
            font-size: 12px;
            color: #6b7280;
        }

        @media (max-width: 480px) {
            .login-container {
                margin: 10px;
            }
            
            .login-header {
                padding: 30px 20px 25px;
            }
            
            .login-form {
                padding: 30px 20px;
            }
            
            .login-title {
                font-size: 24px;
            }
        }

        /* Loading animation */
        .loading {
            pointer-events: none;
            opacity: 0.7;
        }

        .loading::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 20px;
            height: 20px;
            margin: -10px 0 0 -10px;
            border: 2px solid transparent;
            border-top: 2px solid white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <div class="logo">
                <img src="${pageContext.request.contextPath}/images/Pahanaedu.png" alt="PahanaEdu Logo" onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">
                <div style="display: none; color: #4f46e5; font-size: 24px; font-weight: bold;">PE</div>
            </div>
            <h1 class="login-title">Welcome Back</h1>
            <p class="login-subtitle">Sign in to your PahanaEdu account</p>
        </div>

        <div class="login-form">
            <c:if test="${not empty param.msg}">
                <div class="message msg">${param.msg}</div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="message error">${param.error}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="message error">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
                <input type="hidden" name="next" value="${param.next}"/>

                <div class="form-group">
                    <label for="username" class="form-label">Username</label>
                    <input id="username" name="username" class="form-input" type="text" required autocomplete="username" placeholder="Enter your username">
                </div>

                <div class="form-group">
                    <label for="password" class="form-label">Password</label>
                    <input id="password" name="password" class="form-input" type="password" required autocomplete="current-password" placeholder="Enter your password">
                </div>

                <button type="submit" class="login-button" id="loginBtn">
                    Sign In
                </button>
            </form>
        </div>

        <div class="login-footer">
            © 2024 PahanaEdu. All rights reserved.
        </div>
    </div>

    <script>
        // Add loading state to login button
        document.getElementById('loginForm').addEventListener('submit', function() {
            const btn = document.getElementById('loginBtn');
            btn.classList.add('loading');
            btn.textContent = 'Signing in...';
        });

        // Add enter key support
        document.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                document.getElementById('loginForm').submit();
            }
        });

        // Focus first input on page load
        window.addEventListener('load', function() {
            document.getElementById('username').focus();
        });
    </script>
</body>
</html>