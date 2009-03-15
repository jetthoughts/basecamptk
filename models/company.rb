class Company < Rest

  def to_s
    name
  end

  def people
    Person.find_by_company(self)
  end

end
