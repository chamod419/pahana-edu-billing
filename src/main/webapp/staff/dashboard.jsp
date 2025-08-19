<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html>
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard - PahanaEdu</title>
    <style>
        /* =======================
           Color Palette (ONLY these)
        ======================== */
        :root{
            /* Primary */
            --deep-navy:   #1e3a8a;
            --forest:      #166534;
            --midnight:    #1e293b;
            --teal:        #0f766e;
            --royal:       #2563eb;
            /* Accent */
            --gold:        #f59e0b;
            --emerald:     #059669;
            --orange:      #ea580c;
            /* Backgrounds */
            --white:       #ffffff;
            --cream:       #fefbf3;
            --light-gray:  #f8fafc;
            --off-white:   #fafaf9;
            /* Text */
            --charcoal:    #374151;
            --dark:        #1f2937;
            --slate:       #475569;
            --graphite:    #111827;
            /* Shadows (derived from palette) */
            --shadow-lg:   0 10px 25px rgba(17,24,39,0.12);   /* graphite with alpha */
            --shadow-sm:   0 4px 12px rgba(17,24,39,0.10);
            --shadow-xs:   0 0 0 1px rgba(30,41,59,0.06);     /* midnight with alpha */
        }

        *{margin:0;padding:0;box-sizing:border-box}

        body{
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--charcoal);
            min-height:100vh;
            /* Base bg uses palette only */
            background: linear-gradient(180deg, var(--off-white) 0%, var(--cream) 100%);
            position: relative;
            overflow-x: hidden;
        }

        /* =======================
           BOOKSHOP BACKGROUND LAYER
           (tiny items scattered like a pattern)
        ======================== */
        body::before{
            content:'';
            position:fixed; inset:0;
            z-index:-2;
            background-image:
              /* Repeating bookshop icon pattern (SVG Data URI) */
              url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='96' height='96' viewBox='0 0 96 96'%3E%3Cdefs%3E%3Cpattern id='p' width='96' height='96' patternUnits='userSpaceOnUse'%3E%3C!-- BOOK --%3E%3Cg transform='translate(8,10)'%3E%3Crect x='0' y='0' rx='2' ry='2' width='22' height='30' fill='%231e3a8a' fill-opacity='0.08'/%3E%3Crect x='2' y='4' width='18' height='22' fill='%232563eb' fill-opacity='0.06'/%3E%3Cline x1='6' y1='6' x2='16' y2='6' stroke='%231e293b' stroke-opacity='0.10' stroke-width='1'/%3E%3Cline x1='6' y1='10' x2='16' y2='10' stroke='%231e293b' stroke-opacity='0.10' stroke-width='1'/%3E%3C/g%3E%3C!-- PENCIL --%3E%3Cg transform='translate(38,6) rotate(-20)'%3E%3Crect x='0' y='8' width='26' height='6' rx='3' fill='%23f59e0b' fill-opacity='0.10'/%3E%3Crect x='20' y='7' width='5' height='8' rx='1' fill='%232563eb' fill-opacity='0.10'/%3E%3Cpolygon points='-3,11 0,8 0,14' fill='%23ea580c' fill-opacity='0.12'/%3E%3C/g%3E%3C!-- RULER --%3E%3Cg transform='translate(60,44) rotate(10)'%3E%3Crect x='0' y='0' width='28' height='8' rx='2' fill='%23059669' fill-opacity='0.08'/%3E%3Cg stroke='%23166534' stroke-opacity='0.18' stroke-width='1'%3E%3Cline x1='4' y1='1' x2='4' y2='7'/%3E%3Cline x1='8' y1='1' x2='8' y2='6'/%3E%3Cline x1='12' y1='1' x2='12' y2='7'/%3E%3Cline x1='16' y1='1' x2='16' y2='6'/%3E%3Cline x1='20' y1='1' x2='20' y2='7'/%3E%3Cline x1='24' y1='1' x2='24' y2='6'/%3E%3C/g%3E%3C/g%3E%3C!-- NOTEBOOK --%3E%3Cg transform='translate(16,56)'%3E%3Crect x='0' y='0' width='26' height='30' rx='3' fill='%230f766e' fill-opacity='0.06'/%3E%3Cline x1='4' y1='8' x2='22' y2='8' stroke='%231e293b' stroke-opacity='0.12'/%3E%3Cline x1='4' y1='13' x2='22' y2='13' stroke='%231e293b' stroke-opacity='0.12'/%3E%3Cline x1='4' y1='18' x2='22' y2='18' stroke='%231e293b' stroke-opacity='0.12'/%3E%3C/g%3E%3C!-- TAG --%3E%3Cg transform='translate(70,74) rotate(30)'%3E%3Crect x='0' y='0' width='14' height='10' rx='2' fill='%23166534' fill-opacity='0.08'/%3E%3Ccircle cx='4' cy='5' r='1.5' fill='%23f59e0b' fill-opacity='0.30'/%3E%3C/g%3E%3C!-- SECOND ROW OFFSET --%3E%3Cuse href='%23row'/%3E%3C/g%3E%3C/defs%3E%3Crect width='96' height='96' fill='%23f8fafc'/%3E%3Crect width='96' height='96' fill='url(%23p)'/%3E%3C/svg%3E");
            background-size: 96px 96px;
            background-repeat: repeat;
            opacity: 1;
            animation: drift 60s linear infinite;
        }

        /* Subtle extra speckles using palette tints */
        body::after{
            content:'';
            position:fixed; inset:-20%;
            z-index:-3;
            background-image: radial-gradient(6px 6px at 20% 30%, rgba(30,58,138,0.05) 0%, transparent 60%),
                              radial-gradient(5px 5px at 70% 60%, rgba(21,128,61,0.05) 0%, transparent 60%),
                              radial-gradient(7px 7px at 40% 80%, rgba(37,99,235,0.05) 0%, transparent 60%),
                              radial-gradient(5px 5px at 80% 20%, rgba(245,158,11,0.05) 0%, transparent 60%);
            animation: floaty 80s linear infinite;
        }

        @keyframes drift{
            0%{ transform: translate3d(0,0,0); }
            100%{ transform: translate3d(-96px,-96px,0); }
        }
        @keyframes floaty{
            0%{ transform: translate3d(0,0,0) rotate(0deg); }
            50%{ transform: translate3d(20px,-10px,0) rotate(0.2deg); }
            100%{ transform: translate3d(0,0,0) rotate(0deg); }
        }

        .container{ max-width:1400px; margin:0 auto; padding:24px; }

        /* =======================
           Top Bar (kept same structure)
        ======================== */
        .topbar{
            background: linear-gradient(135deg, var(--midnight) 0%, var(--teal) 50%, var(--deep-navy) 100%);
            color: var(--white);
            padding: 20px 24px;
            border-radius: 16px;
            margin-bottom: 32px;
            box-shadow: var(--shadow-lg), var(--shadow-xs);
            position: relative;
            overflow: hidden;
        }
        .topbar::before{
            content:'';
            position:absolute; inset:0;
            background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,0.10) 50%, transparent 70%);
            animation: shimmer 3s ease-in-out infinite;
        }
        @keyframes shimmer{
            0%,100%{ transform: translateX(-100%); }
            50%{ transform: translateX(100%); }
        }
        .topbar-content{
            display:flex; justify-content:space-between; align-items:center;
            position:relative; z-index:1;
        }
        .dashboard-title{ font-size:28px; font-weight:700; margin:0; }
        .user-info{ display:flex; align-items:center; gap:16px; }
        .user-name{ font-weight:600; font-size:16px; }

        .staff-badge{
            background: var(--gold);
            color: var(--midnight);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .5px;
        }

        .logout-btn{
            background: rgba(255,255,255,0.18);
            color: var(--white);
            text-decoration:none;
            padding:8px 16px; border-radius:8px; font-weight:600;
            transition: all .3s ease; backdrop-filter: blur(10px);
            border:1px solid rgba(255,255,255,0.22);
        }
        .logout-btn:hover{ background: rgba(255,255,255,0.28); transform: translateY(-1px); box-shadow: var(--shadow-sm); }

        /* Centered Logo (same as you asked earlier) */
        .topbar-center{
            position:absolute; left:50%; top:50%;
            transform: translate(-50%,-50%);
            z-index:2; pointer-events:none;
        }
        .logo{
            width:56px; height:56px; margin:0 auto;
            background: var(--white);
            border-radius:50%;
            display:flex; align-items:center; justify-content:center;
            box-shadow: var(--shadow-sm);
            padding:8px;
        }
        .logo img{ max-width:40px; max-height:40px; object-fit:contain; display:block; }
        .logo-fallback{
            display:none; color: var(--midnight);
            font-size:20px; font-weight:700;
        }

        /* =======================
           Stats Cards
        ======================== */
        .stats-grid{
            display:grid; grid-template-columns: repeat(auto-fit, minmax(280px,1fr));
            gap:24px; margin-bottom:40px;
        }
        .stat-card{
            background: var(--white);
            border-radius:16px; padding:24px; position:relative; overflow:hidden;
            box-shadow: var(--shadow-sm), var(--shadow-xs);
            transition: transform .25s ease, box-shadow .25s ease;
        }
        .stat-card::before{
            content:''; position:absolute; left:0; right:0; top:0; height:4px;
            background: linear-gradient(90deg, var(--midnight), var(--teal), var(--deep-navy), var(--forest));
            background-size: 200% 100%;
            animation: band 4s ease infinite;
        }
        @keyframes band{
            0%,100%{ background-position:0% 50% }
            50%{ background-position:100% 50% }
        }
        .stat-card:hover{ transform: translateY(-4px); box-shadow: var(--shadow-lg); }

        .stat-label{ font-size:14px; font-weight:700; color: var(--slate); margin-bottom:8px; text-transform:uppercase; letter-spacing:.5px; }
        .stat-number{
            font-size:36px; font-weight:800; margin-bottom:8px;
            background: linear-gradient(135deg, var(--midnight) 0%, var(--teal) 100%);
            -webkit-background-clip: text; background-clip:text; -webkit-text-fill-color: transparent;
        }
        .stat-icon{
            position:absolute; top:20px; right:20px; width:48px; height:48px; border-radius:12px;
            display:flex; align-items:center; justify-content:center; font-size:24px; opacity:.85;
        }
        .icon-bills{ background: rgba(37,99,235,0.10); color: var(--royal); }
        .icon-revenue{ background: rgba(245,158,11,0.10); color: var(--gold); }
        .icon-tasks{ background: rgba(5,150,105,0.10); color: var(--emerald); }
        .icon-customers{ background: rgba(30,58,138,0.10); color: var(--deep-navy); }

        /* =======================
           Quick Actions
        ======================== */
        .nav-section{
            background: var(--white);
            border-radius:16px; padding:32px;
            box-shadow: var(--shadow-sm), var(--shadow-xs);
            margin-bottom:32px;
        }
        .nav-title{
            font-size:20px; font-weight:800; color: var(--midnight);
            margin-bottom:24px; padding-bottom:12px; border-bottom:2px solid var(--light-gray);
        }
        .nav-grid{ display:grid; grid-template-columns: repeat(auto-fit, minmax(200px,1fr)); gap:16px; }

        .nav-link{
            display:flex; align-items:center; gap:12px;
            padding:16px 20px; border-radius:12px;
            background: var(--light-gray);
            border:2px solid transparent; text-decoration:none; color: var(--dark);
            font-weight:700; transition: all .25s ease; position:relative; overflow:hidden;
        }
        .nav-link::before{
            content:''; position:absolute; inset:0; left:-100%;
            background: linear-gradient(90deg, transparent, rgba(15,118,110,0.12), transparent);
            transition:left .45s ease;
        }
        .nav-link:hover{
            color: var(--teal); background: #f0fdfa;  /* tint based on teal */
            border-color: var(--teal);
            box-shadow: 0 8px 18px rgba(15,118,110,0.15);
            transform: translateY(-2px);
        }
        .nav-link:hover::before{ left:100%; }
        .nav-link.primary{
            background: linear-gradient(135deg, var(--midnight) 0%, var(--teal) 100%);
            color: var(--white);
        }
        .nav-link.primary:hover{
            background: linear-gradient(135deg, var(--deep-navy) 0%, var(--emerald) 100%);
            border-color: transparent;
            box-shadow: 0 8px 22px rgba(30,58,138,0.28);
        }
        .nav-icon{ font-size:20px; }

        /* =======================
           Help Section
        ======================== */
        .help-section .nav-title{
            color: var(--forest);
        }
        .help-section .nav-title::before{
            content: '❓ ';
            color: var(--gold);
        }

        .faq-container{
            display: grid;
            gap: 12px;
        }

        .faq-item{
            border: 2px solid var(--light-gray);
            border-radius: 12px;
            overflow: hidden;
            transition: all .3s ease;
        }

        .faq-item:hover{
            border-color: var(--teal);
            box-shadow: 0 4px 15px rgba(15,118,110,0.1);
        }

        .faq-question{
            background: var(--light-gray);
            padding: 16px 20px;
            cursor: pointer;
            font-weight: 700;
            color: var(--midnight);
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: background-color .3s ease;
        }

        .faq-question:hover{
            background: #f0fdfa;
        }

        .faq-answer{
            padding: 20px;
            background: var(--white);
            display: none;
            border-top: 2px solid var(--light-gray);
        }

        .faq-answer.show{
            display: block;
        }

        .faq-answer ul{
            margin: 10px 0;
            padding-left: 20px;
        }

        .faq-answer li{
            margin: 5px 0;
            color: var(--slate);
        }

        .kbd{
            background: var(--light-gray);
            border: 1px solid var(--slate);
            border-radius: 4px;
            padding: 2px 6px;
            font-family: 'Courier New', monospace;
            font-size: 12px;
            color: var(--midnight);
            font-weight: 600;
        }

        .faq-icon{
            transition: transform .3s ease;
            color: var(--teal);
        }

        .faq-item.open .faq-icon{
            transform: rotate(180deg);
        }

        /* =======================
           Responsive
        ======================== */
        @media (max-width:768px){
            .container{ padding:16px; }
            .topbar-content{ flex-direction:column; gap:16px; text-align:center; }
            .dashboard-title{ font-size:24px; }
            .stats-grid{ grid-template-columns: 1fr; gap:16px; }
            .stat-number{ font-size:30px; }
            .nav-grid{ grid-template-columns:1fr; }
        }
        @media (max-width:480px){
            .stat-card{ padding:20px; }
            .nav-section{ padding:24px; }
        }
    </style>
</head>
<body>
    <c:set var="ctx" value="${pageContext.request.contextPath}"/>

    <div class="container">
        <!-- Top Bar -->
        <div class="topbar">
            <div class="topbar-content">
                <h1 class="dashboard-title">Staff Dashboard</h1>
                <div class="user-info">
                    <span class="user-name">Welcome, ${sessionScope.user.username}</span>
                    <span class="staff-badge">STAFF</span>
                    <a href="${ctx}/logout" class="logout-btn">Logout</a>
                </div>
            </div>

            <!-- Centered Logo -->
            <div class="topbar-center">
                <div class="logo">
                    <img src="${ctx}/images/Pahanaedu.png" alt="PahanaEdu Logo"
                        onerror="this.style.display='none'; this.parentNode.querySelector('.logo-fallback').style.display='block';">
                    <div class="logo-fallback">PE</div>
                </div>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon icon-bills">📄</div>
                <div class="stat-label">Your Bills Today</div>
                <div class="stat-number">${empty staffTodayBills ? 0 : staffTodayBills}</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-revenue">💰</div>
                <div class="stat-label">Your Revenue Today</div>
                <div class="stat-number">Rs. <c:out value="${empty staffTodayRevenue ? 0 : staffTodayRevenue}"/></div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-tasks">✅</div>
                <div class="stat-label">Tasks Completed</div>
                <div class="stat-number">${empty completedTasks ? 0 : completedTasks}</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-customers">👥</div>
                <div class="stat-label">Customers Served</div>
                <div class="stat-number">${empty customersServed ? 0 : customersServed}</div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="nav-section">
            <h2 class="nav-title">Quick Actions</h2>
            <div class="nav-grid">
                <a href="${ctx}/billing/new" class="nav-link primary">
                    <span class="nav-icon">💳</span>
                    <span>Generate Bill</span>
                </a>
                <a href="${ctx}/customers" class="nav-link">
                    <span class="nav-icon">👥</span>
                    <span>Manage Customers</span>
                </a>
                <a href="${ctx}/items" class="nav-link">
                    <span class="nav-icon">📦</span>
                    <span>Manage Items</span>
                </a>
                <a href="${ctx}/staff/reports" class="nav-link">
                    <span class="nav-icon">📊</span>
                    <span>My Reports</span>
                </a>
            </div>
        </div>

        <!-- Help & FAQ Section -->
        <div class="nav-section help-section">
            <h2 class="nav-title">Help & Shortcuts</h2>
            <div class="faq-container">
                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        How do I create and print a bill?
                        <span class="faq-icon">▼</span>
                    </div>
                    <div class="faq-answer">
                        <ul>
                            <li>Click <strong>Generate Bill</strong></li>
                            <li>Attach customer (by Account # or search), add items, set qty/discount</li>
                            <li>Click <strong>Finalize & Print</strong> — receipt auto-opens the print dialog</li>
                        </ul>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        Useful keyboard shortcuts
                        <span class="faq-icon">▼</span>
                    </div>
                    <div class="faq-answer">
                        <p>
                            <span class="kbd">/</span> focus item/customer search • 
                            <span class="kbd">Ctrl</span> + <span class="kbd">Enter</span> finalize bill
                        </p>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        Receipt didn't auto-print?
                        <span class="faq-icon">▼</span>
                    </div>
                    <div class="faq-answer">
                        <ul>
                            <li>Browser pop-ups/print dialogs may be blocked — allow pop-ups for this site</li>
                            <li>Use <strong>Preview PDF</strong> ➜ print manually</li>
                        </ul>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        Can't find a customer or item?
                        <span class="faq-icon">▼</span>
                    </div>
                    <div class="faq-answer">
                        <ul>
                            <li>Customer: create via <strong>Customers → + New Customer</strong></li>
                            <li>Item: add/activate via <strong>Items</strong> screen</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // FAQ Toggle functionality
        function toggleFAQ(element) {
            const faqItem = element.parentElement;
            const answer = faqItem.querySelector('.faq-answer');
            const isOpen = faqItem.classList.contains('open');

            // Close all other FAQs
            document.querySelectorAll('.faq-item').forEach(item => {
                item.classList.remove('open');
                item.querySelector('.faq-answer').classList.remove('show');
            });

            // Toggle current FAQ
            if (!isOpen) {
                faqItem.classList.add('open');
                answer.classList.add('show');
            }
        }

        // Logo error handling
        document.addEventListener('DOMContentLoaded', function() {
            const logoImg = document.querySelector('.logo img');
            if (logoImg) {
                logoImg.addEventListener('error', function() {
                    this.style.display = 'none';
                    this.parentNode.querySelector('.logo-fallback').style.display = 'block';
                });
            }
        });
    </script>
</body>
</html>