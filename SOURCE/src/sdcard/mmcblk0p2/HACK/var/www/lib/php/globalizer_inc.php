<?php
if (!defined("__WEBUI__"))
    die("You may not call this script directly");
    
if (defined("__ROOT__"))
    die("Do not include globalizer twice");
    
define("__ROOT__", 			"/tmp/sd/HACK");
define("__HT_HW_SETTINGS_INI__", 	"/etc/config/_ht_hw_settings.ini");
define("__HT_SW_SETTINGS_INI__", 	"/etc/config/_ht_sw_settings.ini");
define("__HT_HW_SETTINGS_INI2__", 	__ROOT__.__HT_HW_SETTINGS_INI__);
define("__HT_SW_SETTINGS_INI2__", 	__ROOT__.__HT_SW_SETTINGS_INI__);
define("__ANYKA_CFG_INI__", 		__ROOT__."/etc/config/anyka_cfg.ini");

// Read ini file and create global vars
function globalize_ini_vars($file, $prefix)
{
    if (substr($file, -4) != ".ini")
        return false;
        
    if (!file_exists($file))
        return false;
    
    $ini = parse_ini_file($file, 1);
    
    if (!$ini)
        return false;
        
    if (!is_array($ini))
        return false;
        
    $key = "__ini_".$prefix;
    
    global $$key;
    
    $$key = $ini;
    
    return true;
}

// Globalize sh vars
globalize_sh_vars(__HACK_CONF__, "cfg");
globalize_sh_vars(__HACK_CUSTOM_CONF__, "cfg");
globalize_sh_vars(__COMMANDS_CONF__, "cmd");
globalize_sh_vars(__ANYKA_CHECKSUMS_CONF__, "chk");

// Globalize ini vars
globalize_ini_vars(__HT_HW_SETTINGS_INI__, "hw");
globalize_ini_vars(__HT_SW_SETTINGS_INI__, "sw");
globalize_ini_vars(__ANYKA_CFG_INI__, "ak");
