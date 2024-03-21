<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pockitserver</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <link rel="icon" type="image/ico" href="res/icon.ico">
</head>
<body onload="liveReload(1000)">
<script src="js/live-reload.js"></script>
<div class="center-me">
    <?php
    if ("true" == "true") {
        ?>
        <h1>Hello from PHP</h1>
        <?php
    }

    for ($i = 0; $i < 3; $i++) {
        ?>
        <span>Hello <?= $i ?></span>
        <?php

    }
    ?>
    <a href="index.html">Click me to go back</a>
</div>
</body>
</html>