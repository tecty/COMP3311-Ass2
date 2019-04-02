#!/usr/bin/php
<?php

// include the common PHP code file
require("a2.php");

// PROGRAM BODY BEGINS

$usage = "Usage: $argv[0] Actor";
$db = dbConnect(DB_CONNECTION);

// Check arguments
if (count($argv) < 2) exit("$usage\n");

// Get the return results
$val = "%".$argv[1]."%";
$q = "
select * from movie where lower(title) like %s order by year;
";
$r = dbQuery($db, mkSQL($q, $val));

// Iterate through the results and print
$i = 1;
while ($t = dbNext($r)) {
  echo "$i. $t[0] -- $t[1] ($t[2], $t[3], $t[4])\n";
  $i++;
}

?>
