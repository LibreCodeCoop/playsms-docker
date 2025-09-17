<?php

function dbIsUp() {
    try {
        $dsn = "mysql:host={$_ENV['MYSQL_HOST']};dbname={$_ENV['MYSQL_DBNAME']}";
        @new PDO($dsn, $_ENV['MYSQL_USER'], $_ENV['MYSQL_PWD']);
    } catch(Exception $e) {
        echo "⛔ Unable to conect to 🐬 mysql server: " . $e->getMessage()."\n";
        return false;
    }
    return true;
}
while(!dbIsUp()) {
    sleep(1);
}

echo "▶️ Setup database...\n";
$dbh= new PDO("mysql:host={$_ENV['MYSQL_HOST']};dbname={$_ENV['MYSQL_DBNAME']}", $_ENV['MYSQL_USER'], $_ENV['MYSQL_PWD']);
$dbh->exec(file_get_contents($_ENV['PATHSRC'] . '/db/playsms.sql'));
$dbh->exec("SET AUTOCOMMIT = 1;UPDATE playsms_tblUser SET password='" . password_hash($_ENV['ADMINPASSWORD'], PASSWORD_BCRYPT) . "',salt='' WHERE uid=1;");
echo "Setup database finished...\n";
echo "✅ Database 🐬 mysql ready\n";
