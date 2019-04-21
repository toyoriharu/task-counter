<report-chart>
  <h3>今日の合計作業時間：{total_time}</h3>
  <div class="inline">
    <table id="repor-table">
      <thead id="repor-table-thead">
        <tr>
          <th class="report-table-th">タスク名</th>
          <th class="report-table-th">時間</th>
        <tr>
      </thead>
      <tbody>
        <tr each="{item in array}">
          <td class="report-table-td">{item.task}</td>
          <td class="report-table-td">{set_time(item.time)}</td>
        </tr>
      </tbody>
    </table>
  </div>
  <canvas id="chartjs-4" class="chartjs inline" width="471" height="336"></canvas>

  <style>
  .inline {
    vertical-align: top;
    display: inline-block !important;
  }

  #repor-table {
    background-color: #fff;
    padding: 3px;
    margin: 3px;
    border-collapse: collapse;
  }

  #repor-table-thead {
    border-bottom: 2px #aaa solid;
  }

  .report-table-th {
    padding: 3px;
  }

  .report-table-td {
    padding: 3px;

  }

  .chartjs {
    display: block;
    width: 471px !important;
    height: 336px !important;
  }

  </style>
  <script type='es6'>
  const time = new Time()
  let log = JSON.parse(localStorage.getItem('list'))

  // データ抽出
  let data = _.map(log, function (value, index) {
    let label = value.task
    if (value.label != '') {
      label = value.label + '-' + value.task
    }
    return {
      index: index,
      task: label,
      time: parseInt(value.time),
      chart_color: value.chart_color
    };
  });

  //合計値
  let total = [];
  data.forEach(function (item) {
    if (!total[item.task]) {
      total[item.task] = {
        task: item.task,
        time: item.time,
        chart_color: item.chart_color
      };
    } else {
      total[item.task].time = total[item.task].time + parseInt(item.time);
    }
  });

  // 並び替え
  this.array = _.values(total);
  this.array = _.orderBy(this.array, ['time'], ['desc']);

  // ラベル抽出
  let label = _.map(this.array, function (value) {
    return value.task;
  });

  // 背景色集出
  let bgColor = _.map(this.array, function (value) {
    return value.chart_color;
  });

  data = _.map(this.array, function (value) {
    return value.time;
  });

  this.set_time = (t) => {
    return time.setTime_chart(t)
  }
  this.total_time = time.setTime_chart(_.sum(data));

  this.on('mount', function() {
    new Chart(document.getElementById('chartjs-4'), {
      type: 'doughnut',
      data: {
        labels: label,
        datasets: [{
          data: data,
          backgroundColor: bgColor
        }]
      },
      options: {
        responsive: false,
        maintainAspectRatio: false,
        tooltips: {
          callbacks: {
            label: function (tooltipItem, data) {
              let time = data.datasets[0].data[tooltipItem.index]
              let seconds = parseInt(time % 60)
              if (seconds > 0) {
                time += 60
              }
              let minutes = parseInt(time % 3600 / 60)
              let hours = parseInt(time / 3600)
              return (
                data.labels[tooltipItem.index] + ': ' + zeroPadding(hours, 2) + '時間' + zeroPadding(minutes, 2) + '分'
              );
            }
          }
        }
      }
    });
  })

  </script>
</report-chart>