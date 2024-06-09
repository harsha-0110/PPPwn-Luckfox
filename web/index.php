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
            background: linear-gradient(135deg, #f0f0f0, #e0e0e0);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
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
        // Read config.json to get the installation directory
        $config_file = '/etc/pppwn/config.json';
        if (file_exists($config_file)) {
            $config_data = json_decode(file_get_contents($config_file), true);
            if (isset($config_data['install_dir'])) {
                // Execute the run.sh script from the installation directory
                $installation_dir = $config_data['install_dir'];
                $output = shell_exec("$installation_dir/run.sh 2>&1");
                echo "<div class='output'><h2>Script Output:</h2><pre>$output</pre></div>";
            } else {
                echo "<div class='output'><h2>Error:</h2><p>Installation directory not found or invalid: </p></div>";
            }
        } else {
            echo "<div class='output'><h2>Error:</h2><p>Configuration file not found.</p></div>";
        }
    }
    ?>
</div>

</body>
</html>
