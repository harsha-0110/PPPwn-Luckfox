<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PPPwn Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: black;
        }
        .container {
            max-width: 600px;
            padding: 40px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        h1 {
            font-size: 32px;
            margin-bottom: 40px;
            color: #333;
        }
        .button {
            display: inline-block;
            margin: 10px;
            padding: 15px 30px;
            font-size: 18px;
            color: #fff;
            background: linear-gradient(135deg, #007bff, #0056b3);
            border: none;
            border-radius: 8px;
            text-decoration: none;
            transition: background 0.3s, transform 0.2s;
            cursor: pointer;
        }
        .button:hover {
            background: linear-gradient(135deg, #0056b3, #004099);
            transform: translateY(-2px);
        }
        .button:active {
            transform: translateY(1px);
        }
        .output {
            margin-top: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border: 1px solid #ccc;
            border-radius: 8px;
            white-space: pre-wrap;
            text-align: left;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>PPPwn Dashboard</h1>
    <a href="config.php" class="button">Config</a>
    <a href="payloads.html" class="button">Payloads</a>
    <form method="post" action="" style="display:inline;">
        <button type="submit" name="run_pppwn" class="button">Run PPPwn</button>
    </form>

    <?php
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['run_pppwn'])) {
        // Read config.json to get the installation directory and other configuration values
        $config_file = '/etc/pppwn/config.json';
        if (file_exists($config_file)) {
            $config_data = json_decode(file_get_contents($config_file), true);
            if (isset($config_data['install_dir'])) {
                $installation_dir = $config_data['install_dir'];

                // Define the paths to the stage1 and stage2 payloads based on FW_VERSION
                $fw_version = $config_data['FW_VERSION'];
                $stage1_payload = "$installation_dir/stage1/stage1_${fw_version}.bin";
                $stage2_payload = "$installation_dir/stage2/stage2_${fw_version}.bin";

                // Build the base pppwn command
                $cmd = "sudo $installation_dir/pppwn --interface eth0 --fw $fw_version --stage1 $stage1_payload --stage2 $stage2_payload";

                // Append optional parameters if they are not null or false
                if ($config_data['TIMEOUT'] !== null) {
                    $cmd .= " --timeout " . $config_data['TIMEOUT'];
                }
                if ($config_data['WAIT_AFTER_PIN'] !== null) {
                    $cmd .= " --wait-after-pin " . $config_data['WAIT_AFTER_PIN'];
                }
                if ($config_data['GROOM_DELAY'] !== null) {
                    $cmd .= " --groom-delay " . $config_data['GROOM_DELAY'];
                }
                if ($config_data['BUFFER_SIZE'] !== null) {
                    $cmd .= " --buffer-size " . $config_data['BUFFER_SIZE'];
                }
                if ($config_data['AUTO_RETRY'] === true) {
                    $cmd .= " --auto-retry";
                }
                if ($config_data['NO_WAIT_PADI'] === true) {
                    $cmd .= " --no-wait-padi";
                }
                if ($config_data['REAL_SLEEP'] === true) {
                    $cmd .= " --real-sleep";
                }

                // Execute the command
                shell_exec($cmd);
            } else {
                echo "<div class='output'><h2>Error:</h2><p>Installation directory not found or invalid.</p></div>";
            }
        } else {
            echo "<div class='output'><h2>Error:</h2><p>Configuration file not found.</p></div>";
        }
    }
    ?>



</div>

</body>
</html>
