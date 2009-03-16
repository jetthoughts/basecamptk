class TodoShow < TkLabelFrame

  def initialize(*args)
    super(*args)
    text "Todo: "
    @info = []
    ui
  end

  def entry=(entry)
    @info[0].value = "#{entry.content}"
    @info[1].value = entry.completed.to_s
    @info[2].value = entry.created_on.to_s
    @info[3].value = entry.creator_id.to_s
    #"responsible_party_id"=>1129212, "todo_list_id"=>4759184, "responsible_party_type"=>"Person"
  end

  private
  def ui
    [ "Content:",
      "Completed:",
      "Created on:",
      "Creator"].each do |l|
        raw = TkFrame.new(self){pack :side => "top", :fill => "x"}
        TkLabel.new(raw){text l}.pack :side => "left"
        @info << TkText.new(raw) do
          insert(:end, "none")
          width 50
          height 1
          wrap :word
          pack :side => "left", :fill => "x", :expand => true
        end
    end
  end
end
