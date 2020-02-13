require "date"
require "./connect_db.rb"

connect_db!

class Todo < ActiveRecord::Base
  def self.add_task(h)
    Todo.create!(todo_text: h[:todo_text], due_date: Date.today + h[:due_in_days], completed: false)
  end

  def self.mark_as_complete!(todo_id)
    todo = find(todo_id)
    todo.completed = true
    todo.save
    todo
  end

  def self.overdue
    all.where("due_date < ?", Date.today)
  end

  def due_today?
    due_date == Date.today
  end

  def self.due_today
    all.where("due_date = ?", Date.today)
  end

  def self.due_later
    all.where("due_date > ?", Date.today)
  end

  def to_displayable_string
    box = completed ? "[X]" : "[ ]"
    date = (due_today?) ? nil : due_date
    "#{id}. #{box} #{todo_text} #{date}"
  end

  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    puts overdue.map { |todo| todo.to_displayable_string }
    puts "\n\n"

    puts "Due Today\n"
    puts due_today.map { |todo| todo.to_displayable_string }
    puts "\n\n"

    puts "Due Later\n"
    puts due_later.map { |todo| todo.to_displayable_string }
  end
end
