image-directory-sorter
======================

Ruby script that will take images and using their EXIF date info, organise them into directories sorted by date, creating or reusing dirs where they exist

Before sorting them into directories, I normally use jhead first to rename the photos based on their EXIF date info.

```
jhead -n%Y%m%d-%H%M%S *.JPG
```

You can get jhead at: http://www.sentex.net/~mwandel/jhead/ or install it using homebrew. 

While you don't need to rename the image files, it ensures that their filenames never clash, no matter what combination of photos you happen to put in the same directory. It also makes them easy to order by date.

You will need to take into account timezone changes for the days where you travel to other countries.

*USAGE:*

Windows:
```
ruby image_directory_sorter.rb --target G:/photos_upload
```

OSX:
```
ruby image_directory_sorter.rb --target photo_upload
```
--target is the directory containing the image files to sort. Specify the full path if the directory is not in your current location. (eg, /Users/myusername/Pictures/photo_upload)




