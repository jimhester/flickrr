[![Travis-CI Build Status](https://travis-ci.org/jimhester/flickrr.svg?branch=master)](https://travis-ci.org/jimhester/flickrr)

# flickrr
This is a minimal R client for the [flickr API](https://www.flickr.com/services/api/).

Notably it does _not_ currently support uploading photos.

## Example

This is a basic example which shows you how to solve a common problem:

```R
flickr::authenticate()

flickr_GET("flickr.photo.search", text = "UseR2016")
```

# Rflickr
Duncan Temple Lang wrote [Rflickr](http://www.omegahat.net/Rflickr/)
([GitHub](https://github.com/duncantl/Rflickr)) in 2011. Unfortunately it only
supports the legacy "frob" authentication which has been deprecated by flickr
and is no longer functional.
