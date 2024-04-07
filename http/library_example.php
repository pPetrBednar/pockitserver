<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gallery Page</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-color: #121213;
        }

        .gallery {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
            padding: 20px;
            box-sizing: border-box;
        }

        .gallery-item {
            position: relative;
            overflow: hidden;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .gallery-item:hover {
            transform: translateY(-5px);
        }

        .gallery-image {
            width: 100%;
            height: 100%;
            display: block;
            object-fit: cover; /* Ensure the image covers the entire container */
            border-radius: 8px;
        }

        .filename {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            color: #fff;
            padding: 8px;
            box-sizing: border-box;
            border-radius: 0 0 8px 8px;
            font-size: 14px;
            text-align: center;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .gallery-item:hover .filename {
            opacity: 1;
        }

        /* Button styles */
        .back-button {
            position: fixed;
            bottom: 20px;
            right: 20px;
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .back-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<div class="gallery">
    <?php
    // Directory containing images
    $imageDir = 'images/';
    $images = array_diff(scandir($imageDir), array('..', '.')); // Get all files in the directory, excluding "." and ".."
    $imageFilenames = array_values(preg_grep('/^.*\.jpg$/', $images)); // Filter only filenames ending with ".jpg"

    // Output HTML code to display images
    foreach ($imageFilenames as $filename) {
        $imagePath = $imageDir . $filename;
        echo '<div class="gallery-item">';
        echo '<img src="' . $imagePath . '" alt="' . $filename . '" class="gallery-image">';
        echo '<div class="filename">' . $filename . '</div>';
        echo '</div>';
    }
    ?>
</div>

<!-- Button to go back to index.html -->
<a href="index.html" class="back-button">Back to Index</a>

</body>
</html>
