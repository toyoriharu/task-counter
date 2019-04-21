const moment = require('moment')
const fs = require('fs');
var riot = require('riot')
var observer = riot.observable()
var route = require('riot-route')
const path = require('path')
const { ipcRenderer, remote } = require('electron')
const { Menu, MenuItem } = remote
var _ = require('lodash');

let menu = new Menu()

require(__dirname + '/src/scripts/components/js/content')
require(__dirname + '/src/scripts/components/js/task')
require(__dirname + '/src/scripts/components/js/task-list')
require(__dirname + '/src/scripts/components/js/title-bar')
require(__dirname + '/src/scripts/components/js/report-chart')
require(__dirname + '/src/scripts/components/js/title-bar-sub')

const Config = require(__dirname + '/src/scripts/util/config.js')
const Time = require(__dirname + '/src/scripts/util/time.js')

const color_default = '#aaaaaa'
const color_skyblue = '#06aaf5'
const color_purple = '#c56bff'
const color_green = '#04bb9b'
const color_yellow = '#f1c33f'
const color_red = '#e20505'

function zeroPadding(num, length) {
  return ('00' + num).slice(-length)
}