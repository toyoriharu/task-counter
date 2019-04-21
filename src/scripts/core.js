'use strict';

const {
	app,
	Menu,
	Tray,
	BrowserWindow,
	ipcMain,
} = require('electron')

// let axios = require('axios')
// let querystring = require('querystring')

let path = require('path')

const Config = require(__dirname + '/util/config.js')
// let api = require(__dirname + '/src/js/api.json')

let mainWindow = null
let mainWindowPosition = []
let mainWindowSize = []


let subWindow = null
let force_quit = false

const config = new Config()
let json = config.get_config()

const iconPath = path.join(__dirname, '../../resources/icon.png')
let urlPath = path.join(__dirname, '../../index.html')

let option = {
	minWidth: 260,
	minHeight: 420,
	width: json.mainWindow.width,
	height: json.mainWindow.height,
	x: json.mainWindow ? json.mainWindow.x : '',
	y: json.mainWindow ? json.mainWindow.y : '',
	// resizable: false,
	frame: false,
	titleBarStyle: 'hidden',
	icon: iconPath,
}

let option2 = {
	parent: null,
	modal: true,
	minWidth: 640,
	minHeight: 500,
	width: json.subWindow.width,
	height: json.subWindow.height,
	x: json.subWindow ? json.subWindow.x : '',
	y: json.subWindow ? json.subWindow.y : '',
	titleBarStyle: 'hidden',
	frame: false,
	// resizable: false,
	titleBarStyle: 'hidden',
}

// 複数起動防止
let shouldQuit = app.requestSingleInstanceLock()
if (!shouldQuit) {
	app.quit()
}

let tray = null
app.on('ready', () => {
	mainWindow = new BrowserWindow(option)
	// タスクトレイ
	tray = new Tray(iconPath)
	const contextMenu = Menu.buildFromTemplate([{
		label: '終了',
		click: () => {
			force_quit = true
			app.quit()
		}
	}])
	tray.setContextMenu(contextMenu)
	tray.on('click', () => {
		if (mainWindow.isVisible()) {
			mainWindow.show()
		} else {
			mainWindow.show()
		}
	})

	mainWindow.loadURL(urlPath)

	// イベント
	mainWindow.on('close', (e) => {
		if (!force_quit) {
			e.preventDefault()
			mainWindow.hide()
		} else {
			// json = config.get_config()
			// // ウィンドウ位置を記録して終了
			// json.mainWindow = mainWindow.getBounds()
			// config.update_config(json)
		}
	})

	// mainWindow.webContents.openDevTools()
})

ipcMain.on('report', (event) => {
	// ウィンドウ情報を記録して終了
	json = config.get_config()

	urlPath = path.join(__dirname, '../../report.html')
	mainWindowPosition = mainWindow.getBounds()
	option2.x = mainWindowPosition.x
	option2.y = mainWindowPosition.y

	subWindow = new BrowserWindow(option2)
	subWindow.loadURL(urlPath)

	// subWindow.webContents.openDevTools()

	// subWindow.on('close', function (e) {
	// 	json.subWindow = subWindow.getBounds()
	// 	config.update_config(json)
	// });

	subWindow.on('closed', function (e) {
		subWindow = null;
		event.sender.send('reportClose');
	});
})