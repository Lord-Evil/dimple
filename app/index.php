<?php 
header('Content-Type: text/html');
$z=25; 
?>
Hello1, <?= 2*$z ?>
Hello, <?= 4*$z ?>

<?php
print_r($_SERVER);
print_r($_GET);
print_r($_POST);
print_r($_HEADER);
print_r($_COOKIE);
/*print_r($_SESSION);*/
header('Location: http://www.example.com/');
?>
<form method=POST>
	<input type="text" name="txtBox1">
	<input type="file" name="file1">
	<input type="submit" value="OK">
</form>