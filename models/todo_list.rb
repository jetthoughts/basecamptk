class TodoList < Rest

  def self.find_by_project(project)
    @todo_lists ||= {}
    @todo_lists[project.id] ||= self.find(:all, :params => {:project_id => project.id})
  end

  #def collection_path
  #  "/projects/#{project_id}"
  #end
end
