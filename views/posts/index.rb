class PostIndex < TkLabelFrame

  def initialize(*args)
    super(*args)
    @onchange = proc{|*args| true }
    config
    text "Messages:"
  end
  
  def entries=(entries)
    $post_entries.value = TkVariable.new(entries)
  end

  def onchange=(onchange = proc{|*args| true})
    @onchange = onchange if onchange.is_a?(Proc)
  end

  private
  def config
    $post_entries = TkVariable.new([])
    
    list_names = TkListbox.new(self) do
      selectmode 'single'
      pack 'side' => 'right', 'fill' => 'both', 'expand' => 'true'
      relief "flat"
      listvariable $post_entries
    end

    list_names.bind("ButtonRelease-1") do
      @onchange.call(*list_names.curselection) unless list_names.curselection.blank?
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
