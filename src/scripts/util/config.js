let fs = require('fs')
const moment = require('moment')

module.exports = function Config() {
	// 設定ファイル読み込み
	this.get_config = function () {
		try {
			let configPath = this.getUserHome() + '/task_counter_config.json'
			return JSON.parse(fs.readFileSync(configPath, 'utf8'));
		} catch (e) {
			// ファイルが存在しない場合
			let text = {
				mainWindow: {
					x: '',
					y: '',
					width: 260,
					height: 420
				},
				subWindow: {
					x: '',
					y: '',
					width: 640,
					height: 500
				},
				task: [{
					label: 'PG1',
					label_class: '',
					label_text_class: '',
					task: 'タスク内容１',
					date: moment().format('YYYY-MM-DD'),
					time: 7200,
					from: moment().format('YYYY-MM-DD') + ' 09:00',
					to: moment().format('YYYY-MM-DD') + ' 11:00',
					tags: ['aaa', 'bbb', 'ccc'],
					chart_color: '#aaaaaa'
				}, {
					label: 'PG1',
					label_class: '',
					label_text_class: '',
					task: 'タスク内容１',
					date: moment().format('YYYY-MM-DD'),
					time: 3600,
					from: moment().format('YYYY-MM-DD') + ' 11:00',
					to: moment().format('YYYY-MM-DD') + ' 12:00',
					tags: ['aaa', 'bbb', 'ccc'],
					chart_color: '#aaaaaa'
				}, {
					label: '-',
					label_class: 'task-box_skyblue',
					label_text_class: 'text_skyblue',
					task: '休憩',
					date: moment().format('YYYY-MM-DD'),
					time: 3600,
					from: moment().format('YYYY-MM-DD') + ' 12:00',
					to: moment().format('YYYY-MM-DD') + ' 13:00',
					tags: ['aaa', 'bbb', 'ccc'],
					chart_color: '#06aaf5'
				}, {
					label: 'PG2',
					label_class: 'task-box_purple',
					label_text_class: 'text_purple',
					task: 'タスク内容２',
					date: moment().format('YYYY-MM-DD'),
					time: 7200,
					from: moment().format('YYYY-MM-DD') + ' 13:00',
					to: moment().format('YYYY-MM-DD') + ' 15:00',
					tags: ['bbb'],
					chart_color: '#c56bff'
				}, {
					label: 'PG3',
					label_class: 'task-box_yellow',
					label_text_class: 'text_yellow',
					task: 'タスク内容３',
					date: moment().format('YYYY-MM-DD'),
					time: 7200,
					from: moment().format('YYYY-MM-DD') + ' 15:00',
					to: moment().format('YYYY-MM-DD') + ' 17:00',
					tags: ['ccc'],
					chart_color: '#fb8b14'
				}]
			}
			// this.update_config(text)
			return text
		}
	}

	this.update_config = function (json) {
		let w = JSON.stringify(json)
		let configPath = this.getUserHome() + '/task_counter_config.json'
		let ret = fs.writeFileSync(configPath, w)
	}

	this.getUserHome = function () {
		return process.env[(process.platform === 'win32') ? 'USERPROFILE' : 'HOME'];
	}
}