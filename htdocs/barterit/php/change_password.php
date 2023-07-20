<?php
header('Content-Type: application/json'); // Add this line to set the response type to JSON

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'message' => 'Invalid request');
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_id = $_POST['user_id']; 
$currentPassword = $_POST['currentpassword'];
$newPassword = $_POST['newpassword'];

$sql = "SELECT * FROM `tbl_user` WHERE `user_id` = '$user_id' AND `user_password` = '$currentPassword'";
$result = $conn->query($sql);

if ($result === false) {
    $response = array('status' => 'failed', 'message' => 'Database error: ' . mysqli_error($conn));
} elseif ($result->num_rows == 1) {

    $updateSql = "UPDATE `tbl_user` SET `user_password` = SHA1('$newPassword') WHERE `user_id` = '$user_id'";
    if ($conn->query($updateSql) === TRUE) {
        $response = array('status' => 'success', 'message' => 'Password updated successfully');
    } else {
        $response = array('status' => 'failed', 'message' => 'Failed to update password: ' . mysqli_error($conn));
    }
} else {
    $response = array('status' => 'failed', 'message' => 'Invalid current password');
}

sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    echo json_encode($sentArray);
}
?>
