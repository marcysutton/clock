/**
 * Image Loader
 * @author: Sam Skjonsberg
 * @license: GPL
 **/
 
 	var skone = skone || {}; 

    skone.util = {
        ImageLoader: {
            Images: [],
            LoadImageSet: function(arrImagePaths, callback) {
                if (typeof arrImagePaths == 'string') arrImagePaths = [arrImagePaths];
                var _imageCount = arrImagePaths.length;
                var _loadedImageCount = 0;
                $.each(arrImagePaths, function(index, strImagePath) {	                    
                    if (skone.util.ImageLoader.GetImage(strImagePath) == null) {
                        var objImage = new skone.util.Image(strImagePath);
                        skone.util.ImageLoader.Images.push(objImage);
                        objImage.load(
                            function() {
                                _loadedImageCount++;                                
                                if (_loadedImageCount == _imageCount && typeof callback == 'function') {
                                    callback();
                                }
                            }
                        );
                    } else {
                        _imageCount--;
                        if (_imageCount == 0 && typeof callback == 'function') callback();
                    }
                });
            },
            IsImageLoaded: function(strImagePath) {
                if (typeof strImagePath != 'string') return false;
                $image = skone.util.ImageLoader.GetImage(strImagePath);
                if ($image != null) {
                    return skone.util.ImageLoader.GetImage(strImagePath).isLoaded;
                } else {
                    return false;
                }
            },
            GetImage: function(strImagePath) {
                var _image = null;
                $.each(skone.util.ImageLoader.Images, function(index, objImage) {
                    if (objImage.strPath == strImagePath) _image = objImage;
                });
                return _image;
            }
        },
        Image: function(strPath) {
            var _this = this;
            this.strPath = (strPath ? strPath : '');
            this.isLoaded = false;
            this.$image = $('<img>');
        }
    };

    skone.util.Image.prototype.load = function(onIsLoaded) {
        var _this = this;
        this.$image.bind('load', function() {
            _this.isLoaded = true;
            if (typeof onIsLoaded == "function") { onIsLoaded(); }
        }).attr('src', _this.strPath);
    };  
    
	/* example
	    var images = ['/images/img1.jpg', '/images/img2.jpg'];
    	skone.util.ImageLoader.LoadImageSet(images, function() {
    	
	    });
	*/