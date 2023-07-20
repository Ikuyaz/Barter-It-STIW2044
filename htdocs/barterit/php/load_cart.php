<?php
include_once("dbconnect.php");

if (!isset($_POST['userid'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$userid = $_POST['userid'];
$sqlcart = "SELECT * FROM `tbl_carts` INNER JOIN `tbl_items` ON tbl_carts.item_id = tbl_items.item_id WHERE tbl_carts.user_id = '$userid'";
$result = $conn->query($sqlcart);

if ($result->num_rows > 0) {
    $cartitems = array('carts' => array());
    while ($row = $result->fetch_assoc()) {
        $cartlist = array(
            'cart_id' => $row['cart_id'],
            'item_id' => $row['item_id'],
            'item_name' => $row['item_name'],
            'seller_id' => $row['seller_id'],
            'user_id' => $row['user_id'],
            'reg_date' => $row['reg_date'],
            // Add more fields if needed
        );
        array_push($cartitems['carts'], $cartlist);
    }
    $response = array('status' => 'success', 'data' => $cartitems);
} else {
    $response = array('status' => 'failed', 'data' => null);
}

sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
