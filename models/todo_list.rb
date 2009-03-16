class TodoList < Rest
  def self.find_by_project(project)
    @todo_lists ||= self.find(:all, :params => {:project_id => project})
  end

  #def collection_path
  #  "/projects/#{project_id}"
  #end
end
