class PostShow < TkLabelFrame

  def initialize(*args)
    super(*args)
    text "Message: "
    @info = []
    ui
  end

  def entry=(entry)
    text "#{entry.title}"
    @info[0].value = entry.author_name
    @info[1].value = entry.posted_on
    @info[2].value = entry.category.name
    @info[3].value = entry.body
  end

  private
  def ui
    [ "From:",
      "Date:",
      "Category:"].each do |l|
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
    @info << TkText.new(self) do
      insert(:end, "none")
      wrap :word
      pack :side => "top", :fill => "x", :expand => true
    end
  end
end
