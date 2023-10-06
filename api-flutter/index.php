<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
// Koneksi ke database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "uts_mobile";
$conn = new mysqli(
    $servername,
    $username,
    $password,
    $dbname
);
if ($conn->connect_error) {
    die("Koneksi ke database gagal: " . $conn->connect_error);
}
$method = $_SERVER["REQUEST_METHOD"];
if ($method === "GET") {
    // Mengambil data pekerjaan
    $sql = "SELECT * FROM pekerjaan";
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        $pekerjaan = array();
        while ($row = $result->fetch_assoc()) {
            $pekerjaan[] = $row;
        }
        echo json_encode($pekerjaan);
    } else {
        echo "Data pekerjaan kosong.";
    }
}
if ($method === "POST") {
    // Menambahkan data pekerjaan
    $data = json_decode(file_get_contents("php://input"), true);
    $pekerjaan = $data["pekerjaan"];
    $status_p = $data["status_p"];
    $sql = "INSERT INTO pekerjaan (pekerjaan, status_p) VALUES ('$pekerjaan', '$status_p')";
    if ($conn->query($sql) === TRUE) {
        $data['pesan'] = 'berhasil';
        //echo "Berhasil tambah data";
    } else {
        $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
    }
    echo json_encode($data);
}
if ($method === "PUT") {
    // Memperbarui data pekerjaan
    $data = json_decode(file_get_contents("php://input"), true);
    $id = $data["id"];
    $pekerjaan = $data["pekerjaan"];
    $status_p = $data["status_p"];
    $sql = "UPDATE pekerjaan SET pekerjaan='$pekerjaan', status_p='$status_p' WHERE id=$id";
    if ($conn->query($sql) === TRUE) {
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
}
if ($method === "DELETE") {
    // Menghapus data pekerjaan
    $id = $_GET["id"];
    $sql = "DELETE FROM pekerjaan WHERE id=$id";
    if ($conn->query($sql) === TRUE) {
        $data['pesan'] = 'berhasil';
    } else {
        $data['pesan'] = "Error: " . $sql . "<br>" . $conn->error;
    }
    echo json_encode($data);
}

$conn->close();
