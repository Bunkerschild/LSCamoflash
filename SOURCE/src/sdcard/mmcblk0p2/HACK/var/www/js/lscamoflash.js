var motorlock = false;
var motorized = false;
var loggedin = false;
var sessionid = null;
var streamurl = null;
var hostname = null;
var control = null;
var address = null;
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

function getSysinfo() {
    $.ajax({
        url: "/cgi-bin/sysinfo.cgi",
        type: "GET", 
        dataType: "json",
        success: function(data) {            
            let cpuUsage = data.cpu.usage_percent;
            let ramUsed = (data.memory.total_kB - data.memory.free_kB);
            let ramTotal = data.memory.total_kB;
            let ramPercent = Math.round((ramUsed / ramTotal) * 100);
            let load1Min = data.load.min1;
            let load5Min = data.load.min5;
            let load15Min = data.load.min15;
            
            $("#cpu-progress").progressbar("value", cpuUsage);
            $("#cpu-title").text("CPU: " + cpuUsage + "%");
            $("#cpu-label").text("Load: " + load1Min + ", " + load5Min + ", " + load15Min);

            $("#ram-progress").progressbar("value", ramPercent);
            $("#ram-title").text("RAM: " + ramPercent + "%");
            $("#ram-label").text("Used: " + Math.round(ramUsed / 1024) + "MB / " + Math.round(ramTotal / 1024) + "MB");
            
            setTimeout('getSysinfo()', 30000);
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

function getRemoteURL(urlType) {
    $.ajax({
        url: "/cgi-bin/streamurl.cgi",
        type: "GET", 
        dataType: "json",
        data: {
            type: urlType,
            source: "remote"
        },
        success: function(response) {
            $("#confirmDialog").html(response.url);
        }
    });
}

function checkMotor() {
    $.ajax({
        url: "/cgi-bin/motor.cgi",
        type: "GET", 
        dataType: "json",
        success: function(response) {
            if (response.has_ptz == "1") {
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
        dataType: "json", 
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
        $("#cpu-progress, #ram-progress").progressbar({ value: 0, min: 0, max: 100 });
        updateSession(sessionId);
        getSysinfo();
        getHostname();
        checkMotor();
        fetchStreamURL();
    }
}

function getSessionCallback(error, sessionData) {
    var sessionId = null;
    
    if ((error === null) && (sessionData !== null)) {
        sessionId = sessionData.toString().split("|")[1];
    }
    
    sessionCallback(error, sessionId);
}

function copyToClipboard(text) {
    if (!navigator.clipboard) {
        console.error("Clipboard API not available, using fallback.");
        fallbackCopyToClipboard(text);
        return;
    }
    
    navigator.clipboard.writeText(text).then(function() {
        console.log("Text copied to clipboard: " + text);
    }).catch(function(err) {
        console.error("Clipboard copy error:", err);
        fallbackCopyToClipboard(text);
    });
}

function fallbackCopyToClipboard(text) {
    var textArea = document.createElement("textarea");
    textArea.value = text;
    document.body.appendChild(textArea);
    textArea.select();
    document.execCommand("copy");
    document.body.removeChild(textArea);
}

$(document).ready(function() {
    cleanupSessions();

    address = window.location.hostname;
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
    
    $("#btn-rtsp-local").click(function() {
        var link = "rtsp://" + address + ":554/main_ch";
        $("#confirmDialog").dialog({
            autoOpen: false,
            modal: true,
            title: "RTSP Link",
            buttons: {
                "Copy link": function() {
                    copyToClipboard(link);
                },
                "Close": function() {
                    $(this).dialog("close");
                }
            }
        }).html(link);
        $("#confirmDialog").dialog("open");
    });

    $("#btn-onvif-local").click(function() {
        var link = "onvif://" + address + ":5000/";
        $("#confirmDialog").dialog({
            autoOpen: false,
            modal: true,
            title: "ONVIF Link",
            buttons: {
                "Copy link": function() {
                    copyToClipboard(link);
                },
                "Close": function() {
                    $(this).dialog("close");
                }
            }
        }).html(link);
        $("#confirmDialog").dialog("open");
    });

    $("#btn-rtsp-cloud").click(function() {
        $("#confirmDialog").dialog({
            autoOpen: false,
            modal: true,
            title: "RTSP Cloud Link",
            buttons: {
                "Copy link": function() {
                    copyToClipboard(link);
                },
                "Close": function() {
                    $(this).dialog("close");
                }
            }
        }).html("Generating URL...");
        $("#confirmDialog").dialog("open");
        getRemoteURL("RTSP");
    });

    $("#btn-hls-cloud").click(function() {
        $("#confirmDialog").dialog({
            autoOpen: false,
            modal: true,
            title: "HLS Cloud Link",
            buttons: {
                "Copy link": function() {
                    copyToClipboard(link);
                },
                "Close": function() {
                    $(this).dialog("close");
                }
            }
        }).html("Generating URL...");
        $("#confirmDialog").dialog("open");
        getRemoteURL("HLS");
    });

    $("#btn-flv-cloud").click(function() {
        $("#confirmDialog").dialog({
            autoOpen: false,
            modal: true,
            title: "FLV Cloud Link",
            buttons: {
                "Copy link": function() {
                    copyToClipboard(link);
                },
                "Close": function() {
                    $(this).dialog("close");
                }
            }
        }).html("Generating URL...");
        $("#confirmDialog").dialog("open");
        getRemoteURL("FLV");
    });
});
