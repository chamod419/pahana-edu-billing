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
            background: linear-gradient(135deg, #1e293b 0%, #0f766e 25%, #2563eb 50%, #1e3a8a 75%, #166534 100%);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: 
                radial-gradient(circle at 25% 25%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 75% 75%, rgba(245, 158, 11, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 50% 100%, rgba(16, 185, 129, 0.08) 0%, transparent 50%);
            animation: floating 20s ease-in-out infinite;
        }

        body::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="books" width="40" height="40" patternUnits="userSpaceOnUse"><rect x="5" y="15" width="8" height="20" fill="rgba(245,158,11,0.03)" rx="1"/><rect x="15" y="12" width="6" height="23" fill="rgba(16,185,129,0.03)" rx="1"/><rect x="23" y="18" width="7" height="17" fill="rgba(37,99,235,0.03)" rx="1"/><rect x="32" y="14" width="5" height="21" fill="rgba(255,255,255,0.02)" rx="1"/></pattern></defs><rect width="100" height="100" fill="url(%23books)"/></svg>') repeat;
            animation: bookPattern 30s linear infinite;
            opacity: 0.4;
            pointer-events: none;
        }

        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        @keyframes floating {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            33% { transform: translateY(-10px) rotate(1deg); }
            66% { transform: translateY(5px) rotate(-1deg); }
        }

        @keyframes bookPattern {
            0% { transform: translateX(0) translateY(0); }
            100% { transform: translateX(-40px) translateY(-40px); }
        }

        .login-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 24px;
            box-shadow: 
                0 25px 50px rgba(0, 0, 0, 0.15),
                0 0 0 1px rgba(255, 255, 255, 0.1) inset;
            overflow: hidden;
            width: 100%;
            max-width: 420px;
            position: relative;
            transform: translateY(0);
            animation: cardFloat 6s ease-in-out infinite;
        }

        @keyframes cardFloat {
            0%, 100% { transform: translateY(0) scale(1); }
            50% { transform: translateY(-5px) scale(1.01); }
        }

        .login-header {
            background: linear-gradient(135deg, #1e293b 0%, #0f766e 50%, #1e3a8a 100%);
            padding: 45px 35px 35px;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .login-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                radial-gradient(circle at 30% 20%, rgba(245, 158, 11, 0.15) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(16, 185, 129, 0.1) 0%, transparent 50%),
                linear-gradient(45deg, transparent 30%, rgba(255, 255, 255, 0.05) 50%, transparent 70%);
            animation: headerShimmer 8s ease-in-out infinite;
        }

        @keyframes headerShimmer {
            0%, 100% { opacity: 1; transform: translateX(0); }
            50% { opacity: 0.8; transform: translateX(10px); }
        }

        .logo {
            width: 90px;
            height: 90px;
            margin: 0 auto 20px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.25);
            position: relative;
            z-index: 1;
            padding: 10px;
        }

        .logo img {
            max-width: 60px;
            max-height: 60px;
            object-fit: contain;
        }

        .logo-fallback {
            display: none;
            color: #1e293b;
            font-size: 28px;
            font-weight: bold;
            font-family: 'Segoe UI', sans-serif;
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
            border-color: #0f766e;
            background-color: white;
            box-shadow: 0 0 0 3px rgba(15, 118, 110, 0.1);
        }

        .form-input:hover {
            border-color: #d1d5db;
            background-color: white;
        }

        .login-button {
            width: 100%;
            padding: 16px 24px;
            background: linear-gradient(135deg, #1e293b 0%, #0f766e 50%, #1e3a8a 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(30, 41, 59, 0.3);
        }

        .login-button:hover {
            transform: translateY(-3px);
            box-shadow: 
                0 8px 25px rgba(30, 41, 59, 0.4),
                0 0 20px rgba(15, 118, 110, 0.3);
            background: linear-gradient(135deg, #334155 0%, #14b8a6 50%, #3b82f6 100%);
        }

        .login-button:active {
            transform: translateY(-1px);
        }

        .login-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(245, 158, 11, 0.4), transparent);
            transition: left 0.6s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .login-button:hover::before {
            left: 100%;
        }

        .login-footer {
            text-align: center;
            padding: 20px 30px;
            background-color: rgba(249, 250, 251, 0.8);
            font-size: 12px;
            color: #6b7280;
        }

        @media (max-width: 480px) {
            .login-container {
                margin: 10px;
            }
            
            .login-header {
                padding: 35px 25px 30px;
            }
            
            .login-form {
                padding: 30px 20px;
            }
            
            .login-title {
                font-size: 24px;
            }

            .logo {
                width: 80px;
                height: 80px;
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
                <img src="${pageContext.request.contextPath}/images/Pahanaedu.png" alt="PahanaEdu Logo" 
                     onerror="this.style.display='none'; this.parentNode.querySelector('.logo-fallback').style.display='block';">
                <div class="logo-fallback">PE</div>
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
                    <input id="username" name="username" class="form-input" type="text" required 
                           autocomplete="username" placeholder="Enter your username">
                </div>

                <div class="form-group">
                    <label for="password" class="form-label">Password</label>
                    <input id="password" name="password" class="form-input" type="password" required 
                           autocomplete="current-password" placeholder="Enter your password">
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

        // Enhanced logo error handling
        document.addEventListener('DOMContentLoaded', function() {
            const logoImg = document.querySelector('.logo img');
            const logoFallback = document.querySelector('.logo-fallback');
            
            // Check if image loads successfully
            logoImg.addEventListener('load', function() {
                console.log('PahanaEdu logo loaded successfully');
            });
            
            logoImg.addEventListener('error', function() {
                console.log('Logo failed to load, showing fallback');
                this.style.display = 'none';
                logoFallback.style.display = 'block';
            });
        });
    </script>
</body>
</html>