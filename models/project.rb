class Project < Rest

  def to_s
    "#{name} [#{self.company.name}]"
  end
  
  def posts()
    @posts ||= Post.find_by_project(self)
  end

  def self.archived(reload=false)
    self.all(reload).reject{|p|p.status!="archived"}
  end

  def self.active(reload=false)
    self.all(reload).reject{|p|p.status!="active"}
  end

  def self.all(reload=false)
    @projects = (!reload and @projects) || Project.find(:all)
  end
end
