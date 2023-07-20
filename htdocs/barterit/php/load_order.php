<?php
header('Content-Type: application/json');

include_once("dbconnect.php");

if (isset($_POST['buyer_id'])) {
    $buyer_id = $_POST['buyer_id'];

    $sql = "SELECT * FROM tbl_order WHERE buyer_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $buyer_id);

    if ($stmt->execute()) {
        $result = $stmt->get_result();
        $orders = $result->fetch_all(MYSQLI_ASSOC);
        echo json_encode(['status' => 'success', 'data' => $orders]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to fetch orders']);
    }
} elseif (isset($_POST['seller_id'])) {
    $seller_id = $_POST['seller_id'];

    $sql = "SELECT * FROM tbl_order WHERE seller_id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $seller_id);

    if ($stmt->execute()) {
        $result = $stmt->get_result();
        $orders = $result->fetch_all(MYSQLI_ASSOC);
        echo json_encode(['status' => 'success', 'data' => $orders]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to fetch orders']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'buyer_id or seller_id not provided']);
}
?>
