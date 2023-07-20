<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'message' => 'Invalid request', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_id = $_POST['userid'];
$new_name = $_POST['newname'];
$new_phone = $_POST['newphone'];
$new_password = sha1($_POST['newpass']);

$image = $_POST['image'];

// Check if images were uploaded
if (isset($image)) {
    $image_folder = '../assets/profiles/';

    $decoded_string = base64_decode($image);
    $filename = $user_id . '.png';
    $path = $image_folder . $filename;
    file_put_contents($path, $decoded_string);
} else {
    $filename = null; // If no images were uploaded, set the filename to null
}

// Update the database with the filenames of the uploaded images
$sql = "UPDATE tbl_user SET user_name = ?, user_phone = ?, user_password = ? WHERE user_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("sssi", $new_name, $new_phone, $new_password, $user_id);

$response = array();

if ($stmt->execute()) {
    $response['status'] = 'success';
    $response['message'] = 'Update successful';
} else {
    $response['status'] = 'failed';
    $response['message'] = 'Update failed';
}

$stmt->close();
$conn->close();

sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
