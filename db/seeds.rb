
15.times do
  Wiki.create!(
    title:  Faker::Name.title,
    body:   Faker::Hipster.paragraph(3, true)
  )
end


# Default User
u = User.new(
  username:              'Ted Sappington',
  email:                 'tedsappington@gmail.com',
  password:              'password',
  password_confirmation: 'password'
)
u.skip_confirmation!
u.save!


# Standard User
u = User.new(
  username:     Faker::Name.name,
  email:        Faker::Internet.email,
  password:     Faker::Internet.password(6),
  role:         'standard'
)
u.skip_confirmation!
u.save!


# Premium User
u = User.new(
  username:     Faker::Name.name,
  email:        Faker::Internet.email,
  password:     Faker::Internet.password(6),
  role:         'premium'
)
u.skip_confirmation!
u.save!


# Admin User
u = User.new(
  username:     Faker::Name.name,
  email:        Faker::Internet.email,
  password:     Faker::Internet.password(6),
  role:         'admin'
)
u.skip_confirmation!
u.save!



puts "Seed complete"
puts "#{Wiki.count} wikis created"
puts "#{User.count} users created"
