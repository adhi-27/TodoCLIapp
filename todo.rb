require "date"
require "./connect_db.rb"

connect_db!

class Todo < ActiveRecord::Base
  def self.add_task(h)
    Todo.create!(todo_text: h[:todo_text], due_date: Date.today + h[:due_in_days], completed: false)
  end

  def self.mark_as_complete!(todo_id)
    all.each do |todo|
      if todo.id == todo_id
        todo.completed = true
        todo.save
        return todo
      end
    end
  end

  def overdue?
    due_date < Date.today
  end

  def due_today?
    due_date == Date.today
  end

  def due_later?
    due_date > Date.today
  end

  def to_displayable_string
    box = completed ? "[X]" : "[ ]"
    date = (due_today?) ? nil : due_date
    "#{id}. #{box} #{todo_text} #{date}"
  end

  def self.show_list
    puts "My Todo-list\n\n"

    puts "Overdue\n"
    all.map do |todo|
      if todo.overdue?
        puts todo.to_displayable_string
      end
    end
    puts "\n\n"

    puts "Due Today\n"
    all.map do |todo|
      if todo.due_today?
        puts todo.to_displayable_string
      end
    end
    puts "\n\n"

    puts "Due Later\n"
    all.map do |todo|
      if todo.due_later?
        puts todo.to_displayable_string
      end
    end
  end
end
