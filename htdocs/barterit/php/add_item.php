<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$item_name = $_POST['itemname'];
$item_desc = $_POST['itemdesc'];
$item_type = $_POST['itemtype'];
$item_interest = $_POST['iteminterest'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$state = $_POST['state'];
$locality = $_POST['locality'];
$image = json_decode($_POST['image']);

if (!is_array($image)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$sqlinsert = "INSERT INTO `tbl_items`(`user_id`,`item_name`, `item_desc`, `item_type`, `item_interest`, `item_lat`, `item_long`, `item_state`, `item_locality`) VALUES ('$userid','$item_name','$item_desc','$item_type','$item_interest','$latitude','$longitude','$state','$locality')";

if ($conn->query($sqlinsert) === TRUE) {
    $item_id = mysqli_insert_id($conn);
    $photo_number = 1;

    foreach ($image as $index => $base64Image) {
        $imageData = base64_decode($base64Image);
        $filename = $item_id . '-' . $photo_number;
        $response = array('status' => 'success', 'data' => null);
        $path = '../assets/images/'.$filename.'.png';
        file_put_contents($path, $imageData);
        
        $photo_number++;
    }
    
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
