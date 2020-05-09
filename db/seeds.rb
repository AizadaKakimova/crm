# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
city1 = City.create(name: "Almaty", slug: "almaty")
city2 = City.create(name: "Astana", slug: "astana")

sm=Branch.create(city: city1, address: "Байзакова 280, 2 этаж", name: "branch1", phone: "8701559634")
ast=Branch.create(city: City.second, address: "Байзакова 281, 2 этаж", name: "branch2", phone: "8701559634")
v = Branch.create(city: city1, address: "Розыбакиева, 1 этаж", name: "branch3", phone: "8701559670")
c = Branch.create(city: City.second, address: "Розыбакиева, 1 этаж", name: "Art", phone: "8701559670")
samat = User.create(name: 'samat', email: 'samat@method.kz', password: 'qwerty', role: 'admin',phone: "87082225272", branch: sm,city: City.first)
aizada = User.create(name:'aizada', email: 'kakimova3008@gmail.com', password: 'qwerty', role: 'admin', phone: '87013139936',branch: sm,city: City.first)
aiz = User.create(name:'aizada', email: 'kakimova08@gmail.com', password: 'qwerty', role: 'admin', phone: '8701313936',branch: sm,city: City.first)
samat = User.create(name: 'samat', email: 'samat@method.kz', password: 'qwerty', role: 'admin',phone: "87082225272", branch: sm,city: City.second)
sam = User.create(name: 'sam', email: 'sam@method.kz', password: 'qwerty', role: 'admin',phone: "87072225272", branch: c,city: City.second)
barack = User.create(name: 'Barack Obama', email: 'obama@method.kz', password: 'qwerty', role: 'admin',phone: "87012225272", branch: Branch.second,city: City.first)
UsersBranch.create(user: samat, branch: sm)
UsersBranch.create(user: samat, branch: v)
UsersBranch.create(user: barack, branch: Branch.second)
instructor = User.create(name: 'John', email: 'john@gmail.kz', password: 'qwerty', role: 'instructor',phone: "87082225243", branch: sm, city: City.first)
instructor2 = User.create(name: 'Alex', email: 'alex@gmail.kz', password: 'qwerty', role: 'instructor',phone: "87082225253",branch: v, city: City.last)
user = User.create(name: 'Aiz', email: '@kkk@mail.ru', password: 'qwerty', role: 'user', phone: '87013139999', branch: sm, city: City.first)

for i in 1..10 do
	User.create(name: 'aiz'+i.to_s, email: 'aizaada@gmail.kz'+i.to_s, password: 'qwerty', role: 'user', phone:"87777777"+i.to_s,branch: v, branch_id: v.id, city: City.first)
end

for i in 11..25 do
	User.create(name: 'aldiyar'+i.to_s, email: 'aldiyar@gmail.kz'+i.to_s, password: 'qwerty', role: 'user', phone: "87777777"+i.to_s, branch: sm, branch_id: sm.id, city: City.first)
end



for i in 1..10 do
	Request.create(name: 'aiz'+i.to_s, email: 'aiz@gmail.kz'+i.to_s, phone: "8708222527"+i.to_s, source: "recommendation", branch_id: sm.id, status: 'Новая', city_id: City.first.id)
end
for i in 15..25 do
	Request.create(name: 'aldiyar'+i.to_s, email: 'aldiyar@gmail.kz'+i.to_s, phone: "870822252"+i.to_s, source: "recommendation", branch_id: v.id, status: 'Новая', city_id: City.first.id)
end

Course.create(title: 'Python', file_name: 'python',price: 100000, slug: 'python', visible: true, description:"Курс по питону", level: "Начальный", shown: true, duration: "2 месяца", image_link: "python.png", city: City.first)
Course.create(title: 'Django', file_name: 'django', price: 200000, slug: 'django', visible: true,description:"Курс по Django", level: "Средний", shown: true,duration: "2 месяца", image_link: "django.png", city: City.first)
Course.create(title: 'Intro to ML', file_name: 'ml', price: 190000, slug: 'ml', visible: true,description:"Курс по Анализу данных", level: "Продвинутый", shown: true,duration: "2 месяца",image_link: "ml.png", city: City.second)


g1 = Group.create(title: "B16", course: Course.first, instructor: User.find_by(email:'john@gmail.kz'), city_id: 1, start: Date.new(2019, 2, 8), end: Date.new(2019, 3, 8), branch_id: Branch.first.id)
g2 = Group.create(title: "A19", course: Course.second, instructor: User.find_by(email:'john@gmail.kz'), city_id: 1, start: Date.new(2019, 12, 12), end: Date.new(2019, 12, 12), branch: Branch.first)
g2 = Group.create(title: "D10", course: Course.second, instructor: User.find_by(email:'john@gmail.kz'), city_id: 2, start: Date.new(2019, 11, 11), end: Date.new(2019, 12, 12), branch: Branch.first)

Enrollment.create(user: User.third,group: g2,expected_value: 65000,status: "enrolled")
Enrollment.create(user: User.last,group: g2,expected_value: 65000,status: "enrolled")