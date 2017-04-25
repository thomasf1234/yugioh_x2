require 'io/console'
require 'digest'

module YugiohX2Lib
  class UserManager
    def initialize(is=STDIN, os=STDOUT)
      @is = is
      @os = os
    end

    private
    def prompt_username(prompt="Username: ")
      username = nil
      has_username = false

      until has_username
        @os.print prompt
        username = @is.gets.chomp

        if username.length < 2
          @os.puts("Usernames must be at least 2 characters long. Retrying")
          next
        else
          has_username = true
        end
      end

      username
    end

    def prompt_password(prompt="Password: ")
      password = nil
      has_password = false

      until has_password
        password = @is.getpass(prompt)

        if password.length < 6
          @os.puts("Passwords must be at least 6 characters long. Restarting")
          next
        end

        confirm_password = @is.getpass("Confirm Password: ")

        if password == confirm_password
          has_password = true
        else
          @os.puts("Incorrect password entered. Restarting")
          next
        end
      end

      password
    end

    def encrypted_password(username, password)
      "{SHA256}#{Digest::SHA256.digest("#{username}:#{password}")}"
    end

    # def self.prompt_user_password
    #   username = nil
    #   has_username = false
    #
    #   until has_username
    #     print "Username: "
    #     username = @is.gets.chomp
    #
    #     if username.length < 2
    #       puts "Usernames must be at least 2 characters long. Restarting"
    #       next
    #     else
    #       has_username = true
    #     end
    #   end
    #
    #
    #   encrypted_password = nil
    #   has_password = false
    #
    #   until has_password
    #     password = @is.getpass("New Password: ")
    #
    #     if password.length < 6
    #       puts "Passwords must be at least 6 characters long. Restarting"
    #       next
    #     end
    #
    #     confirm_password = STDIN.getpass("Confirm Password: ")
    #
    #     if password == confirm_password
    #       encrypted_password = "{SHA256}#{Digest::SHA256.digest("#{username}:#{password}")}"
    #       has_password = true
    #     else
    #       puts "Incorrect password entered. Restarting"
    #     end
    #   end
    #
    #   [username, encrypted_password]
    # end
  end
end