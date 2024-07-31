<?php
// Define the file where the configuration will be stored
$config_file = '/etc/pppwn/config.json';

// Function to load configuration from the file
function load_config($file) {
    if (file_exists($file)) {
        $config_data = file_get_contents($file);
        return json_decode($config_data, true);
    }
}

// Function to save configuration to the file
function save_config($file, $config) {
    $config_data = json_encode($config, JSON_PRETTY_PRINT);
    file_put_contents($file, $config_data);
}

// Load current configuration
$config = load_config($config_file);

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['FW_VERSION']) && isset($_POST['TIMEOUT'])) {
        $config['FW_VERSION'] = $_POST['FW_VERSION'];
        $config['HEN_TYPE'] = $_POST['HEN_TYPE'];
        $config['TIMEOUT'] = $_POST['TIMEOUT'];
        $config['WAIT_AFTER_PIN'] = $_POST['WAIT_AFTER_PIN'];
        $config['GROOM_DELAY'] = $_POST['GROOM_DELAY'];
        $config['BUFFER_SIZE'] = $_POST['BUFFER_SIZE'];
        $config['AUTO_RETRY'] = isset($_POST['AUTO_RETRY']);
        $config['NO_WAIT_PADI'] = isset($_POST['NO_WAIT_PADI']);
        $config['REAL_SLEEP'] = isset($_POST['REAL_SLEEP']);
        $config['AUTO_START'] = isset($_POST['AUTO_START']);
        save_config($config_file, $config);
        $message = "Configuration updated successfully.";
    } else {
        $message = "Error: Please provide all values.";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PPPwn Configuration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: black;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        h1 {
            font-size: 32px;
            margin-bottom: 20px;
            text-align: center;
            color: #333;
        }
        .message {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            border-radius: 8px;
            font-size: 16px;
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        label {
            font-size: 18px;
            font-weight: bold;
            color: #555;
        }
        input[type="text"],
        input[type="number"],
        select {
            padding: 15px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 18px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        input[type="text"]:focus,
        input[type="number"]:focus,
        select:focus {
            border-color: #007bff;
            box-shadow: 0 0 8px rgba(0, 123, 255, 0.25);
        }
        input[type="checkbox"] {
            transform: scale(1.5);
            margin-right: 10px;
        }
        .checkbox-group {
            display: flex;
            align-items: center;
        }
        .checkbox-group label {
            margin: 0;
            font-size: 18px;
            font-weight: normal;
        }
        input[type="submit"] {
            padding: 15px;
            border: none;
            border-radius: 8px;
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: #fff;
            font-size: 18px;
            cursor: pointer;
            align-self: center;
            transition: background 0.3s;
        }
        input[type="submit"]:hover {
            background: linear-gradient(135deg, #0056b3, #004099);
        }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const fwVersionSelect = document.getElementById('FW_VERSION');
            const exploitOptionSelect = document.getElementById('HEN_TYPE');

            function updateExploitOptions() {
                const fwVersion = fwVersionSelect.value;
                let options = [];

                switch (fwVersion) {
                    case '900':
                        options = ['HEN', 'GoldHEN'];
                        break;
                    case '960':
                        options = ['HEN'];
                        break;
                    case '1000':
                    case '1001':
                        options = ['GoldHEN'];
                        break;
                    case '1100':
                        options = ['HEN', 'GoldHEN'];
                        break;
                }

                exploitOptionSelect.innerHTML = '';
                options.forEach(option => {
                    const opt = document.createElement('option');
                    opt.value = option;
                    opt.textContent = option;
                    exploitOptionSelect.appendChild(opt);
                });
            }

            fwVersionSelect.addEventListener('change', updateExploitOptions);

            updateExploitOptions();  // Initial call to set options based on the loaded configuration
        });
    </script>
</head>
<body>

<div class="container">
    <h1>PPPwn-Luckfox Configuration</h1>

    <?php if (isset($message)): ?>
        <div class="message"><?php echo $message; ?></div>
    <?php endif; ?>

    <form method="POST">
        <label for="FW_VERSION">PS4 Firmware Version:</label>
        <select id="FW_VERSION" name="FW_VERSION" required>
            <option value="900" <?php if ($config['FW_VERSION'] == '900') echo 'selected'; ?>>9.00</option>
            <option value="960" <?php if ($config['FW_VERSION'] == '960') echo 'selected'; ?>>9.60</option>
            <option value="1000" <?php if ($config['FW_VERSION'] == '1000') echo 'selected'; ?>>10.00</option>
            <option value="1001" <?php if ($config['FW_VERSION'] == '1001') echo 'selected'; ?>>10.01</option>
            <option value="1100" <?php if ($config['FW_VERSION'] == '1100') echo 'selected'; ?>>11.00</option>
        </select>

        <label for="HEN_TYPE">Hen/Goldhen:</label>
        <select id="HEN_TYPE" name="HEN_TYPE" required>
            <!-- Options will be populated by JavaScript based on FW_VERSION -->
        </select>

        <label for="TIMEOUT">Timeout in seconds:</label>
        <input type="number" id="TIMEOUT" name="TIMEOUT" value="<?php echo htmlspecialchars($config['TIMEOUT']); ?>" required>

        <label for="WAIT_AFTER_PIN">Wait After Pin in seconds:</label>
        <input type="number" id="WAIT_AFTER_PIN" name="WAIT_AFTER_PIN" value="<?php echo htmlspecialchars($config['WAIT_AFTER_PIN']); ?>" required>

        <label for="GROOM_DELAY">Groom Delay:</label>
        <input type="number" id="GROOM_DELAY" name="GROOM_DELAY" value="<?php echo htmlspecialchars($config['GROOM_DELAY']); ?>" required>

        <label for="BUFFER_SIZE">Buffer Size in bytes:</label>
        <input type="number" id="BUFFER_SIZE" name="BUFFER_SIZE" value="<?php echo htmlspecialchars($config['BUFFER_SIZE']); ?>" required>

        <div class="checkbox-group">
            <input type="checkbox" id="AUTO_RETRY" name="AUTO_RETRY" <?php if ($config['AUTO_RETRY']) echo 'checked'; ?>>
            <label for="AUTO_RETRY">Auto Retry</label>
        </div>

        <div class="checkbox-group">
            <input type="checkbox" id="NO_WAIT_PADI" name="NO_WAIT_PADI" <?php if ($config['NO_WAIT_PADI']) echo 'checked'; ?>>
            <label for="NO_WAIT_PADI">No Wait PADI</label>
        </div>

        <div class="checkbox-group">
            <input type="checkbox" id="REAL_SLEEP" name="REAL_SLEEP" <?php if ($config['REAL_SLEEP']) echo 'checked'; ?>>
            <label for="REAL_SLEEP">Real Sleep</label>
        </div>

        <div class="checkbox-group">
            <input type="checkbox" id="AUTO_START" name="AUTO_START" <?php if ($config['AUTO_START']) echo 'checked'; ?>>
            <label for="AUTO_START">Auto Run on Start-Up</label>
        </div>
        <input type="submit" value="Update Configuration">
    </form>
</div>

</body>
</html>
