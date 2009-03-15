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
#    log("Posts for '#{project.name}'", @posts, 'title')
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
  puts "Error: #{e}"
  alert(e)
end

def alert(e)
  Tk.messageBox(
                  'type'    => "ok",  
                  'icon'    => "error",
                  'title'   => "Error",
                  'message' => e
               )
end

def log(title, collection, method)
  puts "= #{title}:\n  " + collection.map{|p|p.send(method)}.join("\n  ") + "\n"
end

def load_projects
  @app.projects_frame.projects = []
  @projects = Project.active
  #log("Projects", @projects, 'name')
  @app.projects_frame.projects = @projects
rescue => e
  alert(e)
end

def set_authentication(user, password)
  Rest.user, Rest.password = user, password
end

def load_config
  $config = YAML.load_file("config.yml")
  set_authentication($config["user"], $config["password"])
end

def save_config
  File.truncate("config.yml", 0)
  f = File.new("config.yml", "w")
  f.write(YAML::dump($config))
  f.close
end

def show_preferences
  begin
    $win.destroy
  rescue
  end
  $win = TkToplevel.new(:title => "Prefernce")
  raw = TkFrame.new($win).pack(:side => 'top', :fill => 'x')
  TkLabel.new(raw){text "User Name:"}.pack(:side => "left")
  $user = TkEntry.new(raw){width(15)}.pack("side"=>"right", "fill"=>"x", :padx => 30, :pady => 5)
  $user.value = $config["user"]

  raw = TkFrame.new($win).pack(:side => 'top', :fill => 'x')
  TkLabel.new(raw){text "Password:"}.pack(:side => "left")
  $password = TkEntry.new(raw){width(15); value=$config["password"]}.pack("side"=>"right", "fill"=>"x", :padx => 30, :pady => 5)
  $password.value = $config["password"]

  raw = TkFrame.new($win).pack(:side => 'top', :fill => 'x')
  TkButton.new(raw) {
    text "Save"
    command proc{on_save_pref(); $win.destroy}
    pack("side"=>"right")
  }
  TkButton.new(raw) {
    text 'Cancel'
    command "$win.destroy"
    pack("side"=>"right")
  }
end

def on_save_pref
  $config = {"user" => "#{$user.value}", "password" => "#{$password.value}"}
  save_config
  load_config
end

#@companies = Company.find(:all)
#log("Companies", @companies, 'name')
#@people = Person.find_all

@projects = []
@posts = []

@app = Application.new(ProjectIndex, PostIndex, PostShow, TimeEntryNew)
@app.on_menu_preferences = proc{show_preferences}
@app.on_menu_reload = proc{load_projects}


@app.projects_frame.projects = @projects
@app.projects_frame.onchange = proc{|id| show_posts_for(@projects[id])}
@app.projects_frame.on_mode_change = Proc.new {puts 'hello'}

@app.posts_frame.onchange = proc{|id| show_post(@posts[id])}
@app.spent_time_frame.onsubmit = proc{|time_entry| commit_time time_entry}

load_config
load_projects

@app.run
