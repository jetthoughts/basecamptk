class Post < Rest

  def to_s
    "#{title}"
  end
 
  def self.find_by_project(project)
    self.find(:all, :params => {:project_id => project.id})
  end

  def category
    @category ||= Category.find(self.category_id) if category_id
  end

end
