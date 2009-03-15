class PreferenceEdit < TkToplevel
  def initialize(user, password, callback)
    super(nil)
    title = "Preference"
    @on_save = callback
    ui(user, password)
  end

  private
  def save
    @on_save.call(@user.value, @password.value)
    destroy
  end

  def cancel
    destroy
  end

  def ui(user,password)
    raw = TkFrame.new(self).pack(:side => 'top', :fill => 'x')
    TkLabel.new(raw){text "User Name:"}.pack(:side => "left")
    @user = TkEntry.new(raw){width(15)}.pack("side"=>"right", "fill"=>"x", :padx => 30, :pady => 5)
    @user.value = user

    raw = TkFrame.new(self).pack(:side => 'top', :fill => 'x')
    TkLabel.new(raw){text "Password:"}.pack(:side => "left")
    @password = TkEntry.new(raw){width(15)}.pack("side"=>"right", "fill"=>"x", :padx => 30, :pady => 5)
    @password.value = password

    onSaveProc = proc{save}
    raw = TkFrame.new(self).pack(:side => 'top', :fill => 'x')
    TkButton.new(raw) {
      text "Save"
      command onSaveProc
      pack("side"=>"right")}

    onCancelProc = proc{cancel}
    TkButton.new(raw) {
      text 'Cancel'
      command onCancelProc
      pack("side"=>"right")}
  end

end
