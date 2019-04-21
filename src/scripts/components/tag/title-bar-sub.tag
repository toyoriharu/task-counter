<title-bar-sub>
  <div id="title-bar">
    <div id="title">
      <button type="button">
        <img src="resources/title-bar.png" width="24px">
      </button>
      <span id="title-text">タスクカウントツール - 作業時間レポート</span>
    </div>
    <div id="title-bar-btns">
      <button id="close-btn" onclick="{close}">×</button>
    </div>
  </div>

  <style>
  .margin-right_3 {
    margin-right: 3px;
  }

  #title-bar {
    -webkit-app-region: drag;
    height: 30px;
    background-color: #2a93cc;
    padding: 3px;
    margin: 0px;
    color: #fff;
    vertical-align: middle;
  }

  #title {
    position: fixed;
    top: 5px;
    left: 6px;
    vertical-align: top;
  }

  #title > button {
    -webkit-app-region: no-drag;
    background-color: #fff;
    border: 0;
    width: 30px;
    height: 28px;
    padding: 3px;
    display: inline-block;
    vertical-align: middle;
    outline: 0;
  }

  #title-text {
    display: inline-block;
    vertical-align: middle;
    margin-left: 6px;
  }

  #title-bar-btns {
    -webkit-app-region: no-drag;
    position: fixed;
    top: 5px;
    right: 6px;
  }

  #title-bar-btns > button {
    background-color: #fff;
    border: 0;
    width: 28px;
    height: 28px;
    outline: 0;
  }

  #title-bar-btns > button:hover {
    background-color: #b1b1b1;
  }
  </style>

  <script type='es6'>
  this.close = () => {
    const window = remote.getCurrentWindow();
    window.close();
  }
  </script>
</title-bar-sub>