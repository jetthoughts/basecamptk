class TimeEntry < Rest
  def self.find_by_project(project)
    @time_entries ||= self.find(:all, :params => {:project_id => project})
  end

  def collection_path
    "/projects/#{project_id}/time_entries.xml"
  end
end
