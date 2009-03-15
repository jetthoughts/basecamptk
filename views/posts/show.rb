class IssueShow < TkLabelFrame

  def initialize(*args)
    super(*args)
    text "Issue \#-"
    @info = []
    ui
  end

  def issue=(issue)
    text "Issue \##{issue.id}"
    @info[0].value = show_content(issue.description)
    @info[1].value = show_content(issue.status.name)
    @info[2].value = show_users(issue.assigned_to_users)
    @info[3].value = issue.spent_hours > 0 ? show_content(issue.spent_hours) : "--"
    @info[4].value = issue.estimated_hours
  end

  private
  def ui
    [ "Description:",
      "Status:",
      "Assigned to:",
      "Spent:",
      "Estimate:"].each do |l|
        raw = TkFrame.new(self){pack :side => "top", :fill => "x"}
        TkLabel.new(raw){text l}.pack :side => "left"
        @info << TkText.new(raw) do
          insert(:end, "none")
          width 50
          height 1
          wrap :word
          pack :side => "left", :fill => "x"
        end
    end
  end
end
