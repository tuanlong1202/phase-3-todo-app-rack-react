puts "Clearing old data..."
Category.destroy_all
Task.destroy_all

puts "Seeding Categories..."

# create categories
cat1 = Category.create(name:"Food")
cat2 = Category.create(name:"Money")
cat3 = Category.create(name:"Code")
cat4 = Category.create(name:"Misc")

puts "Seeding Tasks..."

# create tasks
task1 = Task.create(text:"Buy rice")
task2 = Task.create(text:"Cooking rice")
cat1.tasks << task1
cat1.tasks << task2
task3 = Task.create(text:"Save a tenner")
task4 = Task.create(text:"Get an ISA")
cat2.tasks << task3
cat2.tasks << task4
task5 = Task.create(text:"Build a todo app")
task6 = Task.create(text:"Build a todo API")
cat3.tasks << task5
cat3.tasks << task6
task7 = Task.create(text:"Tidy house")
cat4.tasks << task7

puts "Done!"