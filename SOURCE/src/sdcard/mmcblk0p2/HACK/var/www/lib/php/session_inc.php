<?php
if (!defined("__WEBUI__"))
    die("You may not call this script directly");
    
if (defined("__WEBUI_SESSION__"))
    die("You may not include this file twice")
    
define("__WEBUI_SESSSION__");

class WebUISession {
    private static $scriptPath = "/tmp/sd/HACK/sbin/webui_db.sh";

    private static function runCommand($operation, $args = []) {
        $command = escapeshellcmd(self::$scriptPath) . " -o " . escapeshellarg($operation);

        foreach ($args as $key => $value) {
            $command .= " " . escapeshellarg($key) . " " . escapeshellarg($value);
        }

        return trim(shell_exec($command));
    }

    // Login-Funktion
    public static function login($username, $password, $ip) {
        $output = self::runCommand("login", ["-u" => $username, "-p" => $password, "-i" => $ip]);

        if (strpos($output, "Session gestartet") !== false) {
            preg_match('/Session gestartet: (\w+)/', $output, $matches);
            return $matches[1] ?? false;
        }
        return false;
    }

    // Logout-Funktion
    public static function logout($session_id) {
        return self::runCommand("logout", ["-s" => $session_id]);
    }

    // Session prüfen
    public static function isSessionValid($session_id) {
        return !empty(self::runCommand("get-session", ["-s" => $session_id]));
    }

    // Session-Daten abrufen
    public static function getSessionData($session_id) {
        $output = self::runCommand("get-session", ["-s" => $session_id]);
        if (!empty($output)) {
            $data = explode("|", $output);
            return [
                "uid" => $data[0] ?? null,
                "session_id" => $data[1] ?? null,
                "timestamp_created" => $data[2] ?? null,
                "timestamp_last_update" => $data[3] ?? null,
                "ipaddress" => $data[4] ?? null,
            ];
        }
        return null;
    }

    // Passwort ändern
    public static function updatePassword($username, $newPassword) {
        return self::runCommand("update-password", ["-u" => $username, "-p" => $newPassword]);
    }

    // Benutzername ändern
    public static function updateUsername($username, $newUsername) {
        return self::runCommand("update-username", ["-u" => $username, "-i" => $newUsername]);
    }

    // Session aktualisieren
    public static function updateSession($session_id, $ip) {
        return self::runCommand("update-session", ["-s" => $session_id, "-i" => $ip]);
    }

    // Abgelaufene Sessions löschen
    public static function cleanupSessions() {
        return self::runCommand("cleanup-sessions");
    }

    // Benutzer deaktivieren
    public static function disableUser($username) {
        return self::runCommand("disable-user", ["-u" => $username]);
    }

    // Benutzer aktivieren
    public static function enableUser($username) {
        return self::runCommand("enable-user", ["-u" => $username]);
    }

    // Benutzerinformationen abrufen
    public static function getUser($username) {
        $output = self::runCommand("get-user", ["-u" => $username]);
        if (!empty($output)) {
            $data = explode("|", $output);
            return [
                "uid" => $data[0] ?? null,
                "username" => $data[1] ?? null,
                "password" => $data[2] ?? null,
                "timestamp_created" => $data[3] ?? null,
                "timestamp_password_update" => $data[4] ?? null,
                "timestamp_username_update" => $data[5] ?? null,
                "timestamp_status_update" => $data[6] ?? null,
                "timestamp_last_login" => $data[7] ?? null,
                "last_ipaddress" => $data[8] ?? null,
                "is_enabled" => $data[9] ?? null,
                "is_admin" => $data[10] ?? null,
            ];
        }
        return null;
    }
}
?>
