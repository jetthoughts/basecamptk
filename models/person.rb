class Person < Rest

  def to_s
    name
  end

  def self.find_all
    @people ||= Company.find(:all).map{|c| find_by_company(c)}.flatten
  end

  def self.find_by_company(company)
    find_all_from("/contacts/people/#{company.id}")
  end

  def self.find_by_project_and_company(project, company)
    find_all_from("/projects/#{project.id}/contacts/people/#{company.id}")
  end

  def self.find_all_from(url)
    Person.find(:all, :from => url)
  end

  def self.find_by_name(name)
    find_all.each{|p| return p if !p.attributes["user_name"].nil? and p.user_name == name }
  end

  def self.me
    @me ||= find_by_name(self.user)
  end

end
