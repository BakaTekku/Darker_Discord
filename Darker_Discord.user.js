// ==UserScript==
// @name         Darker_Discord
// @namespace    https://userstyles.world
// @homepage     https://userstyles.world/style/3179/darker-discord
// @icon         https://www.google.com/s2/favicons?domain=discord.com
// @version      0.1
// @description  Not too Dark not too Light Just Darker...
// @author       Breadsticc#1533
// @match        https://discord.com/*
// @grant        GM_getResourceText
// @grant        GM_addStyle
// @resource     IMPORTED_CSS https://raw.githack.com/BakaTekku/Discord_Theme/master/theme.css
// @run-at       document-start
// ==/UserScript==

(function() {
    'use strict';

    const my_css = GM_getResourceText("IMPORTED_CSS");
    GM_addStyle(my_css);
})();