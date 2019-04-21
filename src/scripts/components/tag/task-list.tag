<task-list>
  <h3>合計作業時間：{total}</h3>
  <div style="padding-left: 8px;">
    <span class="open_chart" onClick={report_open}>作業時間レポートを表示</span>
  </div>
  
  <ul class="task-list_ul">
    <task-group each="{data, index in list_data}">
      <div data-group-index="{data.index_label}" class="task-box-group {data.label_class}" onClick={open.bind(this, index)}>
        <div data-group-index="{data.index_label}" class="task-box_title">
          <span data-group-index="{data.index_label}" class="task-box_task">({data.data.length}):{data.task}</span>
          <span data-group-index="{data.index_label}" class="task-box_label {data.label_text_class}">{data.label}</span>
        </div>
        <div data-group-index="{data.index_label}" class="li-inline task-box_time" title="{data.time_title}">
          {setTime(data.total)}
        </div>

        <div data-group-index="{data.index_label}" class="li-inline task-box_btn">
          <div class="start_btn" onClick={setTask.bind(this, data, index)}>
            <svg version="1.1" id="_x32_" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 512 512" style="width: 36px; height: 36px; opacity: 1;" xml:space="preserve">
            <g>
              <path class="svg" d="M256,0C114.625,0,0,114.625,0,256c0,141.374,114.625,256,256,256c141.374,0,256-114.626,256-256
                C512,114.625,397.374,0,256,0z M351.062,258.898l-144,85.945c-1.031,0.626-2.344,0.657-3.406,0.031
                c-1.031-0.594-1.687-1.702-1.687-2.937v-85.946v-85.946c0-1.218,0.656-2.343,1.687-2.938c1.062-0.609,2.375-0.578,3.406,0.031
                l144,85.962c1.031,0.586,1.641,1.718,1.641,2.89C352.703,257.187,352.094,258.297,351.062,258.898z"></path>
            </g>
            </svg>
          </div>
        </div>
      </div>

      <li each="{item, index in data.data}" class="task-list_li" show={data.isOpen}>
        <task item="{item}" index="{index}"></task>
      </li>

    </task-group>
  </ul>

  <style>
  h3 {
    padding-left: 8px;
  }

  .open_chart {
    cursor: pointer;
    display: inline-block;
    padding: 8px;
    background-color: #666;
    border-radius: 15px;
    color: #fff;
  }

  .open_chart:hover {
    background-color: gray;
  }
  
  .task-list_ul {
    list-style: none;
    padding: 0px;
  }

  .task-list_li {
    margin: 0 0 0 6px;
  }
  </style>

  <script type='es6'>
	const time = new Time()

  let flg = false
  this.open = (index) => {
    if (flg == false) {
      if (this.list_data[index].isOpen == true) {
        _.forEach(this.list_data[index].data, function(value, index) {
          value.isEdit = false
        });
      }
      let flg = !this.list_data[index].isOpen
      this.list_data[index].isOpen = !this.list_data[index].isOpen
      _.forEach(this.list_data[index].data, function(value, index) {
        value.isOpen = flg
      });
    }
    flg = false
  }
  this.list = [
  {
    label: '',
    label_class: 'task-box_yellow',
    label_text_class: 'text_yellow',
    task: 'no title',
    date: moment().format('YYYY-MM-DD'),
    time: 0,
    from: moment().format('YYYY-MM-DD') + ' 9:00',
    to: moment().format('YYYY-MM-DD') + ' 9:00',
    tags: ['aaa', 'bbb', 'ccc'],
    chart_color: color_yellow,
    isEdit: false,
    isOpen: false
  },{
    label: '',
    label_class: 'task-box_skyblue',
    label_text_class: 'text_skyblue',
    task: '休憩',
    date: moment().format('YYYY-MM-DD'),
    time: 3600,
    from: moment().format('YYYY-MM-DD') + ' 12:00',
    to: moment().format('YYYY-MM-DD') + ' 13:00',
    tags: ['aaa', 'bbb', 'ccc'],
    chart_color: color_skyblue,
    isEdit: false,
    isOpen: false
  }]

  this.set_list_data = (list) => {
    // データ整形
    let ret = []
    _.forEach(list, function(value, index) {
      let label = value.task + "-" + value.label_class + "-" + value.label
      if (ret[label] == undefined) {
        ret[label] = {
          index_label: label,
          task: value.task,
          total: 0,
          label: value.label,
          label_text_class: value.label_text_class,
          label_class: value.label_class,
          time_title: "",
          data: [],
          chart_color: value.chart_color,
          isOpen: value.isOpen,
          isEdit: value.isEdit
        }
      }
      if (value.isOpen == true) {
        ret[label].isOpen = true;
      }
      ret[label].total += value.time
      value.index = index
      ret[label].data.push(value)
      ret[label].time_title = moment(value.from, 'Y-M-D H:mm').format('H:mm A') + " - " + moment(value.to, 'Y-M-D H:mm').format('H:mm A')
    });

    let res = []
    Object.keys(ret).forEach(function (key) {
      res.push(ret[key])
    });
    return res
  }


  this.update_total = () => {
    let array = _.map(this.list, function(item) {
      return parseInt(item.time)
    });
    let total = 0
    if (array.length > 0) {
      total = array.reduce(function(prev, current) {
        return prev + current;
      });
    }

    this.total = time.setTime_hms(total)
  }

  this.report_open = () => {
    observer.trigger('saveList')
    ipcRenderer.send('report')
  }

  // リスト追加時
  const self = this
  observer.on('addTask', function (data) {
    data.index = self.list.length + 1
    self.list.unshift(data)
    self.reset()
  });

  // レポート表示時→ストレージに保存
  observer.on('saveList', function () {
    localStorage.setItem('list', JSON.stringify(self.list))
  });

  // 更新
  observer.on('updateItem', function (data, index) {
    self.list[index] = data
    self.reset()
  });

  this.update_task_box = () => {
    // updateの呼び出し後にタグテンプレートが更新された直後
    // 一括削除
    var taskBoxGrpup = document.getElementsByClassName('task-box-group');
    for (var i = 0; i < taskBoxGrpup.length; i++) {
      taskBoxGrpup[i].removeEventListener('contextmenu', open_menu_group, true);
      taskBoxGrpup[i].addEventListener('contextmenu', open_menu_group, true);
    }

    // 個別削除
    var taskBox = document.getElementsByClassName('task-box');
    for (var i = 0; i < taskBox.length; i++) {
      taskBox[i].removeEventListener('contextmenu', open_menu, true);
      taskBox[i].addEventListener('contextmenu', open_menu, true);
    }
  }

  function open_menu_group(e) {
    let index_group = e.target.attributes.getNamedItem('data-group-index').value
    menu = new Menu();
    menu.append(new MenuItem({
      label: 'このタスクを全て削除',
      click() {
        self.deleteAll(index_group)
      }
    }));
    menu.append(new MenuItem({
      type: 'separator'
    }));
    menu.append(new MenuItem({
      label: 'タスクをすべて折りたたむ',
      click() {
        self.collapseAll()
      }
    }));
    menu.append(new MenuItem({
      label: 'タスクをすべて開く',
      click() {
        self.extendAll()
      }
    }));

    menu.popup({ window: remote.getCurrentWindow() })
  }

  function open_menu(e) {
    let index = e.target.attributes.getNamedItem('data-index').value
    menu = new Menu();
    menu.append(new MenuItem({
      label: 'このタスクを削除',
      click() {
        self.deleteIndex(index)
      }
    }));

    menu.popup({ window: remote.getCurrentWindow() })
  }

  this.deleteAll = (index_label) => {
    this.list = _.remove(this.list, function(value) {
      let label = value.task + "-" + value.label_class + "-" + value.label
      return label != index_label
    });
    this.reset()
  }

  this.deleteIndex = (index) => {
    this.list.splice(index, 1);
    this.reset()
  }

  this.on('mount', function() {
    this.reset()
  })

  this.setTime = (t) => {
    return time.setTime(t)
  }

  this.setTask = (data, index) => {
    flg = true
    observer.trigger('startCount', data)
  }

  this.reset = () => {
    this.update_total()
    this.list_data = this.set_list_data(this.list)
    this.update()
    this.update_task_box()
  }

  this.collapseAll = () => {
    _.forEach(this.list_data, function(value, index) {
      value.isOpen = false
    });
    this.update()
  }

  this.extendAll = () => {
    _.forEach(this.list_data, function(value, index) {
      value.isOpen = true
    });
    this.update()
  }

  </script>
</task-list>