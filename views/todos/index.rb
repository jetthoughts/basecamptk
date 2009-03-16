class TodoIndex < TkLabelFrame

  def initialize(*args)
    super(*args)
    text "To-Dos:"
    @on_todo_change = proc{|*args| true }
    config
  end
  
  def entries=(entries)
    @todo_entries.value = TkVariable.new(entries)
  end

  def entries
    @todo_entries.to_a
  end
  
  def onchange=(onchange = proc{|*args| true})
    @on_todo_change = onchange if onchange.is_a?(Proc)
  end

  private
  def config
    @todo_entries = TkVariable.new([])
    
    list_names = TkListbox.new(self) do
      selectmode 'single'
      pack 'side' => 'right', 'fill' => 'both', 'expand' => 'true'
      relief "flat"
      listvariable $entries
    end

    list_names.bind("ButtonRelease-1") do
      @on_todo_change.call(*list_names.curselection) unless list_names.curselection.blank?
    end
    
    scroll_bar = TkScrollbar.new(self) do
      command proc {|*args| list_names.yview(*args)}
      width 10
      relief "flat"
      pack 'side' => 'left', 'fill' => 'y'
    end
 
    list_names.yscrollcommand do |first,last|
      scroll_bar.set(first,last)
    end
  end

end
