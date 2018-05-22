class StatementMachine < Struct.new(:statement, :environment)
  def step
    self.statement, self.environment = statement.reduce(environment)
  end

  def run
    mysequence = []
    while statement.reducible?
      if "#{statement}".include? "do-nothing"
        step
      else
        if environment
          env = "#{environment}".tr(':«»', '').gsub!("=","-")
        else
          env = ""
        end
        #puts "#{statement},#{env}"
        mysequence.push("#{statement},#{env}")
        step
      end
    end

    if environment
      env = "#{environment}".tr(':«»', '').gsub!("=","-")
    else
      env = ""
    end
    #puts "#{env}"
    mysequence.push("#{env}")
    return mysequence
  end
end
