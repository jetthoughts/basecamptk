class Application

  attr_accessor :projects_frame, :posts_frame, :post_frame, :spent_time_frame

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
    rightSide.add @post_frame
    rightSide.add @spent_time_frame
  end

  def run
    Tk.mainloop
  end
end
