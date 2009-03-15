class TimeEntryNew < TkLabelFrame
  def initialize(*args)
    super(*args)
    text "Log Time:"
    @activity = TkVariable.new
    @onsubmit = proc {|*args| false}
    ui
  end
 
  def onsubmit=(onsubmit)
    @onsubmit = onsubmit
  end
  
  def disable
    @submit_button.state :disabled
  end
  
  def enable
    @submit_button.state :normal
  end

  private
  def ui
    raw = TkFrame.new(self).pack(:side => 'top', :fill => 'x')
    TkLabel.new(raw){text "Spent On*:"}.pack(:side => "left")
    @spent_on = Tk::Iwidgets::Dateentry.new(raw).pack(:side => 'left', :padx => 12, :pady => 5)

    raw = TkFrame.new(self).pack(:side => 'top', :fill => 'x')
    TkLabel.new(raw){text "Hours*:"}.pack(:side => "left")
    @hours = TkEntry.new(raw){width 5}.pack("side"=>"left", "fill"=>"x", :padx => 30, :pady => 5)

    raw = TkFrame.new(self).pack(:side => 'top', :fill => 'x')
    TkLabel.new(raw){text "Comments:"}.pack(:side => "left")
    @comments = TkEntry.new(raw){width 35}.pack("side"=>"left", "fill"=>"x", :padx => 6, :pady => 5)

    submitProc = proc {submit}
    raw = TkFrame.new(self).pack(:side => 'top', :fill => 'x')
    @submit_button = TkButton.new(raw) do
      text("Save")
      command submitProc
      pack :side => "left", :padx => 10
      state :disabled
    end
  end
  
  def validate?
     @hours.value.to_i > 0 and @spent_on.get
  end
  
  def submit
    return unless validate?
    @submit_button.state :disabled
    @onsubmit.call(:description => @comments.value,
                   :hours => @hours.value,
                   :date => @spent_on.get,
                   :person_id => 2965770)
    @submit_button.state :normal
  end
end
