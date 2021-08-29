-- Inferno Collection Weapons Version 1.3 Beta
--
-- Copyright (c) 2019-2020, Christopher M, Inferno Collection. All rights reserved.
--
-- This project is licensed under the following:
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to use, copy, modify, and merge the software, under the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. THE SOFTWARE MAY NOT BE SOLD.
--
game "gta5"

fx_version "cerulean"

name "Weapons - Inferno Collection"

description "Adds fire modes to the weapons of your choice, as well as more realistic reloads (including disabling automatic reloads), consistent flashlights (stay turned on even when weapon is not being aimed), more blood when injured, and limping after being injured."

author "Inferno Collection (inferno-collection.com) Rewrite Slayer"

version "2.1 Test"

url "https://inferno-collection.com"

lua54 "yes"

client_script {
	"@key_mapping/mapping.lua",
    "@menu/menu.lua",
    "client.lua",
    "gsr.lua",
    "investigate.lua"
}
shared_scripts {
    "@modules/utils.lua",
    "config.lua"
}

server_script "server.lua"