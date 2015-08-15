User.find_or_create_by(username: 'admin') do |user|
	user.email    = 'admin@admin.com'
	user.username = 'admin'
	user.name	  = 'Admin User'
	user.password = 'password'
	user.add_role 	'admin'
end

1.upto(10) do |i|
   User.find_or_create_by(username: "test-#{i}") do |user|
		user.email    = "test-#{i}@example.com"
		user.name	  = "Test User #{i}"
		user.username = "test-#{i}"
		user.password = 'password'
		user.add_role 	'user'
	end
end