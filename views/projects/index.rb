class ProjectIndex < TkLabelFrame
  def initialize(*args)
    super(*args)
    text "Projects:"
    ui
  end

  def projects=(projects)
    $project_names.value = TkVariable.new(projects)
  end
  
  def projects
    $project_names.to_a
  end
  
  def onchange=(onchange = proc{|*args| true})
    @onchange = onchange if onchange.is_a?(Proc)
  end

  def on_mode_change=(func)
    @on_mode_change = func if func.is_a?(Proc)
  end

  def modes=(modes)
    @modes = modes
  end
  private  
  def ui
    @onchange = proc{|*args| true }
    @on_mode_change = proc{|*args| true }

    @mode = TkVariable.new
    $project_names = TkVariable.new([])
    raw = TkFrame.new(self).pack(:side => 'top', :fill => 'x')
    scroll_bar = TkScrollbar.new(raw) do
      command proc{|*args| list_w.yview(*args)}
      width 10
      relief "flat"
      pack 'side' => 'left', 'fill' => 'y'
    end
    list_w = TkListbox.new(raw) do
      selectmode 'single'
      pack 'side' => 'right', 'fill' => 'both', 'expand' => 'true'
      listvariable $project_names
      relief "flat"
    end

    list_w.bind("ButtonRelease-1") do
      @onchange.call(*list_w.curselection) unless list_w.curselection.blank?
    end
    
    list_w.yscrollcommand {|first,last| scroll_bar.set(first,last) }

    modes = ["Messages", "Todos"]
    raw = TkFrame.new(self).pack(:side => 'top', :fill => 'x')
    TkLabel.new(raw){text "Modes:"}.pack(:side => "left") 
    button = TkOptionMenubutton.new(raw, @mode, *modes) {
            pack('side' => 'left', 'fill' => 'x', :padx => 15, :pady => 5)}
    m = button.menu
    m.bind('ButtonRelease-1', '@%y'){|y|
      value = m.entrycget(y, :value)
      @on_mode_change.call(y) unless value == @mode.value
    }
  end
  
end
