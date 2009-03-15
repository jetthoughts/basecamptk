class Application

  attr_accessor :projects_frame, :posts_frame, :post_frame, :spent_time_frame
  attr_accessor :on_menu_preferences

  def initialize(projects_frame = TkFrame, posts_frame = TkFrame, post_frame = TkFrame, spent_time_frame = TkFrame)
    @root = TkRoot.new {title "Time Tracker For Redmine"}

    container = TkPanedwindow.new(@root) do
      orient "horizontal"
      pack :side => "left", :fill => "both", :expand => 1
    end
    
    rightSide = TkPanedwindow.new(@root) do
      orient "vertical"
      pack :side => "right", :fill => "both", :expand => 1
    end

    @projects_frame = projects_frame.new(@root)

    @posts_frame = posts_frame.new(@root) do
      height 200
    end

    @post_frame = post_frame.new(@root)
    @spent_time_frame = spent_time_frame.new(@root)
        
    
    container.add @posts_frame
    container.add rightSide
    
    rightSide.add @projects_frame
    rightSide.add @spent_time_frame
    rightSide.add @post_frame
    init_menu
  end

  def init_menu
    @on_menu_preferences = proc{|*args| true }
    file_menu = TkMenu.new(@root)
    file_menu.add('command',
                  'label'     => "Preferences",
                  'command'   => proc{@on_menu_preferences.call},
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
