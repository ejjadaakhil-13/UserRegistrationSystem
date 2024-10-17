<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Signup</title>
    <style>
        :root {
            --primary-color: #4a90e2;
            --secondary-color: #f5f5f5;
            --text-color: #333;
            --error-color: #e74c3c;
        }

        body {
            font-family: 'Arial', sans-serif;
            background-color: var(--secondary-color);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .signup-container {
            background-color: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        h2 {
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            text-align: center;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        label {
            margin-bottom: 0.5rem;
            color: var(--text-color);
            display: block;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            padding: 0.75rem;
            width: 100%;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
            box-sizing: border-box;
        }

        input[type="submit"] {
            background-color: var(--primary-color);
            color: white;
            padding: 0.75rem;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #357abd;
        }

        .error-message {
            color: var(--error-color);
            font-size: 0.875rem;
            margin-top: 0.25rem;
            display: none;
        }

        .login-link {
            text-align: center;
            margin-top: 1rem;
        }

        .login-link a {
            color: var(--primary-color);
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .error-message.visible {
            display: block;
        }

        input.error {
            border-color: var(--error-color);
        }
    </style>
</head>
<body>
    <div class="signup-container">
        <h2>Register</h2>
        <form id="registrationForm" action="register" method="post" novalidate>
            <div class="form-group">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" required>
                <div class="error-message" id="nameError"></div>
            </div>

            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
                <div class="error-message" id="emailError"></div>
            </div>

            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
                <div class="error-message" id="passwordError"></div>
            </div>

            <input type="submit" value="Register">
        </form>
        <div class="login-link">
            Already have an account? <a href="signin.jsp">Login here</a>
        </div>
    </div>

    <script>
        document.getElementById('registrationForm').addEventListener('submit', function(event) {
            event.preventDefault();
            
            // Reset previous error states
            resetErrors();
            
            let isValid = true;
            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;

            // Name validation
            if (!name) {
                showError('name', 'Name is required');
                isValid = false;
            }

            // Email validation
            if (!email) {
                showError('email', 'Email is required');
                isValid = false;
            } else if (!isValidEmail(email)) {
                showError('email', 'Please enter a valid email address');
                isValid = false;
            }

            // Password validation
            if (!password) {
                showError('password', 'Password is required');
                isValid = false;
            } else if (password.length < 6) {
                showError('password', 'Password must be at least 6 characters long');
                isValid = false;
            }

            if (isValid) {
                // Check if email already exists
                checkEmailExists(email).then(exists => {
                    if (!exists) {
                        this.submit();
                    } else {
                        showError('email', 'This email is already registered');
                    }
                });
            }
        });

        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }

        function showError(fieldId, message) {
            const field = document.getElementById(fieldId);
            const errorDiv = document.getElementById(fieldId + 'Error');
            field.classList.add('error');
            errorDiv.textContent = message;
            errorDiv.classList.add('visible');
        }

        function resetErrors() {
            const errorElements = document.getElementsByClassName('error-message');
            const inputElements = document.getElementsByTagName('input');
            
            for (let element of errorElements) {
                element.textContent = '';
                element.classList.remove('visible');
            }
            
            for (let element of inputElements) {
                element.classList.remove('error');
            }
        }

        // Function to check if email exists (calls server endpoint)
        async function checkEmailExists(email) {
            try {
                const response = await fetch('checkEmail?email=' + encodeURIComponent(email));
                const data = await response.json();
                return data.exists;
            } catch (error) {
                console.error('Error checking email:', error);
                return false;
            }
        }

        // Prevent spaces in input fields
        const inputs = document.querySelectorAll('input[type="text"], input[type="email"], input[type="password"]');
        inputs.forEach(input => {
            input.addEventListener('keypress', function(e) {
                if (e.key === ' ') {
                    e.preventDefault();
                }
            });
        });
    </script>
</body>
</html>