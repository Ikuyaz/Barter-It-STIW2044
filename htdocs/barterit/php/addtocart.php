<?php
if (!isset($_POST['itemid']) || !isset($_POST['userid']) || !isset($_POST['sellerid'])) {
    $response = array('status' => 'failed', 'message' => 'Incomplete data');
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$itemid = $_POST['itemid'];
$userid = $_POST['userid'];
$sellerid = $_POST['sellerid'];

// Retrieve the item name from tbl_items
$itemname_query = "SELECT `item_name` FROM `tbl_items` WHERE `item_id` = '$itemid'";
$itemname_result = $conn->query($itemname_query);

if ($itemname_result->num_rows > 0) {
    $itemname_row = $itemname_result->fetch_assoc();
    $itemname = $itemname_row['item_name'];
} else {
    $response = array('status' => 'failed', 'message' => 'Failed to retrieve item name');
    sendJsonResponse($response);
    die();
}

$checkitemid = "SELECT * FROM `tbl_carts` WHERE `user_id` = '$userid' AND `item_id` = '$itemid' AND `item_name` = '$itemname'";
$resultqty = $conn->query($checkitemid);
$numresult = $resultqty->num_rows;

if ($numresult > 0) {
    $response = array('status' => 'failed', 'message' => 'Item already exists in cart');
    sendJsonResponse($response);
    die();
}

$sql = "INSERT INTO `tbl_carts` (`item_id`, `user_id`, `seller_id`, `item_name`) VALUES ('$itemid', '$userid', '$sellerid', '$itemname')";

if ($conn->query($sql) === TRUE) {
    $response = array('status' => 'success', 'message' => 'Item added to cart');
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'message' => 'Failed to add item to cart');
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
