#!/usr/bin/env ruby

require 'rubygems'
require 'tk'
#require 'tkextlib/bwidget'
require 'tkextlib/iwidgets'

require "activeresource"

#Load libraries
MODELS_PATH = "models"
VIEWS_PATH = "views"

require "models/rest"
libfilespat = File.join("**", "{#{VIEWS_PATH},#{MODELS_PATH}}", "**", "*.rb")
Dir.glob(libfilespat).each{|lib| require lib}


# Controller
def show_content(cont)
    cont.nil? ? "--" : cont
end

def show_users(users)
    show_content(users.map{|u| u.lastname}.join(","))
end

def show_post(post)
    @post = post
    @app.post_frame.entry = @post
end

def show_posts_for(project)
    @project = project
    @posts = project.posts
    log("Posts for '#{project.name}'", @posts, 'title')
    @app.posts_frame.entries = @posts.map do |i|
        "#{i.author_name}: " +
          "#{i.title}"
    end
    @app.spent_time_frame.enable
end

def commit_time(time_entry)
  t = TimeEntry.new(time_entry)
  t.project_id = @project.id
  t.person_id = Person.me.id
  raise t.errors.inspect unless t.save
rescue => e
  puts ">" * 20
  puts "Error: #{e}"
end

def log(title, collection, method)
  puts "= #{title}:\n  " + collection.map{|p|p.send(method)}.join("\n  ") + "\n"
end

@projects = Project.active
@companies = Company.find(:all)
@people = Person.find_all

log("Projects", @projects, 'name')
log("Companies", @companies, 'name')

@posts = []

@app = Application.new(ProjectIndex, PostIndex, PostShow, TimeEntryNew)
@app.projects_frame.projects = @projects
@app.projects_frame.onchange = proc{|id| show_posts_for(@projects[id])}
@app.posts_frame.onchange = proc{|id| show_post(@posts[id])}
@app.spent_time_frame.onsubmit = proc{|time_entry| commit_time time_entry}
@app.run


