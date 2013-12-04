/**
 * Timeframe
 * @author: Marcy Sutton
 * Version 2.0
 * 12/5/13
 **/

var MS = {}

var ie = (navigator.userAgent.indexOf('MSIE')>=0) ? true : false;

if(typeof Date.prototype.getHours12 == 'undefined') {
	Date.prototype.getHours12 = function() {
		var hours = this.getHours();
		return (hours > 12 ? hours - 12 : hours);
	}
}

MS.Timeframe = function(target){

	$('body').removeClass('no-js');

	// element references
	this.elContainer = target;
	this.elCurrentInfo = $('#current-info span');
	this.elSiteCred = $('#site-cred');
	this.elSiteCredInfo = this.elSiteCred.find('.info');
	this.elCityPicker = $('#city-picker');
	this.elCitySubmit = $('#submit');
	this.loader = $('#loader');
	this.cityLoading = $('.city-loading');
	this.elList = $(this.elContainer).find('ul');
	this.elListItems = this.elList.children('li');
	this.targetParent;
	this.listItems;
	this.currentListItem;

	// variables
	this.interval;

	// WANT: include place_id instead of tag
	this.cities =  [
				'seattle','portland','san francisco','honolulu','mexico city',
				'chicago','new york','london','stockholm','paris',
				'moscow','shanghai','tokyo','sydney','wellington'
				];
	this.numCities = this.cities.length;
	this.apiKey = 'beb8b17f735b6a404dbe120fd7300460';
	this.numImages = [12, 60, 60];
	this.totalImages = 132;

	this.initTopMargin = 230;

	// initial setup
	this.setup();

	var self = this;

	// city picker
	this.elCityPicker.submit(function(e){
		e.preventDefault();

		self.city = $(this).find('input:radio:checked').val();

		self.initialize();
	})
};

MS.Timeframe.prototype = {

	setup: function(){

		// output city list
		for(var i=0; i<this.numCities; i++){
			var city_id = this.cities[i].replace(' ','-');
			var tag_value = this.cities[i].replace(' ','+');

			var label = $('<label />').attr('for', city_id).text(this.cities[i]);
			var input = $('<input />').attr({type:"radio", name:"city", id:city_id, value:tag_value});
			$('fieldset').append( input, label);
		}

		if(ie){
			alert('Sorry! You need a better browser to view this experience. Try Chrome, Safari or Firefox.');
		}
	},
	initialize: function() {
		var self = this;

		$('body').addClass('initialized').find('h1 a').attr('title','change city');

		// start this clock bidness
		$(this.elListItems).each(function(i){
			$(this).append('<h3 /><ul />');
		});

		this.hoursList = this.elListItems.eq(0).find('ul');
		this.hoursLabel = this.elListItems.eq(0).find('h3');
		this.minutesList = this.elListItems.eq(1).find('ul');
		this.minutesLabel = this.elListItems.eq(1).find('h3');
		this.secondsList = this.elListItems.eq(2).find('ul');
		this.secondsLabel = this.elListItems.eq(2).find('h3');

		this.cityName = this.city.replace('+',' ');
		this.cityLoading.text(self.cityName);

		// hide stuff
		this.elCityPicker.fadeOut().remove();
		this.loader.fadeIn();

		this.date = new Date();
		this.timezone = this.date.toString().replace(/^.*\(|\)$/g, "").replace(/[^A-Z]/g, "");

		this.getTime();
		this.getFlickr();
	},
	getFlickr: function(){
		var self = this;

		// what time is it? it's go time!
		var tags = [
			[ 0, 4, 'night' ],
			[ 4, 12, 'morning' ],
			[ 12, 17, 'afternoon' ],
			[ 17, 20, 'evening' ],
			[ 20, 24, 'night' ]
		]
		var currentTagArr;
		var currentTag;
		var currentHour = this.date.getHours();

		for(var i = 0; i < tags.length; i++) {
			currentTagArr = tags[i];
			if(currentHour >= currentTagArr[0] && currentHour < currentTagArr[1]) {
				currentTag = currentTagArr[2];
				break;
			}
		}
		console.log('showing '+self.cityName+','+ currentTag);

		// load Flickr json data. caching would be nice.
		$.getJSON('http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key='+self.apiKey+'&tags='+self.city.replace(' ','+')+','+ currentTag+'&tag_mode=all&per_page=132&format=json&jsoncallback=?',
		function(rsp) {

			window.rsp = rsp;

			// error handling
			if(rsp.code == 100) {

				alert(rsp.message);

			} else {

				var s = '';
				var photoUrls = [];


				$.each(rsp.photos.photo, function(n, item){

					photo = rsp.photos.photo[n];

					t_url = "http://farm" + photo.farm + ".static.flickr.com/" + photo.server + "/" + photo.id + "_" + photo.secret + "_" + "z.jpg";

	      			photoUrls.push(t_url);
				});

				// load all 132 images! sheesh.
				skone.util.ImageLoader.LoadImageSet(photoUrls, function() {

					var list = self.hoursList;

					var relevantTime = self.date.getHours12();

	    			for(var i = 0; i < photoUrls.length; i++) {

						if (i > 12 && i < 72) {
							self.moveStack(list, list.children('li'), relevantTime);

							list = self.minutesList;

							relevantTime = self.date.getMinutes();

						} else if (i >= 72) {
							self.moveStack(list, list.children('li'), relevantTime);

			    			list = self.secondsList;

	    					relevantTime = self.date.getSeconds();
						}
						list.append($('<li>').addClass('flickr').append($('<div />').append($('<img />').attr('src', photoUrls[i]))));
	    			}

					// WANT: client-specific timezone string. right now it's hard-coded as PST, which will be wrong for a lot of peeps.
					self.elCurrentInfo.text('Currently viewing: '+self.cityName+' '+currentTag+', time is '+self.timezone);
					self.loader.remove();

					self.moveStack(list, list.children('li'), relevantTime);

					self.interval = window.setInterval(function(){ self.printTime(); }, 1000);


	    		});

	    	}

      	});
	},
	moveStack: function(stack, listItems, relevantTime) {

		var newTopMargin = this.initTopMargin - (relevantTime * 15);
		stack.css({'top': newTopMargin +'px'});

		if(stack.ms_timeframe_current){
			stack.ms_timeframe_current.removeClass('current');
		}
		var current = $(listItems[relevantTime]).addClass('current');

		stack.ms_timeframe_current = current;

	},
	printTime: function() {

		this.getTime();

		var isHourChange = false;
		var isMinuteChange = false;

		var seconds = this.date.getSeconds();
		var formattedSeconds = (seconds < 10 ? '0' + seconds : seconds);
		this.secondsLabel.text(formattedSeconds);
	    this.secondsListItems = this.secondsList.children('li');

		this.moveStack(this.secondsList, this.secondsListItems, seconds);

		var minutes = this.date.getMinutes();
		var formattedMinutes = (minutes < 10 ? '0' + minutes : minutes);
		this.minutesLabel.text(formattedMinutes);
		if(seconds == 0) {
	   		this.minutesListItems = this.minutesList.children('li');
			this.moveStack(this.minutesList, this.minutesListItems, minutes);
		}

		var hours = this.date.getHours12();
		var formattedHour = (hours < 10 ? ( hours == 0 ? 12 : '0' + hours ) : hours);
		this.hoursLabel.text(formattedHour);
		if(minutes == 0) {
	  	  	this.hoursListItems = this.hoursList.children('li');
			this.moveStack(this.hoursList,this.hoursListItems, hours);
		}

		$(document).attr('title','POP_CLOCK: '+ formattedHour + ':' + formattedMinutes + ':' + formattedSeconds);
	},
	getTime: function(){

		this.date.setSeconds(this.date.getSeconds() +1);

		// NEED: string representation of each Time Zone: EST, PST, etc.
		this.timezoneOffset =  this.date.getTimezoneOffset()/60


		//console.log(this.timezoneOffset);

	}
};
