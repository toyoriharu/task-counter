<content>
	<div id="wrap" if={ is_show_report }></div>
	<form onsubmit="{submit}" id="task-form">
		<div id="task-form-wrap">
			<input type="text" ref="task" placeholder="タスク内容" id="task-form-input">
			<div id="task-form-count">
				{now}
			</div>
			<div if={ is_start } class="ctl-btn">
				<button type="button" class="form-btn form-btn-red" onClick="{stop}">Stop</button>
			</div>
			<div if={ !is_start } class="ctl-btn">
				<button type="button" class="form-btn btn-green" onClick="{countStart}">Start</button>
			</div>
		</div>
	</form>
	<div class="scroll">
		<task-list></task-list>
	</div>
	
	<style>
	#wrap {
		background: #fff;
		position: fixed;
		width: 100%;
		height: 100%;
		z-index: 999;
		opacity: .75
	}

	#task-form {
		background: #2a2a2a;
		box-shadow: 0 2px 2px 2px rgba(0, 0, 0, 0.15);
	}

	#task-form-wrap {
		position: relative;
		height: 45px;
		padding-left: 4px;
	}

	#task-form-input {
		color: #fff;
		outline: 0;
		border: 0px;
		background: transparent;
		width: 65%;
		min-width: 210px;
		height: 43px;
		font-size: 1.3rem;
		padding-top: 3px;
	}

	#task-form-count {
		text-align: right;
		color: #fff;
		display: block;
		width: 85px;
		position: absolute;
		right: 83px;
		top: 15px;
		font-size: 1.5em;
		vertical-align: middle;
		pointer-events: none;
	}

	.ctl-btn {
		display: block;
		width: 80px;
		height: 50px;
		position: absolute;
		right: 0;
		top: 0;
	}

	.form-btn {
		background: #eee;
		border: 1px #000 solid;
		padding: 10.5px;
		font-size: 1.5rem;
		width: 80px;
		cursor: pointer;
	}

	.form-btn-red {
		background-color: #f13a3a;
		color: #fff;
		border-color: #f13a3a;
	}

	.form-btn-red:hover {
		background-color: #ef2525;
		border-color: #ef2525;
	}

	.btn-green {
		background-color: #62ca2a;
		color: #fff;
		border-color: #62ca2a;
	}

	.btn-green:hover {
		background-color: #48b110;
		border-color: #48b110;
	}
	</style>

	<script type='es6'>
	const config = new Config()
	let json = config.get_config()

	this.is_start = false;
	this.is_show_report = false;

	this.now = '00:00:00'
	this.task_name = 'no title'
	this.task_class = 'task-box_default'
	this.chart_color = '#aaaaaa'
	this.label = ''
	this.label_text_class = 'text_default'
	this.isOpen = false

	let start_datetime = ''
	let count = 0;

	this.countStart = () => {
		this.task_class = 'task-box_default'	
		this.start()
	}

	this.start = () => {
		if (this.is_start) return;

		this.now = zeroPadding(0, 2)
		this.is_start = true;
		start_datetime = moment()
		this.update()

		if (this.refs.task.value == undefined || this.refs.task.value == '') {
			this.refs.task.value = 'no title'
		}
		const self = this;
		this.interval = setInterval(() => {
			self.time_update()
		}, 1000)
	}

	this.stop = () => {
		this.is_start = false;
		clearInterval(this.interval);

		let from = moment(start_datetime, 'YYYY-MM-DD H:mm:ss')
		let to = moment()
		let diff_time = to.diff(from, 'seconds')

		let data = {
			label: this.label,
			label_class: this.task_class,
			task: this.refs.task.value,
			time: diff_time,
			date: moment().format('YYYY-MM-DD'),
			from: start_datetime,
			to: moment(),
			chart_color: this.chart_color,
			label_text_class: this.label_text_class,
			isOpen: this.isOpen,
			isEdit: false
		}
		observer.trigger('addTask', data)

		count = 0;
		this.refs.task.value = ''
		this.now = '00:00:00'
		this.isOpen = false
		this.update()
	}

	this.time_update = () => {
		count += 1
		this.second = parseInt(count % 60)
		this.minutes = parseInt(count % 3600 / 60)
		this.hours = parseInt(count / 3600)

		this.now = ''
		if (this.hours > 0) {
			this.now += zeroPadding(this.hours, 2) + ':'
		}
		if (this.minutes > 0 || this.hours > 0) {
			this.now += zeroPadding(this.minutes, 2) + ':'
		}
		this.now += zeroPadding(this.second, 2)
		this.update()
	}

	this.submit = (e) => {
		e.preventDefault();
		this.start()
		document.activeElement.blur()
		return false;
	}
	
	// 外部との通信関連
	const self = this
	observer.on('startCount', function (data) {
		if (self.is_start) {
			self.stop()
		}
		// カウント中の他タスクがあれば先に追加
		self.refs.task.value = data.task
		self.label = data.label
		self.label_text_class = data.label_text_class
		self.task_class = data.label_class
		self.chart_color = data.chart_color
		self.isOpen = data.isOpen
		self.start()
	});

  // レポート表示時→ストレージに保存
  observer.on('saveList', function () {
    self.is_show_report = true
		self.update()
  });

	// レポート用ウィンドウ閉じた時
	ipcRenderer.on('reportClose', () => {
    self.is_show_report = false
		self.update()
	})
	</script>
</content>