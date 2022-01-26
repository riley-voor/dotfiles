"use strict";

module.exports = {
    reporter: function (results, data, opts) {
        var len = results.length;
        var str = '';
        var prevfile;
        var error_count   = 0;
        var warning_count = 0;

        opts = opts || {};

        results.forEach(function (result) {
            var file = result.file;
            var error = result.error;

            if (prevfile && prevfile !== file) {
                str += "\n";
            }
            prevfile = file;

            str += file  + ': line ' + error.line + ', col ' +
                error.character + ', ' + error.reason;

            if (opts.verbose) {
                str += ' (' + error.code + ')';
            }

            str += "\n";

            if (error.code.charAt(0) === 'E') {
                error_count++;
            }
            else if (error.code.charAt(0) === 'W') {
                warning_count++;
            }
        });

        if (str) {
            var results_string = str
                               + "\n"
                               + 'Found: '
                               + error_count + ' error(s)'
                               + ' and '
                               + warning_count + ' warning(s)'
                               + "\n"
                               ;
                               
            process.stdout.write(results_string);
        }
    }
};
