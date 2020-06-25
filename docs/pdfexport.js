function main() {
    if (window.FileList && window.File && window.FileReader) {
        document.getElementById('file-selector').addEventListener('change', async (event) => {
            var pdf = new jsPDF({
                orientation: 'l',
                unit: 'px',
                format: [1920, 1080],
                putOnlyUsedFonts: true,
                floatPrecision: 16 // or "smart", default is 16
            });
            var width = pdf.internal.pageSize.getWidth();
            var height = pdf.internal.pageSize.getHeight();

            const fileList = event.target.files;
            const l = fileList.length;
            var i = 0;
            for (file of event.target.files) {
                i += 1;
                try {
                    const img = await readImgAsync(file);
                    pdf.addImage(img, 'PNG', 0, 0, width, height)
                    if (i < l) {
                        pdf.addPage();
                    }

                } catch (e) {
                    console.warn(e.message)
                }
            }
            pdf.save('result.pdf');
        });
    }
}

function log(s) {
    console.log(s);
}

function _base64ToArrayBuffer(base64) {
    var binary_string = window.atob(base64);
    var len = binary_string.length;
    var bytes = new Uint8Array(len);
    for (var i = 0; i < len; i++) {
        bytes[i] = binary_string.charCodeAt(i);
    }
    return bytes;
}
var width = 1920;
var height = 1080;

function setWidth(w) {
    width = w;
}
function setHeight(h) {
    height = h;
}

var pdf = null;
var pageCounter = 0;
var maxPages = 0;

function setMaxPage(m) {
    maxPages = m;
}

function startPdf() {
    pdf = new jsPDF({
        orientation: 'l',
        unit: 'px',
        format: [1920 * 1920 / 1440, 1080 * 1080 / 810],
        putOnlyUsedFonts: true,
        floatPrecision: 'smart' // or "smart", default is 16
    });
    console.log('pdf', pdf.internal.pageSize.getWidth(), pdf.internal.pageSize.getHeight());
}
function debugBase64(base64URL){
    var win = window.open();
    win.document.write('<img src="' + base64URL  + '" frameborder="0" style="border:0; top:0px; left:0px; bottom:0px; right:0px; width:100%; height:100%;" allowfullscreen></img>');
}


function addPagereal(base64raw) {
    console.log('Adding page', pageCounter, 'of', maxPages);
    var rawdata = new Uint8Array(_base64ToArrayBuffer(base64raw))
    var new_canvas = document.createElement('canvas', {width: width, height: height});
    new_canvas.width = width;
    new_canvas.height = height;
    var ctx = new_canvas.getContext('2d');
    var imgdata = ctx.getImageData(0, 0, 1920, 1080);

    var i;
    for (i = 0; i < imgdata.data.length; i++) {
        imgdata.data[i] = rawdata[i];
    }
    ctx.putImageData(imgdata, 0, 0);
    var img = new_canvas.toDataURL('image/png');

    console.log('raw', base64raw);
    debugBase64(base64raw);

    pdf.addImage(img, 'PNG', 0, 0, 1920, 1080)
    if (pageCounter < maxPages - 1) {
        pdf.addPage();
    } else {
        pdf.save('result.pdf');
    }
    pageCounter += 1
}

function addPage(base64raw) {
    console.log('Adding page', pageCounter, 'of', maxPages);

    pdf.addImage(base64raw, 'PNG', 0, 0, 1920, 1080)
    console.log('added!');
    if (pageCounter < maxPages - 1) {
        pdf.addPage();
    } else {
        pdf.save('result.pdf');
    }
    pageCounter += 1
}

function toPdf(base64raw) {
    var rawdata = new Uint8Array(_base64ToArrayBuffer(base64raw))
    console.log('rawdata_size', rawdata.length);
    console.log('about to', width, height);
    var new_canvas = document.createElement('canvas');
    var ctx = new_canvas.getContext('2d');
    new_canvas.width = width;
    new_canvas.height = height;
    var imgdata = ctx.getImageData(0, 0, 1920, 1080);

    var i;
    for (i = 0; i < imgdata.data.length; i++) {
        imgdata.data[i] = rawdata[i];
    }
    ctx.putImageData(imgdata, 0, 0);
    var img = new_canvas.toDataURL('image/png');

    console.log(new_canvas.width, new_canvas.height);

    var pdf = new jsPDF({
        orientation: 'l',
        unit: 'px',
        format: [1920 * 1920 / 1440, 1080 * 1080 / 810],
        putOnlyUsedFonts: true,
        floatPrecision: 'smart' // or "smart", default is 16
    });
    console.log('pdf', pdf.internal.pageSize.getWidth(), pdf.internal.pageSize.getHeight());

    pdf.addImage(img, 'PNG', 0, 0, 1920, 1080)
    pdf.addPage();
    pdf.save('result.pdf');
    console.log('pdf', pdf.internal.pageSize.getWidth(), pdf.internal.pageSize.getHeight());
}
