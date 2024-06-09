<?php
// Define the file where the configuration will be stored
$config_file = '/etc/pppwn/config.json';

// Function to load configuration from the file
function load_config($file) {
    if (file_exists($file)) {
        $config_data = file_get_contents($file);
        return json_decode($config_data, true);
    } else {
        return array(
            'FW_VERSION' => '1100', 
            'TIMEOUT' => '10',
            'WAIT_AFTER_PIN' => '1',
            'GROOM_DELAY' => '4',
            'BUFFER_SIZE' => '0',
            'AUTO_RETRY' => false,
            'NO_WAIT_PADI' => false,
            'REAL_SLEEP' => false
        ); // default values
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
        $config['TIMEOUT'] = $_POST['TIMEOUT'];
        $config['WAIT_AFTER_PIN'] = $_POST['WAIT_AFTER_PIN'];
        $config['GROOM_DELAY'] = $_POST['GROOM_DELAY'];
        $config['BUFFER_SIZE'] = $_POST['BUFFER_SIZE'];
        $config['AUTO_RETRY'] = isset($_POST['AUTO_RETRY']);
        $config['NO_WAIT_PADI'] = isset($_POST['NO_WAIT_PADI']);
        $config['REAL_SLEEP'] = isset($_POST['REAL_SLEEP']);
        save_config($config_file, $config);
        $message = "Configuration updated successfully.";
    } else {
        $message = "Error: Please provide both FW_VERSION and TIMEOUT.";
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
            background-color: #f0f0f0;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            font-size: 24px;
            margin-bottom: 20px;
        }
        .message {
            margin-bottom: 20px;
            padding: 10px;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            border-radius: 5px;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"],
        input[type="number"],
        select {
            margin-bottom: 10px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }
        input[type="submit"] {
            padding: 10px;
            border: none;
            border-radius: 5px;
            background-color: #007bff;
            color: #fff;
            font-size: 16px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>PPPwn Configuration</h1>

    <?php if (isset($message)): ?>
        <div class="message"><?php echo $message; ?></div>
    <?php endif; ?>

    <form method="POST">
        <label for="FW_VERSION">Firmware Version (FW_VERSION):</label>
        <select id="FW_VERSION" name="FW_VERSION" required>
            <option value="900" <?php if ($config['FW_VERSION'] == '900') echo 'selected'; ?>>900</option>
            <option value="1000" <?php if ($config['FW_VERSION'] == '1000') echo 'selected'; ?>>1000</option>
            <option value="1001" <?php if ($config['FW_VERSION'] == '1001') echo 'selected'; ?>>1001</option>
            <option value="1100" <?php if ($config['FW_VERSION'] == '1100') echo 'selected'; ?>>1100</option>
        </select>

        <label for="TIMEOUT">Timeout (TIMEOUT) in seconds:</label>
        <input type="number" id="TIMEOUT" name="TIMEOUT" value="<?php echo htmlspecialchars($config['TIMEOUT']); ?>" required>

        <label for="WAIT_AFTER_PIN">Wait After Pin (WAIT_AFTER_PIN) in seconds:</label>
        <input type="number" id="WAIT_AFTER_PIN" name="WAIT_AFTER_PIN" value="<?php echo htmlspecialchars($config['WAIT_AFTER_PIN']); ?>" required>

        <label for="GROOM_DELAY">Groom Delay (GROOM_DELAY):</label>
        <input type="number" id="GROOM_DELAY" name="GROOM_DELAY" value="<?php echo htmlspecialchars($config['GROOM_DELAY']); ?>" required>

        <label for="BUFFER_SIZE">Buffer Size (BUFFER_SIZE) in bytes:</label>
        <input type="number" id="BUFFER_SIZE" name="BUFFER_SIZE" value="<?php echo htmlspecialchars($config['BUFFER_SIZE']); ?>" required>

        <label for="AUTO_RETRY">Auto Retry (AUTO_RETRY):</label>
        <input type="checkbox" id="AUTO_RETRY" name="AUTO_RETRY" <?php if ($config['AUTO_RETRY']) echo 'checked'; ?>>

        <label for="NO_WAIT_PADI">No Wait PADI (NO_WAIT_PADI):</label>
        <input type="checkbox" id="NO_WAIT_PADI" name="NO_WAIT_PADI" <?php if ($config['NO_WAIT_PADI']) echo 'checked'; ?>>

        <label for="REAL_SLEEP">Real Sleep (REAL_SLEEP):</label>
        <input type="checkbox" id="REAL_SLEEP" name="REAL_SLEEP" <?php if ($config['REAL_SLEEP']) echo 'checked'; ?>>

        <input type="submit" value="Update Configuration">
    </form>
</div>

</body>
</html>
