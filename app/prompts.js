'use strict';
/**
 * Created with JetBrains WebStorm.
 * User: Brian
 * Date: 08/07/14
 * Time: 11:11
 */

var chalk  = require('chalk');

var askFor = function () {
    var done = this.async();

    // Greet the user.
    var sandwichAscii =
            "                                \n"+
            "                      ,---      \n"+
            "          .----------'    '-.   \n"+
            "         /  .      '     .   \\ \n"+
            "        /        '    .      /| \n"+
            "       /      .             \ / \n"+
            "      /  ' .       .     .  || |\n"+
            "     /.___________    '    / // \n"+
            "     |._          '------'| /|  \n"+
            "     '.............______.-' /  \n"+
            "     |-.                  | /   \n"+
            '     `"""""""""""""-.....-      \n';

    this.log( chalk.cyan( sandwichAscii ));
    this.log( chalk.yellow.bold( " Lets make ourselves a CodeSandwich! \n" ));

    //backend:
    //express or sails

    //Frount end:
    //bootstrap or foundation
    //Anguler or ember or backbone
    //CSS or SASS

    //https://github.com/SBoudrias/Inquirer.js/tree/master/examples
    var prompts = [{
        type: "input",
        name: 'appName',
        message: "What would you like to name this application ",
        validate: function( value ) {
            if(0 < value.trim().length){
                return true;
            }
            return "Come on! Any name!";
        }
    },{
        type: 'checkbox',
        name: 'addIcons',
        message: "How about some Font Icons ",
        choices: [
            {
                name: "Font-Awesome",
                value: "awesome",
                checked: true
            },
            {
                name: "IcoMoon",
                value: "moon",
                checked: true
            }]
    },{
        type: "confirm",
        name: "addTouchIcons",
        message: "How about the mobile-web-app stuff ",
        default: true
    },{
        type: "input",
        name: 'gAnalyticsID',
        message: "Google Analytics(or skip) ",
        validate: function( value ) {
            if(0 == value.trim().length){
                return true;
            }else if(0 !== value.search("UA-")){
                return "The site's ID needs to start with 'UA-...'";
            }else if(10 !== value.length){
                return "Try again! *hint, it should look something like this 'UA-XXXXX-X'";
            }
            return true;//I dont like returning true at the end by can't think of anything better :p
        }
    },{
        type: "confirm",
        name: "crossDomainXML",
        message: "Allow clients from other domains access to resources",
        default: false
    }];

    this.prompt(prompts, function (props) {
        // `props` is an object passed in containing the response values, named in
        // accordance with the `name` property from your prompt object. So, for us:
        this.appName  = props.appName;
        this.addTouchIcons = props.addTouchIcons;
        this.gAnalyticsID  = ""+props.gAnalyticsID;  // NEEDED for Mocha test =  TypeError: Cannot call method 'trim' of undefined
        this.crossDomainXML = props.crossDomainXML;

        //this.log(props.blockCrossDomain);
        //this.log(this.allowCrossDomain);

        if(0 == this.gAnalyticsID.trim().length){
            this.gAnalyticsID = "UA-XXXXX-X";
        }

        var icons = ""+JSON.stringify(props.addIcons);  // NEEDED for Mocha test
        this.iconsMoon = icons.indexOf("moon") > -1;
        this.iconsAwesome = icons.indexOf("awesome") > -1;

        done();
    }.bind(this));
};

exports.genPrompt = askFor;