<task>
  <div data-index="{opts.item.index}" class="task-box gray {opts.item.label_class}" onClick={edit}>
    <div data-index="{opts.item.index}" class="task-box_title">
      <span data-index="{opts.item.index}" class="task-box_task">{opts.item.task}</span>
      <span data-index="{opts.item.index}" class="task-box_label {opts.item.label_text_class}">{opts.item.label}</span>
    </div>
    <div data-index="{opts.item.index}" class="li-inline task-box_time" title="{time_title}">
      {time}
    </div>
    <div data-index="{opts.item.index}" class="li-inline task-box_btn">
      <svg version="1.1" id="_x32_" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" style="width: 28px; height: 28px; opacity: 1;" xml:space="preserve">
      <g class="svg">
        <path d="M494.56,55.774l-38.344-38.328c-23.253-23.262-60.965-23.253-84.226,0l-35.878,35.878l122.563,122.563
          l35.886-35.878C517.814,116.747,517.814,79.044,494.56,55.774z"></path>
        <polygon points="0,389.435 0,511.998 122.571,511.998 425.246,209.314 302.691,86.751"></polygon>
      </g>
      </svg>
    </div>
  </div>
  <div style="padding: 3px 3px 15px; background: #ccc;" if={opts.item.isEdit}>
    <label style="display: inline-block; width: 85px;">タスク内容</label>
    <input type="text" ref="task" value="{opts.item.task}" style="font-size: 1.2rem; width: 120px; padding: 3px;" onChange={change} placeholder="タスク内容">
    <br>
    <label style="display: inline-block; width: 85px;">ラベル</label>
    <select style="padding: 3px; height: 28px;" ref="label_class" onChange={change}>
      <option each={label} value={value} class={class} selected={label_class==opts.item.label_class}>{name}</option>
    </select>
    <br>
    <label style="display: inline-block; width: 85px;">ラベル内容</label>
    <input type="text" value="{opts.item.label}" style="font-size: 1.1rem; width: 90px; padding: 3px;" ref="label" onChange={change} placeholder="PJ名">
    <br>
    <hr>
    <label style="display: inline-block; width: 85px;">開始時間</label>
    <br>
    <select style="padding: 3px; height: 33px;" ref="time_hour_from" onChange={timeChange}>
      <option each={hours} value={value} selected={value==selectTime_from[0]}>{name}</option>
    </select>
    :
    <select style="padding: 3px; height: 33px;" ref="time_minute_from" onChange={timeChange}>
      <option each={minutes} value={value} selected={value==selectTime_from[1]}>{name}</option>
    </select>
    :
    <select style="padding: 3px; height: 33px;" ref="time_second_from" onChange={timeChange}>
      <option each={seconds} value={value} selected={value==selectTime_from[2]}>{name}</option>
    </select>

    <br><br>
    <label style="display: inline-block; width: 85px;">終了時間</label>
    <br>
    <select style="padding: 3px; height: 33px;" ref="time_hour_to" onChange={change}>
      <option each={hours} value={value} selected={value==selectTime_to[0]} disabled="{setDisabled('hour', value, selectTime_from[0])}">{name}</option>
    </select>
    :
    <select style="padding: 3px; height: 33px;" ref="time_minute_to" onChange={change}>
      <option each={minutes} value={value} selected={value==selectTime_to[1]} disabled="{setDisabled('minute', value, selectTime_from[1])}">{name}</option>
    </select>
    :
    <select style="padding: 3px; height: 33px;" ref="time_second_to" onChange={change}>
      <option each={seconds} value={value} selected={value==selectTime_to[2]} disabled="{setDisabled('second', value, selectTime_from[2])}">{name}</option>
    </select>
  </div>

  <style>
  </style>
  
  <script type='es6'>
	const time = new Time()
  let today = moment().format('Y-M-D')

  this.time_title = ""
  this.from = ""
  this.to = ""
  this.selectTime_from = []
  this.selectTime_to = []

  this.reset = () => {
    this.time_title = moment(opts.item.from, 'Y-M-D H:mm').format('H:mm A') + " - " + moment(opts.item.to, 'Y-M-D H:mm').format('H:mm A')
    this.from = moment(opts.item.from, 'Y-M-D H:mm:ss').format('H:mm:ss')
    this.to = moment(opts.item.to, 'Y-M-D H:mm:ss').format('H:mm:ss')

    this.selectTime_from = this.from.split(":")
    this.selectTime_to = this.to.split(":")
    this.update()
  }

  this.chart_color = {
    default: color_default,
    skyblue: color_skyblue,
    purple: color_purple,
    green: color_green,
    yellow: color_yellow,
    red: color_red
  }
  this.label = [
    {
      value: 'default',
      name: 'デフォルト',
      class: 'bg-default',
      label_class: 'task-box_default'
    },
    {
      value: 'skyblue',
      name: 'ラベル１',
      class: 'bg-skyblue',
      label_class: 'task-box_skyblue'
    },
    {
      value: 'purple',
      name: 'ラベル２',
      class: 'bg-purple',
      label_class: 'task-box_purple'
    },
    {
      value: 'green',
      name: 'ラベル３',
      class: 'bg-green',
      label_class: 'task-box_green'
    },
    {
      value: 'yellow',
      name: 'ラベル４',
      class: 'bg-yellow',
      label_class: 'task-box_yellow'
    },
    {
      value: 'red',
      name: 'ラベル５',
      class: 'bg-red',
      label_class: 'task-box_red'
    }
  ]

  this.hours = [
    {value: 9, name: "AM 09"},
    {value: 10, name: "AM 10"},
    {value: 11, name: "AM 11"},
    {value: 12, name: "PM 12"},
    {value: 13, name: "PM 13"},
    {value: 14, name: "PM 14"},
    {value: 15, name: "PM 15"},
    {value: 16, name: "PM 16"},
    {value: 17, name: "PM 17"},
    {value: 18, name: "PM 18"},
    {value: 19, name: "PM 19"},
    {value: 20, name: "PM 20"},
    {value: 21, name: "PM 21"},
    {value: 22, name: "PM 22"},
  ];
  this.minutes = []
  this.seconds = []

  for (let index = 0; index < 60; index++) {
    this.minutes.push({
      value : index,
      name: zeroPadding(index, 2)
    })
    this.seconds.push({
      value : index,
      name: zeroPadding(index, 2)
    })
  }

  this.setTime = (t) => {
    return time.setTime(t)
  }

  this.timeChange = () => {
    // 開始時間が更新された場合→終了時間＝開始時刻から作業時間を足した数値に変更
    let from = today + " " + this.refs.time_hour_from.value + ":" + zeroPadding(this.refs.time_minute_from.value, 2) + ":" + zeroPadding(this.refs.time_second_from.value, 2)
    let diff_from = moment(from).format('H:mm:ss')
    let diff_to = moment(from).add("seconds", opts.item.time).format('H:mm:ss')

    this.selectTime_from = diff_from.split(":")
    this.selectTime_to = diff_to.split(":")
  }

  this.change = () => {
    opts.item.task = this.refs.task.value
    opts.item.label = this.refs.label.value
    opts.item.label_class = 'task-box_' + this.refs.label_class.value
    opts.item.label_text_class = 'text_' + this.refs.label_class.value
    opts.item.chart_color = this.chart_color[this.refs.label_class.value]

    let from = today + " " + this.refs.time_hour_from.value + ":" + zeroPadding(this.refs.time_minute_from.value, 2) + ":" + zeroPadding(this.refs.time_second_from.value, 2)
    let diff_from = moment(from)

    let to = today + " " + this.refs.time_hour_to.value + ":" + zeroPadding(this.refs.time_minute_to.value, 2) + ":" + zeroPadding(this.refs.time_second_to.value, 2)
    let diff_to = moment(to)

    opts.item.from = diff_from.format('Y-M-D H:mm:ss')
    opts.item.to = diff_to.format('Y-M-D H:mm:ss')
    opts.item.time = diff_to.diff(diff_from, 'seconds')

    // 時間
    this.time = this.setTime(opts.item.time);

    // 更新状態

    observer.trigger('updateItem', opts.item, opts.item.index)
  }

  this.edit = () => {
    opts.item.isEdit = !opts.item.isEdit;
  }

  this.time = this.setTime(opts.item.time);

  this.setDisabled = (type, value1, value2) => {
    if (type != 'hour' && this.refs.time_hour_from.value != this.refs.time_hour_to.value) {
      return false;
    }
    return value2 > value1
  }

  this.on('mount', function() {
    this.reset()
  })
  </script>
</task>