<?php
$file = "/var/log/pppwn.log";

if (file_exists($file)) {
    echo nl2br(file_get_contents($file));
} else {
    echo "File not found.";
}
