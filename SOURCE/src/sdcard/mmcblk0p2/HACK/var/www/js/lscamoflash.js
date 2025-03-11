var manufacturer = null;
var motorlock = false;
var motorized = false;
var loggedin = false;
var sessionid = null;
var streamurl = null;
var hostname = null;
var control = null;
var address = null;
var model = null;
var fqdn = null;
var dist = 15;

var settingsRead = false;
var settingsJSON = null;

function initHlsPlayer() {
    if (Hls.isSupported()) {
        const hls = new Hls();
        const video = document.getElementById('hls-player');
        hls.loadSource(streamurl);
        hls.attachMedia(video);
        hls.on(Hls.Events.MANIFEST_PARSED, function() {
            $("#connecting").fadeOut();
            $("#video-container").removeClass("d-none");
            $("#info-container").removeClass("d-none");
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

function doLogin(Username, Password, callback) {
    $.ajax({
        url: "/cgi-bin/session.cgi",
        type: "GET",
        data: {
            operation: "login",
            username: Username,
            password: Password
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
            manufacturer = response.manufacturer;
            model = response.model;
            $("#hostname").html(hostname);
            $("#camera-name").text(manufacturer + " " + model);
            $("#camera-fqdn").text(fqdn);
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
            let sdCardUsed = data.sdcard.used;
            let sdCardSize = data.sdcard.size;
            var sdCardSizeGB = data.sdcard.size_gb;            
            let sdCardUsedPercent = Math.round((sdCardUsed / sdCardSize) * 100);
            let sdPart1Used = data.sdcard.partition1.used;
            let sdPart1Size = data.sdcard.partition1.size;
            let sdPart1UsedPercent = Math.round((sdPart1Used / sdPart1Size) * 100);
            let sdPart2Used = data.sdcard.partition2.used;
            let sdPart2Size = data.sdcard.partition2.size;
            let sdPart2UsedPercent = Math.round((sdPart2Used / sdPart2Size) * 100);
            
            $("#cpu-progress").progressbar("value", cpuUsage);
            $("#cpu-percent").text(cpuUsage);
            $("#cpu-label").text("CPU: load " + load1Min + ", " + load5Min + ", " + load15Min);

            $("#ram-progress").progressbar("value", ramPercent);
            $("#ram-percent").text(ramPercent);
            $("#ram-label").text("RAM: used " + Math.round(ramUsed / 1024) + "MB / " + Math.round(ramTotal / 1024) + "MB");
            
            $("#sd-percent").text(sdCardUsedPercent);
            $("#sd-size").text(Math.ceil(sdCardSize / 1000 / 1000 / 1000) + " GB");
            $("#sd1-label").text("Part1: used " + (Math.round(sdPart1Used / 1024 / 1024 / 1024 * 10) / 10) + "GB / " + (Math.round(sdPart1Size / 1024 / 1024 / 1024 * 10) / 10) + "GB");
            $("#sd1-progress").progressbar("value", sdPart1UsedPercent);
            $("#sd2-label").text("Part2: used " + (Math.round(sdPart2Used / 1024 / 1024 / 1024 * 10) / 10) + "GB / " + (Math.round(sdPart2Size / 1024 / 1024 / 1024 * 10) / 10) + "GB");
            $("#sd2-progress").progressbar("value", sdPart2UsedPercent);
            
            setTimeout('getSysinfo()', 20000);
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

function updatePassword(newPassword1, newPassword2) {
    $("#confirmDialog").dialog({
        autoOpen: false,
        modal: true,
        title: "Update password",
        buttons: {
            "Close": function() {
                $(this).dialog("close");
            }
        }
    }).html("Please wait...");
    $("#confirmDialog").dialog("open");
    
    if (newPassword1.length < 4) {
        $("#confirmDialog").html("Password must have at least 4 characters");
        return false;
    }
    
    if (newPassword1 != newPassword2) {
        $("#confirmDialog").html("Passwords did not match");
        return false;    
    }
    
    $.ajax({
        url: "/cgi-bin/session.cgi",
        type: "GET", 
        dataType: "json",
        data: {
            operation: "update-password",
            password: newPassword1
        },
        success: function(response) {
            if (response.status == "success")
                $("#confirmDialog").html("Password updated");
            else
                $("#confirmDialog").html("Password update failed");
        },
        error: function(xhr, status, error) {
            $("#confirmDialog").html("Password update error");
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

function saveSettings() {
    if (settingsRead == false)
        return false;
    
    showSave();
    var postvals = {};
        
    Object.entries(settingsJSON.keylist).forEach(([key, elementId]) => {
        const $element = $("#" + elementId);
        var value = null;

        if ($element.length) {
            if ($element.is("select")) {
                value = $element.val();
            } else if ($element.is("input")) {
                if ($element.attr("type") === "checkbox" || $element.attr("type") === "radio") {
                    value = $element.prop("checked") ? "1" : "0";
                } else {
                    value = $element.val();
                }
            }
            settingsJSON.valuelist[elementId] = value;
            postvals[key] = value;
        }
    });
    
    $.ajax({
        url: "/cgi-bin/settings.cgi",
        type: "POST", 
        dataType: "json",
        data: postvals,
        success: function(response) {
            showSettings();
            if (response.status == "locked")
            {
                alert("Another saving process is running. Try again later.");
            }
            else if (response.status == "saved")
            {
                restartIPC();
            }
            else
            {
                alert("Settings were not saved");
            }
        },
        error: function (a, b, c) {
            showSettings();
            alert("Settings were not saved, due to error");
        }
    });
}

function getSettings() {
    $.ajax({
        url: "/cgi-bin/settings.cgi",
        type: "GET", 
        dataType: "json",
        success: function(s) {
            if (!s.ts)
                return false;
                
            settingsJSON = s;
                
            Object.entries(s.keylist).forEach(([key, elementId]) => {
                const elementValue = s.valuelist[elementId];
                const $element = $("#" + elementId);

                if ($element.length) {
                    if ($element.is("select")) {
                        $element.val(elementValue).trigger("change");
                    } else if ($element.is("input")) {
                        if ($element.attr("type") === "checkbox" || $element.attr("type") === "radio") {
                            $element.prop("checked", elementValue === "1");
                        } else {
                            $element.val(elementValue);
                        }
                    }
                }
            });

            $("#cameraSettingsAcc").accordion({ heightStyle: "content" });
            $("input:checkbox").checkboxradio();
            $("select").selectmenu();
            
            settingsRead = true;
            
            bsShow($("#settingsMenuEntry"));
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
        showLogin();
    }
}

function sessionCallback(error, sessionId) {
    hideAll();
    
    if (error !== null) {
        loggedin = false;
        sessionid = null;
        deleteCookie("sessionid");
        showLogin();
    } else {
        sessionid = sessionId;
        setCookie("sessionid", sessionId, 1);
        loggedin = true;
        showCam();
        updateSession(sessionId);
        getSysinfo();
        getHostname();
        getSettings();
        checkMotor();
        fetchStreamURL();
    }
}

function hideAll() {
    bsHide($("#containerWait"));
    bsHide($("#navbarLogin"));
    bsHide($("#navbarLogout"));
    bsHide($("#containerLogin"));
    bsHide($("#containerCam"));
    bsHide($("#containerPassword"));
    bsHide($("#containerSettings"));
}

function showLogin() {
    hideAll();
    bsShow($("#navbarLogin"));
    bsShow($("#containerLogin"));
}

function showCam() {
    hideAll();
    bsShow($("#navbarLogout"));
    bsShow($("#containerCam"));
}

function showSave() {
    hideAll();
    $("#loading-label").html("S a v i n g<br><small>This could take a while</small>");
    bsShow($("#containerWait"));
}

function showWait() {
    hideAll();
    $("#loading-label").text("L o a d i n g");
    bsShow($("#containerWait"));
}

function showSettings() {
    if (settingsRead)
    {
        hideAll();
        bsShow($("#navbarLogout"));
        bsShow($("#containerSettings"));
    }
}

function showPassword() {
    hideAll();
    bsShow($("#navbarLogout"));
    bsShow($("#containerPassword"));
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

function bsHide(element) {
    element.addClass("d-none");
}

function bsShow(element) {
    element.removeClass("d-none");
}

function navLinkClick(link) {
    if (!link.attr("href").startsWith("#"))
        return true;
        
    const navFunction = link.attr("href").split("#")[1];
    
    switch (navFunction)
    {
        case "cam":
            if (loggedin)
                showCam();
            break;
        case "login":
            if (!loggedin)
                showLogin();
            break;
        case "logout":
            if (loggedin)
            {
                showWait();
                doLogout(sessionid, sessionDestroy);
            }
            break;
        case "settings":
            if (loggedin)
                showSettings();
            break;
        case "password":
            if (loggedin)
                showPassword();
            break;
    }
    
    return false;
}

$(document).ready(function() {
    cleanupSessions();

    address = window.location.hostname;
    sessionid = getCookie("sessionid");
    
    $(".progressbar").progressbar({ value: 0, min: 0, max: 100 });
    
    if (sessionid !== null) {
        getSession(sessionid, getSessionCallback);
    } else {
        showLogin();
    }    
    
    $("#loginForm").submit(function() {
        showWait();
        doLogin($("#username").val(), $("#password").val(), sessionCallback);
        return false;
    });
    
    $("#updatePasswd").click(function() {
        if (!loggedin)
            return false;
            
        return updatePassword($("#password1").val(), $("#password2").val());
    });
    
    $(".nav-link").click(function() {
        return navLinkClick($(this));
    });
        
    $(".ptz-button").click(function() {
        var dir = $(this).attr("id").substr(4);        
        setMotor(dir, dist);        
    });
    
    $("#saveSettings").click(function() {
        saveSettings();
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
