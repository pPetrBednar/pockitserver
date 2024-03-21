<?php
// Get the directory path from the query string parameter 'dir'
if (!isset($_GET['dir'])) {
    echo "No directory selected";
    exit;
}

if (!isset($_GET['root'])) {
    echo "No root directory provided";
    exit;
}

$dir = $_GET['dir'];
$root = $_GET['root'];
$dir = rtrim($dir, '/\\'); // Remove trailing slashes

$folderIcon = base64_encode(file_get_contents('..\..\res\folder-icon.png'));
$fileIcon = base64_encode(file_get_contents('..\..\res\file-icon.png'));
$unknownIcon = base64_encode(file_get_contents('..\..\res\unknown-icon.png'));

// Function to format file size in human-readable format
function formatSize($size)
{
    $units = array('B', 'KB', 'MB', 'GB', 'TB');
    $i = 0;
    while ($size >= 1024 && $i < count($units) - 1) {
        $size /= 1024;
        $i++;
    }
    return round($size, 2) . ' ' . $units[$i];
}

// Function to get file type icon
function getFileIcon($entry)
{
    global $folderIcon, $fileIcon, $unknownIcon;

    if (is_dir($entry)) {
        return $folderIcon;
    } elseif (is_file($entry)) {
        return $fileIcon;
    } else {
        return $unknownIcon;
    }
}

// Function to get file last modified time
function getLastModified($entry)
{
    return date('Y-m-d H:i', filemtime($entry));
}

// Open the directory
if ($handle = opendir($dir)) {
    ?>
    <!DOCTYPE HTML>
    <html>
    <head>
        <title>Index of <?= $root ?></title>
    </head>
    <body>
    <h1>Index of <?= $root ?></h1>
    <table>
        <tr>
            <th class="type">Type</th>
            <th class="name">Name</th>
            <th class="modify">Last modified</th>
            <th class="size">Size</th>
        </tr>
        <?php
        // Output directory listing
        while (false !== ($entry = readdir($handle))) {
            if ($entry != '.' && $entry != '..') {
                $entryPath = "$dir/$entry";
                ?>

                <tr>
                    <td class="type">
                        <img class="icon" src="data:image/png;base64, <?= getFileIcon($entryPath) ?>" alt="Icon">
                    </td>
                    <td class="name"><a href="<?= $root . "/" . $entry ?>"><?= $entry ?></a></td>
                    <td class="modify"><?= getLastModified($entryPath) ?></td>
                    <td class="size">
                        <?= is_file($entryPath) ? formatSize(filesize($entryPath)) : "-" ?>
                    </td>
                </tr>
                <?php
            }
        }

        // Close directory handle
        closedir($handle);
        ?>

    </table>
    </body>
    <style>
        .name {
            width: 400px;
            text-align: left;
        }

        .modify {
            width: 150px;
            text-align: left;
        }

        .size {
            width: 200px;
            text-align: left;
        }

        .icon {
            width: 25px;
            height: 25px;
        }

        .type {
            width: 50px;
            text-align: left;
        }
    </style>
    </html>
    <?php
} else {
    echo "Unable to open directory $dir";
}
?>
