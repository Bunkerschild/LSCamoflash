var motorized = false;
var loggedin = false;
var sessionid = null;
var streamurl = null;
var hostname = null;
var fqdn = null;

function initHlsPlayer() {
    if (Hls.isSupported()) {
        const hls = new Hls();
        hls.loadSource(streamUrl);
        hls.attachMedia(video);
        hls.on(Hls.Events.MANIFEST_PARSED, function() {
            $("#hls-player").show();
            document.getElementById('hls-player').play();
        });
    }
}

function setCookie(name, value, days) {
    let expires = "";
    if (days) {
        let date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + encodeURIComponent(value) + expires + "; path=/";
}

function getCookie(name) {
    let match = document.cookie.match(new RegExp('(^| )' + name + '=([^;]+)'));
    return match ? decodeURIComponent(match[2]) : null;
}

function deleteCookie(name) {
    document.cookie = name + "=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
}

function updateSession(sessionId) {
    $.ajax({
        url: "/cgi-bin/session.cgi",
        type: "GET",
        data: {
            operation: "update-session"
        },
        dataType: "json"
    });
}

function cleanupSessions() {
    $.ajax({
        url: "/cgi-bin/session.cgi",
        type: "GET",
        data: {
            operation: "cleanup-sessions"
        },
        dataType: "json"
    });
}

function getSession(sessionId, callback) {
    $.ajax({
        url: "/cgi-bin/session.cgi",
        type: "GET",
        data: {
            operation: "get-session"
        },
        dataType: "json",
        success: function(response) {
            if (response.status === "success") {
                callback(null, response.data);
            } else {
                callback(response.message, null);
            }
        },
        error: function(xhr, status, error) {
            callback("AJAX error: " + status, null);
        }
    });
}

function doLogin(username, password, callback) {
    $.ajax({
        url: "/cgi-bin/session.cgi",
        type: "GET",
        data: {
            operation: "login",
            username: username,
            password: password
        },
        dataType: "json",
        success: function(response) {
            if (response.status === "success") {
                callback(null, response.data);
            } else {
                callback(response.message, null);
            }
        },
        error: function(xhr, status, error) {
            callback("AJAX error: " + status, null);
        }
    });
}

function doLogout(sessionId, callback) {
    $.ajax({
        url: "/cgi-bin/session.cgi",
        type: "GET", 
        data: {
            operation: "logout",
            sessionid: sessionId
        },
        dataType: "json",
        success: function(response) {
            if (response.status === "success") {
                callback(null, response.data);
            } else {
                callback(response.message, null);
            }
        },
        error: function(xhr, status, error) {
            callback("AJAX error: " + status, null);
        }
    });
}

function getHostname() {
    $.ajax({
        url: "/cgi-bin/hostname.cgi",
        type: "GET", 
        dataType: "json",
        success: function(response) {
            hostname = response.hostname;
            fqdn = response.fqdn;
        }
    });
}

function fetchStreamURL() {
    $.ajax({
        url: "/cgi-bin/streamurl.cgi",
        type: "GET", 
        dataType: "json",
        data: {
            type: "hls",
            source: "remote"
        },
        success: function(response) {
            streamurl = response.url;
            initHlsPlayer();
        }
    });
}

function checkMotor() {
    $.ajax({
        url: "/cgi-bin/motor.cgi",
        type: "GET", 
        dataType: "text",
        success: function(response) {
            if (response == "yes") {
                motorized = true;
            }
        }
    });
}

function doReboot() {
    $.ajax({
        url: "/cgi-bin/reboot.cgi",
        type: "GET"
    });
}

function sessionDestroy(error, success) {
    if (error === null) {
        loggedin = false;
        sessionid = null;
        deleteCookie("sessionid");
        $("#navbarLogout").addClass("d-none");
        $("#containerCam").addClass("d-none");
        $("#navbarLogin").removeClass("d-none");
        $("#containerLogin").removeClass("d-none");
    }
}

function sessionCallback(error, sessionId) {
    if (error !== null) {
        loggedin = false;
        sessionid = null;
        deleteCookie("sessionid");
        $("#containerWait").addClass("d-none");
        $("#navbarLogin").removeClass("d-none");
        $("#containerLogin").removeClass("d-none");
    } else {
        sessionid = sessionId;
        setCookie("sessionid", sessionId, 1);
        loggedin = true;
        $("#containerWait").addClass("d-none");        
        $("#navbarLogout").removeClass("d-none");
        $("#containerCam").removeClass("d-none");
        updateSession(sessionId);
    }
}

function getSessionCallback(error, sessionData) {
    var sessionId = null;
    
    if ((error === null) && (sessionData !== null)) {
        sessionId = sessionData.toString().split("|")[1];
    }
    
    sessionCallback(error, sessionId);
}

$(document).ready(function() {
    getHostname();
    checkMotor();
    fetchStreamURL();
    
    cleanupSessions();
    
    sessionid = getCookie("sessionid");
    
    if (sessionid !== null) {
        getSession(sessionid, getSessionCallback);
    } else {
        $("#containerWait").addClass("d-none");
        $("#navbarLogin").removeClass("d-none");
        $("#containerLogin").removeClass("d-none");        
    }
    
    $("#loginForm").submit(function() {
        $("#navbarLogin").addClass("d-none");
        $("#containerLogin").addClass("d-none");
        $("#containerWait").removeClass("d-none");
        doLogin($("#username").val(), $("#password").val(), sessionCallback);
        return false;
    });
    
    $("#logoutLink").click(function() {
        doLogout(sessionid, sessionDestroy);
    });
});
