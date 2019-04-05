<?php

// If you want to use the COMP3311 DB Access Library, include the following two lines
//
// define("LIB_DIR","/import/adams/1/cs3311/public_html/19s1/assignments/a2");
// require_once(LIB_DIR."/db.php");
require_once("db.php");

// Your DB connection parameters, e.g., database name
//
// define("DB_CONNECTION","dbname=a2");
define("DB_CONNECTION","dbname=mydb host=localhost user=postgres password=apple123");

//
// Include your other common PHP code below
// E.g., common constants, functions, etc.
//

function noEmptyEcho($value, $end=""){
    if(!empty($value)){
        echo $value.$end;
    }
}

function dd($var){
    // handy function from laravel 
    var_dump ($var);
    exit();
}

function ifExistReturn($val, $str= ""){
    if (!empty($val)){
        return $str;
    }
    return "";
}  


function array_last($array){
    return $array[sizeof($array) -1];
}

$movie_path_cache= array();

function get_movie_path($array){
    /**
     * $array is a length two array as  [$src, $dest]
     */
    
    // get the connection 
    global $db, $movie_path_cache;

    if(!empty($movie_path_cache[$array[0]][$array[1]])){
        // dd("cache hit");
        // cache is not empty, we don't need to fire up a sql 
        return $movie_path_cache[$array[0]][$array[1]];
    }

    $sql= "select * from actor_path_to_strings(".$array[0].",".$array[1].");";
    $r = dbQuery($db, $sql);
    // res to return 
    $res = array();

    while ($t =dbNext($r)){
        array_push($res,
        $t[0]." was in ".$t[1]." ".
        ifExistReturn($t[2],"(".$t[2].")").
        " with ".$t[3]);
    }

    // store a copy in cache 
    $movie_path_cache[$array[0]][$array[1]] = $res;

    // return the result 
    return $res;
    

}

?>
