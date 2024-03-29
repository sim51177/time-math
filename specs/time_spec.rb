require "rspec"
require "./time"

describe "Our Time" do
  it "should follow argument scheme given" do
    t = Our::Time.new
    t.AddMinutes "7:17 AM", 10
    t.to_s.should == "7:27 AM"
  end
  it "should be able to roll over hours by type regular" do
    t1 = Our::Time.new "08:55 AM"
    t1 =  t1 + "10m"
    t1.to_s.should == "09:05 AM"
  end
  it "should be able to roll over hours by type military" do
    t1 = Our::Time.new "23:55"
    t1 =  t1 + "10m"
    t1.to_s.should == "00:05"
  end
  it "should be able to take single digit as military and rollover" do
    t1 = Our::Time.new "3"
    t1 =  t1 + "60m"
    t1.to_s.should == "4"
  end
  it "should be able to take a single digit regular type and rollover" do
    t3 = Our::Time.new "3 AM"
    t3 =  t3 + "60m"
    t3.to_s.should == "4 AM"
  end
  it "should not use any built in date or time functions" do
    1.should == 1
  end
  it "should fail with bad format" do
    failed = false
    begin
      t5 = Our::Time.new "17 AM"
    rescue Exception => e
      failed = true
    end
    failed.should == true

    failed = false
    begin
      t5 = Our::Time.new "17 00 AM"
    rescue Exception => e
      failed = true
    end
    failed.should == true

    failed = false  
    begin
      t5 = Our::Time.new "47"
    rescue Exception => e
      failed = true
    end
    failed.should == true

    failed = false  
    begin
      t5 = Our::Time.new "17:00 AM"
    rescue Exception => e
      failed = true
    end
    failed.should == true
  end
  it "should be production quality code" do
    1.should == 1
    #so it should not be development code
    #should be efficient:
    #  1.) identify areas that can be done in more than one way
    #  2.) run performance tests
    #  3.) code reviewed
  end
end

#Without using any built in date or time functions, write a function or method
#that accepts two mandatory arguments. The first argument is a string of the
#format "[H]H:MM {AM|PM}" and the second argument is an integer. Assume the
#integer is the number of minutes to add to the string. The return value of
#the function should be a string of the same format as the first argument.
#For example AddMinutes("9:13 AM", 10) would return "9:23 AM". The exercise
#isn't meant to be too hard. I just want to see how you code. Feel free to
#do it procedurally or in an object oriented way, whichever you prefer. Use
#Ruby. Write production quality code.
