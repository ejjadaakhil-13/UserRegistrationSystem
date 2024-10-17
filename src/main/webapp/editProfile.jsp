<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile</title>
    <style>
        :root {
            --primary-color: #4a90e2;
            --secondary-color: #f5f5f5;
            --text-color: #333;
            --error-color: #e74c3c;
            --success-color: #2ecc71;
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

        .profile-container {
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
        input[type="email"] {
            padding: 0.75rem;
            width: 100%;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
            box-sizing: border-box;
        }

        .button-group {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
        }

        button {
            flex: 1;
            padding: 0.75rem;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .save-button {
            background-color: var(--primary-color);
            color: white;
        }

        .cancel-button {
            background-color: #ccc;
            color: var(--text-color);
        }

        .save-button:hover {
            background-color: #357abd;
        }

        .cancel-button:hover {
            background-color: #b3b3b3;
        }

        .error-message {
            color: var(--error-color);
            font-size: 0.875rem;
            margin-top: 0.25rem;
            display: none;
        }

        .success-message {
            color: var(--success-color);
            text-align: center;
            margin-bottom: 1rem;
            display: none;
        }

        .error-message.visible {
            display: block;
        }

        .success-message.visible {
            display: block;
        }

        input.error {
            border-color: var(--error-color);
        }
    </style>
</head>
<body>
    <div class="profile-container">
        <h2>Edit Profile</h2>
        <div id="successMessage" class="success-message"></div>
        <form id="editProfileForm" action="editProfile" method="post">
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

            <div class="button-group">
                <button type="button" class="cancel-button" onclick="window.location.href='dashboard'">Cancel</button>
                <button type="submit" class="save-button">Save Changes</button>
            </div>
        </form>
    </div>

    <script>
        // Populate form with current user data
        window.onload = function() {
            const currentName = '<%= session.getAttribute("username") %>';
            const currentEmail = '<%= session.getAttribute("email") %>';
            
            document.getElementById('name').value = currentName;
            document.getElementById('email').value = currentEmail;
        };

        document.getElementById('editProfileForm').addEventListener('submit', function(event) {
            event.preventDefault();
            
            // Reset previous error states
            resetErrors();
            
            let isValid = true;
            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            const currentEmail = '<%= session.getAttribute("email") %>';

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

            if (isValid) {
                if (email !== currentEmail) {
                    // Only check for email existence if email is changed
                    checkEmailExists(email).then(exists => {
                        if (!exists) {
                            this.submit();
                        } else {
                            showError('email', 'This email is already registered');
                        }
                    });
                } else {
                    this.submit();
                }
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
        const inputs = document.querySelectorAll('input[type="text"], input[type="email"]');
        inputs.forEach(input => {
            input.addEventListener('keypress', function(e) {
                if (e.key === ' ') {
                    e.preventDefault();
                }
            });
        });

        // Show success message if present in URL
        const urlParams = new URLSearchParams(window.location.search);
        const successMsg = urlParams.get('success');
        if (successMsg) {
            const successDiv = document.getElementById('successMessage');
            successDiv.textContent = decodeURIComponent(successMsg);
            successDiv.classList.add('visible');
        }
    </script>
</body>
</html>