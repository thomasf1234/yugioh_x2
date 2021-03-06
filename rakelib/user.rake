# http://stackoverflow.com/questions/16948645/how-do-i-test-a-function-with-gets-chomp-in-it

namespace :admin do
  namespace :user do
    desc "list users"
    task :list do
      YugiohX2::User.all.each do |user|
        puts user.username
      end
    end

    desc "add user with password"
    task :add do
      prompt = Ax1Utils::Prompt.new
      username = prompt.prompt_username
      user = YugiohX2::User.find_by_username(username)

      if user.nil?
        password = prompt.prompt_password
        encrypted_password = YugiohX2::User.encrypt_password(username, password)
        YugiohX2::User.create({username: username, encrypted_password: encrypted_password})
      else
        raise("User already exists")
      end
    end

    desc "updates password for user"
    task :update_password, [:username]  do |t, args|
      username = args[:username]
      raise ArgumentError.new("Username required") if username.blank?

      user = YugiohX2::User.find_by_username(username)

      if user.nil?
        raise("User not found")
      else
        prompt = Ax1Utils::Prompt.new
        password = prompt.prompt_password('New Password: ')
        encrypted_password = YugiohX2::User.encrypt_password(username, password)
        user.encrypted_password = encrypted_password
        user.save!
      end
    end

    desc "removes user"
    task :remove, [:username]  do |t, args|
      username = args[:username]
      raise ArgumentError.new("Username required") if username.blank?

      user = YugiohX2::User.find_by_username(username)

      if user.nil?
        raise("User not found")
      else
        user.destroy!
      end
    end

    desc "add 1 of every card"
    task :grant_all_cards, [:username]  do |t, args|
      username = args[:username]
      raise ArgumentError.new("Username required") if username.blank?

      user = YugiohX2::User.find_by_username(username)

      if user.nil?
        raise("User not found")
      else
        YugiohX2::Card.all.each do |card|
          user_card = user.user_cards.find_by_card_id(card.id)
          puts "Granting #{card.name}"

          if user_card.nil?
            YugiohX2::UserCard.create!(user_id: user.id, card_id: card.id)
          else
            user_card.increment!(:count)
          end
        end
      end
    end
  end
end