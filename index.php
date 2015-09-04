<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    </head>
    <body>
        <h1>Welcome to the Varnish AB testing demo</h1>
<?php
    if ($_POST["name"]) {
       echo "<h1>(Successful conversion)</h1>";
    }
    header("Vary: abgroup");
    $img = "";
    if ($_SERVER["HTTP_ABGROUP"] == "A") {
        $img = "/640px-Cute_beagle_puppy_lilly.jpg";
	$attr = "<a href=\"http://commons.wikimedia.org/wiki/File:Cute_beagle_puppy_lilly.jpg\">Photo</a> by Garrett 222 / CC-BY-SA";
    }
    else if ($_SERVER["HTTP_ABGROUP"] == "B") { 
        $img = "/640px-Stray_kitten_Rambo002.jpg";
	$attr = "<a href=\"http://commons.wikimedia.org/wiki/File:Stray_kitten_Rambo002.jpg\">Photo</a> by Krzysztof P. Jasiutowicz / CC-BY-SA";
    }

    echo "<img src=\"$img\" />";
    echo "<p><small>$attr</small></p>";
	
?>

	
      <p>
	<form action="/foo.php" method="POST">
	Name: <input type="text" name="name"> <br />
	Email: <input type="text" name="email">
	<input type="submit">
	</form>
      </p>
    </body>
</html>
