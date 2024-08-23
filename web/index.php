<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PPPwn-Luckfox Dashboard</title>
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
            max-width: 800px;
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
            min-width: 150px;
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
        <h1>PPPwn-Luckfox Dashboard</h1>
        <form method="post" action="" style="display:inline;">
            <button type="submit" name="run_pppwn" class="button">Run PPPwn</button>
        </form>
        <form method="post" action="" style="display:inline;">
            <button type="submit" name="shutdown" class="button">Shutdown</button>
        </form>
        <form method="post" action="" style="display:inline;">
            <button type="submit" name="eth_down" class="button">eth0 off</button>
        </form>
        <a href="config.php" class="button">Config</a> <br>
        <a href="./900/index.html" class="button">900 Payloads</a>
        <a href="./1100/index.html" class="button">1100 Payloads</a>
        <a href="./all/index.html" class="button">All FW Payloads</a> <br>
        <a href="./linux/index.html" class="button">PS4 Linux Payloads</a>
        <a href="./linux-pro/index.html" class="button">PS4 Pro Linux Payloads</a>
        <?php
        if ($_SERVER['REQUEST_METHOD'] === 'POST') {
            $baseLockDir = '/tmp/';
            $webRunLockFile = $baseLockDir . 'web_run.lock';
            $shutdownLockFile = $baseLockDir . 'shutdown.lock';
            $ethdownLockFile = $baseLockDir . 'eth_down.lock';
            
            // Create the lock directory if it doesn't exist
            if (!is_dir($baseLockDir)) {
                mkdir($baseLockDir, 0777, true);
            }

            if (isset($_POST['run_pppwn'])) {
                // Create the web_run lock file
                if (file_put_contents($webRunLockFile, 'locked') !== false) {
                    echo "<div class='output'><p>Starting PPPwn...</p></div>";
                } else {
                    echo "<div class='output'><h2>Error:</h2><p>Unable to create web_run lock file.</p></div>";
                }
            }

            if (isset($_POST['shutdown'])) {
                // Create the shutdown lock file
                if (file_put_contents($shutdownLockFile, 'locked') !== false) {
                    echo "<div class='output'><p>Powering off LuckFox...</p></div>";
                } else {
                    echo "<div class='output'><h2>Error:</h2><p>Unable to create shutdown lock file.</p></div>";
                }
            }

            if (isset($_POST['eth_down'])) {
                // Create the eth_down lock file
                if (file_put_contents($ethdownLockFile, 'locked') !== false) {
                    echo "<div class='output'><p>Turning of eth0 Interface...</p></div>";
                } else {
                    echo "<div class='output'><h2>Error:</h2><p>Unable to create eth_down lock file.</p></div>";
                }
            }
        }
        ?>
    </div>
</body>
</html>
