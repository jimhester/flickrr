# flickrr
This is a minimal R client for the [flickr API](https://www.flickr.com/services/api/).

Notably it does _not_ currently support uploading photos.

## Example

This is a basic example which shows you how to solve a common problem:

```R
flickr::authenticate()

flickr_GET("flickr.photo.search", text = "UseR2016")
```
