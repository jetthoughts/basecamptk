class TodoItem < Rest
  def self.find_by_todo_list(todo_list)
    @todo_lists ||= self.find(:all, :params => {:todo_list_id => todo_list})
  end

  #def collection_path
  #  "/projects/#{project_id}"
  #end
end
