<%@ page session="true" %>
<%
String username = (String) session.getAttribute("username");
if (username == null) {
    response.sendRedirect("signin.jsp");
    return;
}
String email = (String) session.getAttribute("email");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 500px;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            color: #333;
            text-align: center;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            margin-top: 10px;
            font-weight: bold;
        }
        input[type="text"],
        input[type="email"] {
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        input[type="submit"] {
            margin-top: 20px;
            padding: 10px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #007bff;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .alert {
            padding: 10px;
            background-color: #d4edda;
            border-color: #c3e6cb;
            color: #155724;
            border-radius: 4px;
            margin-bottom: 15px;
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Edit Profile</h2>
        <div id="successAlert" class="alert">Profile updated successfully!</div>
        <form action="editProfile" method="post" id="editProfileForm">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" value="<%= username %>" required>
            
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="<%= email %>" required>
            
            <input type="submit" value="Update Profile">
        </form>
        <a href="dashboard" class="back-link">Back to Dashboard</a>
    </div>

    <script>
        document.getElementById('editProfileForm').addEventListener('submit', function(e) {
            e.preventDefault();
            // Simulate form submission (replace with actual AJAX call in a real application)
            setTimeout(function() {
                document.getElementById('successAlert').style.display = 'block';
                setTimeout(function() {
                    document.getElementById('successAlert').style.display = 'none';
                }, 3000);
            }, 1000);
        });
    </script>
</body>
</html>