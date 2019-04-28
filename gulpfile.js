var gulp = require('gulp');
var open = require('gulp-open');
var browserSync = require('browser-sync').create();


// Default open browser : testing
gulp.task('open', function(){
  gulp.src('./index.html')
  .pipe(open());
});


// Opens browser app
/*
gulp.task('url', function(){
  var options = {
    url: "http://localhost:3000",
    app: "google-chrome"
  };
  gulp.src('Website/index.html')
  .pipe(open("", options));
});
*/


// Static server
gulp.task('browser-sync', function() {
    browserSync.init({
        server: {
            baseDir: "./"
        },
        proxy: "http://localhost:8080"
    });
});
