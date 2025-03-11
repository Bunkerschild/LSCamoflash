#!/bin/sh

DB_PATH="/tmp/sd/HACK/etc/webui.db"
TIMEOUT=3600
CURRENT_TIME=$(date +%s)
LD_LIBRARY_PATH=/tmp/sd/OVERLAY/mnt/lib:/tmp/sd/OVERLAY/mnt/usr/lib:/lib:/usr/lib
PATH=/tmp/sd/OVERLAY/mnt/bin:/tmp/sd/OVERLAY/mnt/sbin:/tmp/sd/OVERLAY/mnt/usr/bin:/tmp/sd/OVERLAY/mnt/usr/sbin:/bin:/sbin:/usr/bin:/usr/sbin

if [ ! -f "$DB_PATH" ]; then
    mkdir -p "$(dirname "$DB_PATH")"
    sqlite3 "$DB_PATH" <<EOF
CREATE TABLE user (
    uid INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    timestamp_created INTEGER DEFAULT $CURRENT_TIME,
    timestamp_password_update INTEGER DEFAULT $CURRENT_TIME,
    timestamp_username_update INTEGER DEFAULT $CURRENT_TIME,
    timestamp_status_update INTEGER DEFAULT $CURRENT_TIME,
    timestamp_last_login INTEGER,
    last_ipaddress TEXT,
    is_enabled INTEGER DEFAULT 1,
    is_admin INTEGER DEFAULT 0
);

CREATE TABLE session (
    uid INTEGER NOT NULL,
    session_id TEXT PRIMARY KEY,
    timestamp_created INTEGER DEFAULT $CURRENT_TIME,
    timestamp_last_update INTEGER DEFAULT $CURRENT_TIME,
    ipaddress TEXT,
    FOREIGN KEY (uid) REFERENCES user(uid) ON DELETE CASCADE
);

INSERT INTO user (username, password, is_admin, timestamp_created, timestamp_password_update, timestamp_username_update, timestamp_status_update, timestamp_last_login) VALUES ('admin', '$(echo admin | sha256sum | awk '{print $1}')', 1, $CURRENT_TIME, $CURRENT_TIME, $CURRENT_TIME, $CURRENT_TIME, $CURRENT_TIME);
EOF
    echo "Database and admin user created."
fi

while getopts "u:U:p:i:s:o:d:" opt; do
    case "$opt" in
        u) USERNAME="$OPTARG" ;;
        U) UPDATEUSERNAME="$OPTARG" ;;
        p) PASSWORD="$OPTARG" ;;
        i) IPADDRESS="$OPTARG" ;;
        s) SESSIONID="$OPTARG" ;;
        o) OPERATION="$OPTARG" ;;
        d) UID="$OPTARG" ;;
        *) echo "Unknown parameter: -$opt"; exit 1 ;;
    esac
done

case "$OPERATION" in
    login)
        if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ] || [ -z "$IPADDRESS" ]; then
            echo "Missing parameter for login"; exit 1
        fi
        HASHED_PW=$(echo "$PASSWORD" | sha256sum | awk '{print $1}')
        USER=$(sqlite3 "$DB_PATH" "SELECT uid FROM user WHERE username='$USERNAME' AND password='$HASHED_PW' AND is_enabled=1;")
        if [ -n "$USER" ]; then
            SESSIONID=$(echo "$RANDOM$USERNAME$CURRENT_TIME" | sha256sum | awk '{print $1}')
            sqlite3 "$DB_PATH" "INSERT INTO session (uid, session_id, ipaddress, timestamp_created, timestamp_last_update) VALUES ($USER, '$SESSIONID', '$IPADDRESS', $CURRENT_TIME, $CURRENT_TIME);"
            sqlite3 "$DB_PATH" "UPDATE user SET timestamp_last_login=$CURRENT_TIME, last_ipaddress='$IPADDRESS' WHERE uid=$USER;"
            echo "Session started: $SESSIONID"
        else
            echo "Login failed"
            exit 1
        fi
        ;;
    
    logout)
        if [ -z "$SESSIONID" ]; then
            echo "Missing Session-ID for logout"; exit 1
        fi
        sqlite3 "$DB_PATH" "DELETE FROM session WHERE session_id='$SESSIONID';"
        echo "Session deleted"
        ;;
    
    update-password)
        if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
            echo "Missing Parameter for update-password"; exit 1
        fi
        HASHED_PW=$(echo "$PASSWORD" | sha256sum | awk '{print $1}')
        sqlite3 "$DB_PATH" "UPDATE user SET password='$HASHED_PW', timestamp_password_update=$CURRENT_TIME WHERE username='$USERNAME';"
        echo "Password updated"
        ;;
    
    update-username)
        if [ -z "$USERNAME" ] || [ -z "$UPDATEUSERNAME" ]; then
            echo "Missing parameter for update-username"; exit 1
        fi
        sqlite3 "$DB_PATH" "UPDATE user SET username='$UPDATEUSERNAME', timestamp_username_update=$CURRENT_TIME WHERE username='$USERNAME';"
        echo "Username updated"
        ;;
    
    update-session)
        if [ -z "$SESSIONID" ] || [ -z "$IPADDRESS" ]; then
            echo "Missing parameter for update-session"; exit 1
        fi
        LAST_UPDATE=$(sqlite3 "$DB_PATH" "SELECT timestamp_last_update FROM session WHERE session_id='$SESSIONID';")
        if [ -n "$LAST_UPDATE" ] && [ "$((CURRENT_TIME - LAST_UPDATE))" -gt "$TIMEOUT" ]; then
            sqlite3 "$DB_PATH" "DELETE FROM session WHERE session_id='$SESSIONID';"
            echo "Session expired and deleted"
        else
            UID=$(sqlite3 "$DB_PATH" "SELECT uid FROM session WHERE session_id='$SESSIONID';")
            IS_ENABLED=$(sqlite3 "$DB_PATH" "SELECT is_enabled FROM user WHERE uid=$UID;")
            if [ "$IS_ENABLED" -eq 0 ]; then
                sqlite3 "$DB_PATH" "DELETE FROM session WHERE session_id='$SESSIONID';"
                echo "Session deleted, user disabled"
            else
                sqlite3 "$DB_PATH" "UPDATE session SET timestamp_last_update=$CURRENT_TIME, ipaddress='$IPADDRESS' WHERE session_id='$SESSIONID';"
                sqlite3 "$DB_PATH" "UPDATE user SET last_ipaddress='$IPADDRESS' WHERE uid=$UID;"
                echo "Session updated"
            fi
        fi
        ;;
    
    get-session)
        if [ -z "$SESSIONID" ]; then
            echo "Missing Session-ID for get-session"; exit 1
        fi
        sqlite3 "$DB_PATH" "SELECT * FROM session WHERE session_id='$SESSIONID';"
        ;;
    
    cleanup-sessions)
        sqlite3 "$DB_PATH" "DELETE FROM session WHERE timestamp_last_update < ($CURRENT_TIME - $TIMEOUT);"
        echo "Old sessions cleaned up"
        ;;
    
    disable-user)
        if [ -z "$USERNAME" ]; then
            echo "Missing username for disable-user"; exit 1
        fi
        sqlite3 "$DB_PATH" "UPDATE user SET is_enabled=0, timestamp_status_update=$CURRENT_TIME WHERE username='$USERNAME';"
        echo "User disabled"
        ;;
    
    enable-user)
        if [ -z "$USERNAME" ]; then
            echo "Missing username for enable-user"; exit 1
        fi
        sqlite3 "$DB_PATH" "UPDATE user SET is_enabled=1, timestamp_status_update=$CURRENT_TIME WHERE username='$USERNAME';"
        echo "User enabled"
        ;;
    
    get-user)
        if [ -z "$USERNAME" ]; then
            echo "Missing username for get-user"; exit 1
        fi
        sqlite3 "$DB_PATH" "SELECT * FROM user WHERE username='$USERNAME';"
        ;;
    
    get-username)
        if [ -z "$UID" ]; then
            echo "Missing uid for get-username"; exit 1
        fi
        sqlite3 "$DB_PATH" "SELECT username FROM user WHERE uid='$UID';"
        ;;
    
    *)
        echo "Invalid operation: $OPERATION"
        exit 1
        ;;
esac
