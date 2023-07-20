<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$buyer_id = $_POST['user_id']; // Assuming user_id represents the buyer's ID
$seller_id = $_POST['seller_id']; // Assuming seller_id represents the seller's ID
$item_id = $_POST['item_id'];
$item_name = $_POST['item_name']; // Assuming item_name represents the item's name


$sqlinsert = "INSERT INTO `tbl_order`(`buyer_id`, `seller_id`, `item_id`, `item_name`) VALUES ('$buyer_id', '$seller_id', '$item_id', '$item_name')";


if ($conn->query($sqlinsert) === TRUE) {
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
