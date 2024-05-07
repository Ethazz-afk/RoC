# Multi-threading blabla

def get_os_type
  case RUBY_PLATFORM
  when /linux/i
    'Linux'
  when /darwin/i
    'Mac OS'
  when /mswin|msys|mingw|cygwin|bccwin|wince|emc/i
    'Windows'
  else
    'Unknown'
  end
end

NB_CORES = Etc.nprocessors
NB_THREADS = NB_CORES * 2
OS_TYPE = get_os_type

#Functions to get all directories and files in a directory
def list_folders(directory)
  Dir.chdir(directory) do
    Dir.glob('*').select { |file| File.directory?(file) }
  end
end

def list_files(directory)
  Dir.chdir(directory) do
    Dir.glob('*').select { |file| File.file?(file) }
  end
end

