<?php
session_start();

$pdo = new PDO("mysql:host=localhost;dbname=catering_app;charset=utf8mb4", "root", "");

$email    = $_POST["email"] ?? '';
$passwort = $_POST["passwort"] ?? '';

if (!empty($email) && !empty($passwort)) {
    $sql = "SELECT * FROM kunden WHERE email = :email";
    $statement = $pdo->prepare($sql);
    $statement->execute(["email" => $email]);
    $user = $statement->fetch(PDO::FETCH_ASSOC);

    if ($user && password_verify($passwort, $user["passwort"])) {
        $_SESSION["user_id"]   = $user["id"];
        $_SESSION["user_name"] = $user["name"];

        echo "Login erfolgreich! Willkommen, " . htmlspecialchars($user["name"]);
    } else {
        echo "Ungültige E-Mail-Adresse oder falsches Passwort.";
    }
} else {
    echo "Bitte füllen Sie alle Felder aus.";
}
?>