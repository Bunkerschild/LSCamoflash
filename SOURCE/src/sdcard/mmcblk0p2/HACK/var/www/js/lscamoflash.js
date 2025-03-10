var motorlock = false;
var motorized = false;
var loggedin = false;
var sessionid = null;
var streamurl = null;
var hostname = null;
var control = null;
var fqdn = null;
var dist = 15;

function initHlsPlayer() {
    if (Hls.isSupported()) {
        const hls = new Hls();
        const video = document.getElementById('hls-player');
        hls.loadSource(streamurl);
        hls.attachMedia(video);
        hls.on(Hls.Events.MANIFEST_PARSED, function() {
            $("#connecting").fadeOut();
            $("#hostname").html(hostname);
            $("#video-container").removeClass("d-none");
            $("#ptz-container").removeClass("d-none");
            $("#hls-player").show();
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
            if (response.trim() == "yes") {
                motorized = true;
                $("#motor-container").removeClass("d-none");
            }
        }
    });
}

function setMotor(Dir, Dist) {
    if (!motorized)
        return false;
        
    if (motorlock)
        return false;
        
    motorlock = true;
    $(".ptz-button").addClass("disabled");
        
    $.ajax({
        url: "/cgi-bin/motor.cgi",
        type: "GET",
        dataType: "text", 
        data: {
            dist: Dist,
            dir: Dir
        },
        success: function(response) {
            motorlock = false;
            $(".ptz-button").removeClass("disabled");
        },
        error: function(xhr, status, error) {
            motorlock = false;
            $(".ptz-button").removeClass("disabled");
        }
    });
}

function doReboot() {
    $.ajax({
        url: "/cgi-bin/reboot.cgi",
        type: "GET"
    });
}

function doRestart() {
    $.ajax({
        url: "/cgi-bin/restart.cgi",
        type: "GET"
    });
}

function sessionDestroy(error, success) {
    if (error === null) {
        loggedin = false;
        sessionid = null;
        deleteCookie("sessionid");
        $("#containerCam").addClass("d-none");
        $("#navbarLogout").addClass("d-none");
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
    
    $(".ptz-button").click(function() {
        var dir = $(this).attr("id").substr(4);        
        setMotor(dir, dist);        
    });
    
    $("#ptz-dist").on("input", function() {
        dist = $(this).val();
        $("#ptz-dist-value").html(dist);
    });
    
    $("#btn-reboot-now").click(function() {
        $("#confirmDialog").dialog({
            autoOpen: false,
            modal: true,
            title: "Reboot device",
            buttons: {
                "Yes, reboot": function() {
                    $(this).dialog("close");
                    doReboot();
                },
                "No": function() {
                    $(this).dialog("close");
                }
            }
        }).html("Are you sure you want to reboot the device?");
        $("#confirmDialog").dialog("open");
    });
    
    $("#btn-restart-ipc").click(function() {
        $("#confirmDialog").dialog({
            autoOpen: false,
            modal: true,
            title: "Restart IPC",
            buttons: {
                "Yes, restart": function() {
                    $(this).dialog("close");
                    doRestart();
                },
                "No": function() {
                    $(this).dialog("close");
                }
            }
        }).html("Are you sure you want to restart IPC?");
        $("#confirmDialog").dialog("open");
    });
});
