var gulp = require('gulp');
var riot = require('gulp-riot');
var plumber = require('gulp-plumber');
var rimraf = require('rimraf');

gulp.task('clean', function (cb) {
  return rimraf('./src/scripts/components/js/*.js', cb);
});

gulp.task('riot', function () {
  return gulp.src('src/scripts/components/tag/*.tag')
    .pipe(plumber())
    .pipe(riot({
      compact: true,
      type: 'es6'
    }))
    .pipe(
      gulp.dest('src/scripts/components/js')
    )
})

gulp.task('default', gulp.series('clean', 'riot'))

gulp.task('watch', function () {
  gulp.watch(['src/scripts/components/tag/*.tag'], gulp.series('clean', 'riot'))
})