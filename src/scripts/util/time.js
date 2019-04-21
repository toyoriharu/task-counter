module.exports = function Time() {
	this.setTime_hms = function (time) {
    let count_m = parseInt(time % 3600 / 60)
    let count_h = parseInt(time / 3600)

    return zeroPadding(count_h, 2) + '時間' + zeroPadding(count_m, 2) + '分'
	}

	this.setTime = function (time) {
		let count_s = time % 60
		let count_m = parseInt(time % 3600 / 60)
		let count_h = parseInt(time / 3600)

		return count_h + ':' + this.zeroPadding(count_m, 2) + ':' + this.zeroPadding(count_s, 2)
	}

	this.setTime_chart = function (time) {
		let seconds = parseInt(time % 60)
		if (seconds > 0) {
			time += 60
		}
		let minutes = parseInt(time % 3600 / 60)
		let hours = parseInt(time / 3600)
		return zeroPadding(hours, 2) + '時間' + zeroPadding(minutes, 2) + '分'
	}

	this.zeroPadding = function (num, length) {
		return ('00' + num).slice(-length)
	}
}