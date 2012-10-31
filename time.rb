module Our
  class Time

    #  Assuming the overall architecture requires lib functions to raise
    #  and the calling functions should take care of exceptions
    #  in a friendly manner.
    
    #  I did not bother yamlizing hard coded values.

    def initialize(time=nil)
      return if !time
      @time = time.strip # string of "[H]H:MM {AM|PM}"
      @hours = nil # int, 1 to 12 if Regular, 0 to 23 if Military.
      @minutes = nil # int, 0 to 60.
      @type = nil # :regular, :military
      @am_pm = nil # :am, :pm # what is that even called in the real world
      @format = nil
      @hour_format = nil
      @minute_format = nil 
      breakdown
    end
    def AddMinutes(time,minutes)
      initialize(time)
      add_minutes(minutes)
    end
    def set_hours(x)
      
      raise "Type must be set before hours" if !@type
      raise "Regular hours out of range for regular time" if (x > 12 || x < 1) && @type == :regular
      @hours = x

      raise "Regular hours out of range for military time" if (x > 23 || x < 0) && @type == :military
      @hours = x
    end
    def set_minutes(x)
      @minutes = x
      raise "Regular minutes out of range" if @minutes >= 60 || @minutes < 0
    end
    def set_am_pm(x)
      @am_pm = x
      raise "Regular am,pm value out of range" if ![:am,:pm].include?(@am_pm)
    end
    def breakdown
      components = @time.split(/ |, |:/)
      #assumptions 3 elements means H,M,AM|PM
      if components.size == 3 
	raise "Expecting colon seperator" unless @time.include?(":")
        @type = :regular
        set_hours(components[0].to_i)
        set_minutes(components[1].to_i)
        set_am_pm(components[2].downcase.to_sym)
        @format = "HH:MM AM"
        @hour_format = components[0].length
        @minute_format =  components[1].length 
      end

      if components.size == 1
        @type = :military
        set_hours(components[0].to_i)
        set_minutes(0)
	@format = "HH"
	@hour_format = components[0].length
        @minute_format = @hour_format # default 
      end

      if components.size == 2
        if @time.include?(":")
          @type = :military
          set_hours(components[0].to_i)
          set_minutes(components[1].to_i)
          @format = "HH:MM"
          @hour_format = components[0].length
          @minute_format = components[1].length 
        end
        if [:am,:pm].include?(components[1].downcase.to_sym)
          #12 PM
          @type = :regular
          set_hours(components[0].to_i)
          set_minutes(0)
          set_am_pm(components[1].downcase.to_sym)
          @format = "HH AM"
	  @hour_format = components[0].length
          @minute_format = @hour_format
        end
      end
    end
    def add_minutes(x)
      @minutes += x
      if @minutes >= 60
        begin
          add_hours(1)
          @minutes -= 60
        end while @minutes >= 60
      end #if
    end
    def add_hours(x)
      @hours += x
      if @type == :regular
        while @hours > 12
          @hours -= 12
          @am_pm = :am ? :am : pm
        end
      else
        while @hours >= 24
          @hours -= 24
          @am_pm = :am ? :am : pm
        end
      end
    end #add_hours
    def +(x)
      #Like 3m
      time_to_add = x.to_i
      component = x[-1,1]
      if component == "m"
        add_minutes(time_to_add)
      else
        raise "Only minute math is allowed."
      end
      self
    end #def
    def to_s
      #puts @type
      #puts @hours
      #puts @minutes
      #puts @am_pm
      #puts @time
      
      #if it's a one digit hour and has minute now make it two
      #but i feel minutes should always be 00
      #this could be more sophisticated, but no time
      if @type == :regular
        @time = ( @hours.to_s.length == 1 ? "0" + @hours.to_s : @hours.to_s ) if @hour_format == 2
        @time = ( @hours.to_s ) if @hour_format == 1
        @time += ":" +( @minutes.to_s.length == 1 ? "0" + @minutes.to_s : @minutes.to_s ) unless @minutes == 0 && @format == "HH AM"
        @time += " " + @am_pm.to_s.upcase
      else
        #@time = ( @hours.to_s.length == 1 ? "0" + @hours.to_s : @hours.to_s )
        @time = ( @hours.to_s.length == 1 ? "0" + @hours.to_s : @hours.to_s ) if @hour_format == 2
        @time = ( @hours.to_s ) if @hour_format == 1
        @time += ":" +( @minutes.to_s.length == 1 ? "0" + @minutes.to_s : @minutes.to_s ) unless @minutes == 0 && @format == "HH"
      end
      @time
    end
  end #class
end #module
