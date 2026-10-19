<?php
$pdo = new PDO("mysql:host=localhost;dbname=catering_app;charset=utf8mb4", "root", "");

$name     = $_POST["name"];
$email    = $_POST["email"];
$passwort = password_hash($_POST["passwort"], PASSWORD_DEFAULT); 
$sql = "INSERT INTO kunden (name, email, passwort) VALUES (:name, :email, :passwort)";

$statement = $pdo->prepare($sql);

$data = [
    "name"     => $name,
    "email"    => $email,
    "passwort" => $passwort,
];

$statement->execute($data);
?>