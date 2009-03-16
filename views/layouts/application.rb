class Application

  attr_accessor :projects_frame, :posts_frame, :post_frame, :spent_time_frame, :todos_frame, :todo_frame
  attr_accessor :on_menu_preferences, :on_menu_reload

  def initialize(options = {})
    opts = {:projects_frame => TkFrame,
            :posts_frame => TkFrame,
            :post_frame => TkFrame,
            :todos_frame => TkFrame,
            :todo_frame => TkFrame,
            :spent_time_frame => TkFrame}.merge(options)
    @root = TkRoot.new {title "Time Tracker For Redmine"}

    
    container = TkPanedwindow.new(@root) do
      orient "vertical"
      pack :side => "left", :fill => "both", :expand => 1
    end

    topSide = TkPanedwindow.new(@root) do
      orient "horizontal"
      pack :side => "top", :fill => "both", :expand => 1
    end


    tabs = Tk::Iwidgets::Tabnotebook.new(:width=>800, :height=>300, :tabpos => 'n')
    posts_tab = tabs.add(:label => "Messages")
    todos_tab = tabs.add(:label => "To-Dos")

    postSide = TkPanedwindow.new(posts_tab) do
      orient "horizontal"
      pack :side => "top", :fill => "both", :expand => 1
    end
    todoSide = TkPanedwindow.new(todos_tab) do
      orient "horizontal"
      pack :side => "top", :fill => "both", :expand => 1
    end
    tabs.select(0)

    @projects_frame = opts[:projects_frame].new(@root) do
      pack :expand => true, :fill => 'both', :expand => 1
    end

    @posts_frame = opts[:posts_frame].new(posts_tab).pack(:side => "left", :expand => true, :fill => 'both')
    @todos_frame = opts[:todos_frame].new(todos_tab).pack(:side => "left", :expand => true, :fill => 'both')
    @todo_frame = opts[:todo_frame].new(todos_tab).pack
    @post_frame = opts[:post_frame].new(@root)
    @spent_time_frame = opts[:spent_time_frame].new(@root) do
      pack :expand => 0
    end
        
    
    #container.add @posts_frame
    container.add topSide
    container.add tabs
    
    topSide.add @projects_frame, :width => 300
    topSide.add @spent_time_frame, :width => 50

    postSide.add @posts_frame, :width => 300
    postSide.add @post_frame

    todoSide.add @todos_frame, :width => 300
    todoSide.add @todo_frame

    init_menu
  end

  def init_menu
    @on_menu_preferences = proc{|*args| true }
    file_menu = TkMenu.new(@root)
    file_menu.add('command',
                  'label'     => "Preferences",
                  'command'   => proc{@on_menu_preferences.call},
                  'underline' => 0)
    file_menu.add('command',
                  'label'     => "Reload",
                  'command'   => proc{@on_menu_reload.call},
                  'underline' => 0)
    menu_bar = TkMenu.new
    menu_bar.add('cascade',
                 'menu'  => file_menu,
                 'label' => "File")
    @root.menu(menu_bar)
  end

  def run
    Tk.mainloop
  end
end
