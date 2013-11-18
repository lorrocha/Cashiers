class Register
  def initialize
    @item_list = []
  end
 
  def get_input
    @input = gets.chomp
  end
 
  def check_input
    if check_done
      checkout
    else
      get_input
    end  
  end
 
  def check_done?
    @input.downcase == "done"
  end
 
  def valid_input?
    @input.match(/\A\d*\.?\d?\d?\z/)
  end
 
  def add_item
    @item_list << @input
  end
 
  def checkout
    puts "Total amount due: $#{format_number(subtotal)}\n\n\n"
    puts "What is the amount tendered?"
    get_input
    get_input unless valid_input
    if  @input >= @total
      successful_checkout
    else
      unsuccessful_checkout
    end
  end
  
  def format_number(num)
    sprintf("%.2f",num)
  end
 
  def calc_subtotal
    @total = @item_list.map{|x| x.to_f}.reduce(:+)
  end
 
  def calc_change
    (@total - @input).abs
  end
 
  def unsuccessful_checkout
    puts "WARNING: The customer still owes $#{format_number(calc_change)}!"
  end 
 
  def succesful_checkout
    puts "===Thank You!==="
    print "The total change due is $#{format_number(calc_change)}\n\n"
    puts Time.now
    puts "================"
  end
end