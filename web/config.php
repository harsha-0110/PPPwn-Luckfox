<?php
// Define the file where the configuration will be stored
$config_file = '/etc/pppwn/config.ini';
$goldhen_versions = ["9.00", "9.60", "10.00", "10.01", "11.00"];
$hen_versions = ["9.00", "9.03", "9.04", "9.50", "9.51", "9.60", "10.00", "10.01", "10.50", "10.70", "10.71", "11.00"];
$pppwn_options = [
    "pppwn1" => "PPPwn with old IPv6",
    "pppwn2" => "PPPwn with new IPv6",
    "pppwn3" => "PPPwssn updated by nn9dev"
];

// Function to load configuration from the file
function load_config($file) {
    if (file_exists($file)) {
        $config = parse_ini_file($file);
        // Convert boolean values to actual boolean
        foreach ($config as $key => $value) {
            if (is_string($value)) {
                $value = strtolower($value);
                if ($value === 'true') {
                    $config[$key] = true;
                } elseif ($value === 'false') {
                    $config[$key] = false;
                }
            }
        }
        return $config;
    }
    return [];
}

// Function to save configuration to the file
function save_config($file, $config) {
    $content = '';
    foreach ($config as $key => $value) {
        if (is_bool($value)) {
            $value = $value ? 'true' : 'false';
        }
        $content .= "$key=" . "\"$value\"\n";
    }
    file_put_contents($file, $content);
}

// Define options for select elements
$fw_options = [];
foreach ($goldhen_versions as $v) {
    $fw_options[str_replace('.', '', $v) . '_goldhen'] = $v . ' - Goldhen';
}
foreach ($hen_versions as $v) {
    $fw_options[str_replace('.', '', $v) . '_hen'] = $v . ' - Hen';
}
// Load current configuration
$config = load_config($config_file);

// Handle form submission
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['FW_HEN_VERSION']) && isset($_POST['TIMEOUT'])) {
        $fw_hen_version = explode('_', $_POST['FW_HEN_VERSION']);
        $config['FW_VERSION'] = $fw_hen_version[0];
        $config['HEN_TYPE'] = $fw_hen_version[1];
        $config['PPPWN'] = $_POST['PPPWN'];
        $config['TIMEOUT'] = $_POST['TIMEOUT'];
        $config['WAIT_AFTER_PIN'] = $_POST['WAIT_AFTER_PIN'];
        $config['GROOM_DELAY'] = $_POST['GROOM_DELAY'];
        $config['BUFFER_SIZE'] = $_POST['BUFFER_SIZE'];
        // Handle boolean values explicitly
        $config['AUTO_RETRY'] = isset($_POST['AUTO_RETRY']);
        $config['NO_WAIT_PADI'] = isset($_POST['NO_WAIT_PADI']);
        $config['REAL_SLEEP'] = isset($_POST['REAL_SLEEP']);
        $config['AUTO_START'] = isset($_POST['AUTO_START']);
        $config['OLD_IPv6'] = isset($_POST['OLD_IPv6']);
        // nn9dev PPPwn options
        $config['SPRAY_NUM'] = $_POST['SPRAY_NUM'];
        $config['PIN_NUM'] = $_POST['PIN_NUM'];
        $config['CORRUPT_NUM'] = $_POST['CORRUPT_NUM'];

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
    <style><?php include 'config.css'; ?></style>
</head>
<body>

<div class="container">
    <h1>PPPwn-Luckfox Configuration</h1>

    <?php if (isset($message)): ?>
        <div class="message"><?php echo htmlspecialchars($message); ?></div>
    <?php endif; ?>

    <form method="POST">
        <label for="FW_HEN_VERSION">PS4 Firmware and Goldhen/Hen:</label>
        <select id="FW_HEN_VERSION" name="FW_HEN_VERSION" required>
            <?php foreach ($fw_options as $value => $label): ?>
                <option value="<?php echo htmlspecialchars($value); ?>" <?php if ($config['FW_VERSION'] . '_' . $config['HEN_TYPE'] == $value) echo 'selected'; ?>>
                    <?php echo htmlspecialchars($label); ?>
                </option>
            <?php endforeach; ?>
        </select>

        <label for="PPPWN">Select PPPwn version:</label>
        <select id="PPPWN" name="PPPWN" required>
            <?php foreach ($pppwn_options as $value => $label): ?>
                <option value="<?php echo htmlspecialchars($value); ?>" <?php if ($config['PPPWN'] == $value) echo 'selected'; ?>>
                    <?php echo htmlspecialchars($label); ?>
                </option>
            <?php endforeach; ?>
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

        <p>nn9dev PPPwn options (Only works with nn9dev PPPwn):</p>

        <label for="SPRAY_NUM">Spray Number:</label>
        <input type="number" id="SPRAY_NUM" name="SPRAY_NUM" value="<?php echo htmlspecialchars($config['SPRAY_NUM']); ?>" required>

        <label for="PIN_NUM">Pin Number:</label>
        <input type="number" id="PIN_NUM" name="PIN_NUM" value="<?php echo htmlspecialchars($config['PIN_NUM']); ?>" required>

        <label for="CORRUPT_NUM">Corrupt Number:</label>
        <input type="number" id="CORRUPT_NUM" name="CORRUPT_NUM" value="<?php echo htmlspecialchars($config['CORRUPT_NUM']); ?>" required>

        <div class="checkbox-group">
            <input type="checkbox" id="OLD_IPv6" name="OLD_IPv6" <?php echo !empty($config['OLD_IPv6']) ? 'checked' : ''; ?>>
            <label for="OLD_IPv6">Use Old IPv6</label>
        </div>

        <div class="btn">
            <button type="button" onclick="window.location.href = '../'">Back</button>
            <input type="submit" value="Update Configuration">
        </div>
    </form>
</div>

</body>
</html>