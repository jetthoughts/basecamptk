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

  def onstart
    
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
    @hours = TkEntry.new(raw){width(5); value=0}.pack("side"=>"left", "fill"=>"x", :padx => 30, :pady => 5)

    raw = TkFrame.new(self).pack(:side => 'top', :fill => 'x')
    TkLabel.new(raw){text "Comments:"}.pack(:side => "left")
    @comments = TkEntry.new(raw){width 35}.pack("side"=>"left", "fill"=>"x", :expand=> true, :padx => 6, :pady => 5)

    submitProc = proc {submit}
    startProc = proc {start}
    raw = TkFrame.new(self).pack(:side => 'top', :fill => 'x')
    @start_button = TkButton.new(raw) do
      text("Start")
      command startProc
      pack :side => "left", :padx => 10
    end
    @submit_button = TkButton.new(raw) do
      text("Commit")
      command submitProc
      pack :side => "left", :padx => 10
      state :disabled
    end
  end
  
  def validate?
    !@hours.value.blank? and @spent_on.get
  end
  
  def submit
    return unless validate?
    @submit_button.state :disabled
    @onsubmit.call(:description => @comments.value,
                   :hours => @hours.value,
                   :date => @spent_on.get)
    @submit_button.state :normal
  end

  def start
    stopProc = proc {stop}
    @start_button.command = stopProc
    @seconds = @hours.value.blank? ? Time.parse("00:00") : Time.parse(@hours.value)
    @counter_thread = Thread.new { loop {counter} }
    @start_button.text("Stop")
  end

  def counter
    sleep(1)
    @seconds += 1
    @hours.value = Time.at(@seconds).strftime("%H:%M")
  end

  def stop
    Thread.kill(@counter_thread)
    startProc = proc {start}
    @start_button.command = startProc
    @start_button.text("Start")
  end
end
