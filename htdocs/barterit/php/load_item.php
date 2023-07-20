<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$results_per_page = 6;

if (isset($_POST['pageNo'])) {
    $pageNo = $_POST['pageNo'];
} else {
    $pageNo = 1;
}
$page_first_result = ($pageNo - 1) * $results_per_page;

if (isset($_POST['cartuserid'])){
	$cartuserid = $_POST['cartuserid'];
}else{
	$cartuserid = '0';
}

if (isset($_POST['user_id'])) {
    $user_id = $_POST['user_id'];
    $sqlloaditems = "SELECT * FROM `tbl_items` WHERE user_id = '$user_id'";
    $sqlcart = "SELECT * FROM `tbl_carts` WHERE user_id = '$user_id'";
} else if (isset($_POST['search'])) {
    $search = $_POST['search'];
    $sqlloaditems = "SELECT * FROM `tbl_items` WHERE item_name LIKE '%$search%'";
    $sqlcart = "SELECT * FROM `tbl_carts` WHERE user_id = '$cartuserid'";
} else {
    $sqlloaditems = "SELECT * FROM `tbl_items`";
    $sqlcart = "SELECT * FROM `tbl_carts` WHERE user_id = '$cartuserid'";
}

if (isset($sqlcart)){
	$resultcart = $conn->query($sqlcart);
	$number_of_result_cart = $resultcart->num_rows;
	if ($number_of_result_cart > 0) {
		$totalcart = 0;
		while ($rowcart = $resultcart->fetch_assoc()) {
			$totalcart = ['cartqty'];
		}
	}else{
		$totalcart = 0;
	}
}else{
	$totalcart = 0;
}

$result = $conn->query($sqlloaditems);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloaditems = $sqlloaditems . " LIMIT $page_first_result, $results_per_page";
$result = $conn->query($sqlloaditems);

if ($result->num_rows > 0) {
    $items["items"] = array();
    while ($row = $result->fetch_assoc()) {
        $item = array();
        $item['item_id'] = $row['item_id'];
        $item['user_id'] = $row['user_id'];
        $item['item_name'] = $row['item_name'];
        $item['item_type'] = $row['item_type'];
        $item['item_desc'] = $row['item_desc'];
        $item['item_interest'] = $row['item_interest'];
        $item['item_lat'] = $row['item_lat'];
        $item['item_long'] = $row['item_long'];
        $item['item_state'] = $row['item_state'];
        $item['item_locality'] = $row['item_locality'];
        $item['item_date'] = $row['item_date'];

        array_push($items["items"], $item);
    }
    $response = array(
        'status' => 'success',
        'data' => $items,
        'numofpage' => $number_of_page,
        'numberofresult' => $number_of_result,
        'cartqty' => $totalcart
    );
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null, 'sql'=> $sqlloaditems);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
