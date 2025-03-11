#!/bin/sh

DB_SCRIPT="/tmp/sd/HACK/sbin/webui_db.sh" # Adjust this path
echo "Content-Type: application/json"
echo ""

# Get client IP from REMOTE_ADDR or default to 127.0.0.1
IPADDRESS="${REMOTE_ADDR:-127.0.0.1}"

# Function to output JSON
json_response() {
    echo "{\"status\":\"$1\",\"message\":\"$2\",\"data\":\"$3\"}"
}

# Function to parse GET parameters without subshell
parse_query() {
    IFS='&' 
    for keyval in $QUERY_STRING; do
        key=$(echo "$keyval" | sed 's/=/ /g' | awk '{print tolower($1)}')  # Convert key to lowercase
        value=$(echo "$keyval" | sed 's/=/ /g' | awk '{print $2}')
        value=$(printf '%b' "${value//+/ }")

        case "$key" in
            operation) OPERATION="$value" ;;
            username) USERNAME="$value" ;;
            password) PASSWORD="$value" ;;
            uid) UID="$value" ;;
        esac
    done
}

# Function to parse COOKIES without subshell
parse_cookies() {
    IFS='; ' 
    for keyval in $HTTP_COOKIE; do
        key=$(echo "$keyval" | sed 's/=/ /g' | awk '{print $1}')
        value=$(echo "$keyval" | sed 's/=/ /g' | awk '{print $2}')
        value=$(printf '%b' "${value//+/ }")

        case "$key" in
            sessionid) SESSIONID="$value" ;;
        esac
    done
}

handle_request() {
    case "$OPERATION" in
        login)
            if [ -n "$USERNAME" ] && [ -n "$PASSWORD" ]; then
                OUTPUT=$("$DB_SCRIPT" -o login -u "$USERNAME" -p "$PASSWORD" -i "$IPADDRESS" 2>/dev/null)
                if echo "$OUTPUT" | grep -q "Session started"; then
                    SESSION_ID=$(echo "$OUTPUT" | awk '{print $3}')
                    json_response "success" "Login successful" "$SESSION_ID"
                else
                    json_response "error" "Login failed" "$USERNAME"
                fi
            else
                json_response "error" "Missing parameters for login" ""
            fi
            ;;
        
        logout)
            if [ -n "$SESSIONID" ]; then
                OUTPUT=$("$DB_SCRIPT" -o logout -s "$SESSIONID" 2>/dev/null)
                json_response "success" "Session deleted" "$SESSIONID"
            else
                json_response "error" "Missing session ID for logout" ""
            fi
            ;;

        update-password)
            if [ -n "$SESSIONID" ] && [ -n "$PASSWORD" ]; then
                UID=$("$DB_SCRIPT" -o get-session -s "$SESSIONID" 2>/dev/null | cut -d "|" -f1)
                if [ -z "$UID" ]; then
                	json_response "error" "Unable to find user for session" "$SESSIONID"
                else
                	USERNAME=$("$DB_SCRIPT" -o get-username -d "$UID" 2>/dev/null)
	                OUTPUT=$("$DB_SCRIPT" -o update-password -u "$USERNAME" -p "$PASSWORD" 2>/dev/null)
        	        json_response "success" "Password updated" "$USERNAME"
                fi
            else
                json_response "error" "Password update failed" "$USERNAME"
            fi
            ;;

        update-username)
            if [ -n "$SESSIONID" ] && [ -n "$USERNAME" ]; then
                UID=$("$DB_SCRIPT" -o get-session -s "$SESSIONID" 2>/dev/null | cut -d "|" -f1)
                if [ -z "$UID" ]; then
                	json_response "error" "Unable to find user for session" "$SESSIONID"
                else
                	ORIGUSERNAME=$("$DB_SCRIPT" -o get-username -d "$UID" 2>/dev/null)
	                OUTPUT=$("$DB_SCRIPT" -o update-username -u "$ORIGUSERNAME" -U "$USERNAME" 2>/dev/null)
        	        json_response "success" "Username updated" "$USERNAME"
                fi
            else
                json_response "error" "Password update failed" "$USERNAME"
            fi
            ;;

        update-session)
            if [ -n "$SESSIONID" ]; then
                OUTPUT=$("$DB_SCRIPT" -o update-session -s "$SESSIONID" -i "$IPADDRESS" 2>/dev/null)
                json_response "success" "Session updated" "$SESSIONID"
            else
                json_response "error" "Session update failed" "$SESSIONID"
            fi
            ;;

        get-session)
            if [ -n "$SESSIONID" ]; then
                OUTPUT=$("$DB_SCRIPT" -o get-session -s "$SESSIONID" 2>/dev/null)
                if [ -n "$OUTPUT" ]; then
                    json_response "success" "Session retrieved" "$OUTPUT"
                else
                    json_response "error" "Session not found" "$SESSIONID"
                fi
            else
                json_response "error" "Missing session ID for retrieving session" ""
            fi
            ;;

        cleanup-sessions)
            OUTPUT=$("$DB_SCRIPT" -o cleanup-sessions 2>/dev/null)
            json_response "success" "Expired sessions removed" ""
            ;;

        disable-user)
            if [ -n "$USERNAME" ]; then
                OUTPUT=$("$DB_SCRIPT" -o disable-user -u "$USERNAME" 2>/dev/null)
                json_response "success" "User disabled" "$USERNAME"
            else
                json_response "error" "Missing username for disabling user" "$USERNAME"
            fi
            ;;

        enable-user)
            if [ -n "$USERNAME" ]; then
                OUTPUT=$("$DB_SCRIPT" -o enable-user -u "$USERNAME" 2>/dev/null)
                json_response "success" "User enabled" "$USERNAME"
            else
                json_response "error" "Missing username for enabling user" "$USERNAME"
            fi
            ;;

        get-user)
            if [ -n "$USERNAME" ]; then
                OUTPUT=$("$DB_SCRIPT" -o get-user -u "$USERNAME" 2>/dev/null)
                if [ -n "$OUTPUT" ]; then
                    json_response "success" "User retrieved" "$OUTPUT"
                else
                    json_response "error" "User not found" "$USERNAME"
                fi
            else
                json_response "error" "Missing username for retrieving user information" ""
            fi
            ;;

        get-username)
            if [ -n "$UID" ]; then
                OUTPUT=$("$DB_SCRIPT" -o get-username -d "$UID" 2>/dev/null)
                if [ -n "$OUTPUT" ]; then
                    json_response "success" "Username retrieved" "$OUTPUT"
                else
                    json_response "error" "Username not found" "$UID"
                fi
            else
                json_response "error" "Missing session ID for retrieving username" ""
            fi
            ;;

        *)
            json_response "error" "Invalid operation" "$OPERATION"
            exit 1
            ;;
    esac
}

# Parse GET parameters
parse_query
parse_cookies
handle_request
