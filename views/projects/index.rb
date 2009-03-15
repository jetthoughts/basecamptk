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

  private  
  def ui
    $project_names = TkVariable.new([])
    @onchange = proc{|*args| true }
    
    list_w = TkListbox.new(self) do
      selectmode 'single'
      pack 'side' => 'right', 'fill' => 'both', 'expand' => 'true'
      listvariable $project_names
      relief "flat"
    end

    list_w.bind("ButtonRelease-1") do
      @onchange.call(*list_w.curselection) unless list_w.curselection.blank?
    end
    
    scroll_bar = TkScrollbar.new(self) do
      command proc{|*args| list_w.yview(*args)}
      width 10
      relief "flat"
      pack 'side' => 'left', 'fill' => 'y'
    end
    list_w.yscrollcommand {|first,last| scroll_bar.set(first,last) }
  end
  
end