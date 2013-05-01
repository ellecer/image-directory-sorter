image-directory-sorter
======================

Ruby script that will take images and using their EXIF date info, organise them into directories sorted by date, creating or reusing dirs where they exist

Before sorting them into directories, I normally run this command first to rename the photos based on their EXIF date info.

jhead -n%Y%m%d-%H%M%S *.JPG



USAGE:

Windows:

ruby image_directory_sorter.rb --target G:/photos_upload

OSX:

ruby image_directory_sorter.rb --target photo_upload

--target is the directory containing the image files to sort.


Normally, I run this command first to rename the photos based on their EXIF date info.

jhead -n%Y%m%d-%H%M%S *.JPG


