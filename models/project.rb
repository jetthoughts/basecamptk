class Project < Rest

  def to_s
    "#{name} [#{self.company.name}]"
  end
  
  def posts
    @posts ||= Post.find_by_project(self)
  end

  def self.archived
    @projects ||= self.all
    @projects.reject{|p|p.status!="archived"}
  end

  def self.active
    @projects ||= self.all
    @projects.reject{|p|p.status!="active"}
  end

  def self.all
    @projects ||= Project.find(:all)
  end
end
