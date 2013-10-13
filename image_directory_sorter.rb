require 'rubygems'
require 'exifr'
require 'ostruct'
require 'optparse'
require 'ftools'


# from http://rubyforge.org/projects/exifr

# instead of going through directory, you can generate a file listing using dir /aa /b
# gives a simple listing of files only, no directories

# get o


# Configure OptionParser for command line arguments and options
def get_commandline_options()

    cmdoptions = OpenStruct.new
    
    opts = OptionParser.new do |opts|
        opts.on("--target MANDATORY", "Directory containing images") do |target_directory|
            # TODO chk if it's a valid date before assigning
            cmdoptions.directory = target_directory
        end

        opts.on_tail("-h", "--help", "Show this usage statement") do |h|
          puts opts
        end
		
		
    end
	
	begin
		opts.parse!(ARGV)

	    #DEBUGGING ONLY
	#    if cmdoptions.directory.nil? 
	#      cmdoptions.directory = Dir.pwd
	#    end
	    
	    raise ArgumentError, "--target directory must be specified" if cmdoptions.directory.nil? 
	    
	    return cmdoptions
    
    rescue ArgumentError => e
      # this syntax lets us print 3 separate lines in one statement
      puts e, "", opts
      raise "Invalid command-line arguments: " + e.to_s
    end	
	
end


options = get_commandline_options()

target_directory = options.directory
p target_directory

Dir.chdir(target_directory)do
 
  directories_contents = Hash.new()
  
  Dir["*"].each { |file|

 #     p "this file: " + file
      
      image_file = file

      if image_file =~ /.jpg$/i

          exif_info = nil

          begin

              case image_file.downcase
              when /.jpg\Z/
                  exif_info = EXIFR::JPEG.new(image_file)
              when /.tiff?\Z/
                  exif_info = EXIFR::TIFF.new(image_file)
              end


              if not exif_info.nil? && exif_info.exif? then

                  # example: Mon Apr 02 11:28:26 +1000 2007
                  if exif_info.exif.date_time.to_s =~ /(\w+) (\w+) (\d\d) (\d\d):(\d\d):(\d\d) ([+0-9]+) (\d{4})/
                      thisdate = Time.local($8, $2, $3, $4, $5, $6)
                      # p thisdate.to_s + " converted: " + thisdate.strftime("%Y%m%d-%H%M%S")
                      this_date = thisdate.strftime("%Y%m%d")
                      if directories_contents.has_key?(this_date)
                        directories_contents[this_date].push(image_file)
                      else
                        p "Now creating directory: #{this_date}"
                        image_list = Array.new
                        image_list.push(image_file)
                        directories_contents[this_date] = image_list
                      end
                      #puts "create this directory if not exists: " + thisdate.strftime("%Y%m%d")
                  end
              else
                  puts "No EXIF information in this image"
              end

          rescue EXIFR::MalformedImage => e
            puts "MalformedImage error [" + e.to_s + "] on file (check this): " + image_file
          end


      end
  }

# move the files to their respective directories
directories_contents.each_pair{ |key,value|
    p "This directory #{key} contains this #{value.to_s}"
    # create directory
    Dir.mkdir(key) unless File.exist?(key) && File.directory?(key)
    value.each { |image_file| 
        File.move(image_file, key)    
    }  
}

  
end

# process for our script:	
# go through all files in directory
# 	for each image
#		get exif date
#			is date yyyymmdd not in lookup map?
#				add to lookup map
#			end
#			add filename to image list for this date
#   
#	for each entry in lookup  map
#		create directory for this date
#		go through list of files for this date
#			for each file
#				move this file to date directory
#