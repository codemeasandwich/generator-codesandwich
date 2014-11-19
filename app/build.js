/**
 * Created with JetBrains WebStorm.
 * User: Brian
 * Date: 08/07/14
 * Time: 12:51
 * GitHub: https://github.com/codemeasandwich
 */

var app = function () {

    var preDir   = 'source';
    var cssDir   = preDir+'/styles';
    var imageDir = preDir+'/images';
    var jsDir    = preDir+'/scripts';
 // var jsVendorDir = jsDir+'/vendor';

    this.mkdir(cssDir);
    this.copy(cssDir+'/foundation.css');
    this.copy(cssDir+'/boilerplate.css');
    this.copy(cssDir+'/normalize.css');

    if(this.iconsMoon || this.iconsAwesome){

        var fontExt = ["eot","svg","ttf","woff"];
        var fontDir  = preDir+'/fonts';
        this.mkdir(fontDir);
    }

    if(this.iconsMoon){
        for(index in fontExt){
            this.copy(fontDir+'/icomoon.'+fontExt[index]);
        }
        this.copy(cssDir+'/icomoon.css');
    }
    /*
    if(this.iconsAwesome){
        for(index in fontExt){
            this.copy(fontDir+'/fontawesome.'+fontExt[index]);
        }
        this.copy(cssDir+'/fontawesome.css');
    }
    */
    if(this.addTouchIcons){
    
        // add this to make it a real Web App
        this.template(preDir+'/manifest.webapp'); 
        
        this.mkdir(imageDir);
        this.mkdir(imageDir+'/touch');

        var touchIconFiles = [
            "",
            "60x60",
            "128x128",
            "196x196",
            "precomposed",
            "57x57-precomposed",
            "72x72-precomposed",
            "114x114-precomposed",
            "144x144-precomposed"
        ];

        for(var index in touchIconFiles){
            this.copy(imageDir+'/touch/touch-icon-'+touchIconFiles[index]+'.png');
        }

        this.mkdir(imageDir+'/startup');

        // ====================================== Splash Screen Files

        var orientation = [ "landscape", "portrait" ];
        var rex = [ "", "-retina" ];

        for(var index in rex){
            this.copy(imageDir+'/startup/startup'+rex[index]+'.png');
        }

        for(var index in orientation){ //landscape, portrait
            for(var key in rex){ //retina or not
                this.copy(imageDir+'/startup/startup-tablet-'+orientation[index]+rex[key]+'.png');
            }
        }
    }

    // ==================================== JavaScript

    this.mkdir(jsDir);
    this.copy(jsDir+"/helper.coffee");
    this.copy(jsDir+"/plugins.coffee");

    // ==================================== Source

    this.template(preDir+'/index.html');
    this.template(preDir+'/404.html');
    this.copy(preDir+'/robots.txt');
    this.copy(preDir+'/favicon.ico');
    this.copy(preDir+'/.htaccess');
    if(this.crossDomainXML){
        this.copy(preDir+'/crossdomain.xml');
    }
}

exports.genApp = app;