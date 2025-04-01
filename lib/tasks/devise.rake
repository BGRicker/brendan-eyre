namespace :devise do
  desc "Create a user"
  task :create_user, [:email, :password] => :environment do |t, args|
    if args[:email].blank? || args[:password].blank?
      puts "Usage: rake devise:create_user[email,password]"
      exit 1
    end

    user = User.new(
      email: args[:email],
      password: args[:password],
      password_confirmation: args[:password]
    )

    if user.save
      puts "User created successfully!"
    else
      puts "Failed to create user:"
      user.errors.full_messages.each do |msg|
        puts "  - #{msg}"
      end
      exit 1
    end
  end
end 