=begin

As a coffee barista
I want to select the type and amount of coffee from a menu
So that I can more efficiently ring up sales.

           ACCEPTANCE CRITERIAS
  * The menu is displayed for the user
  * The user is prompted to select a type of coffee from a menu
  * The user is prompted to input the amount of coffee
  * The subtotal is calculated after every amount of coffee has been specified
  * There is an option to complete the sale present in the menu
  * Upon completion of sale, the price, amount of each item, and total cost is displayed

=end

class Register
  def initialize
    @coffee_name = {1=>"Light", 2=>"Medium", 3=>"Bold"}
    @coffee_options = {1=>5.00,2=>7.50,3=>9.75}
    @item_tracker = {}
    @total = 0
    @done_counter = 0
  end

# Below are the display methods

  def display_menu
    puts "Welcome to Lorrayne and Sherwin's coffee emporium!\n\n"
    puts "1) Add item - $5.00 - Light Bag"
    puts "2) Add item - $7.50 - Medium Bag"
    puts "3) Add item - $9.75 - Bold Bag"
    puts "4) Complete Sale"
  end

  def select_option
    puts "Make a selection:"
    @selection = get_input
  end

  def select_amount
    puts "How many bags?"
    get_input
  end

  def check_amount
    unless valid_amount?
      puts "WARNING: Not a valid amount entered. Please try again."
      get_input
      check_amount
    end
  end

  def display_complete_sale
    puts "===Sale Complete===\n\n\n"
    @item_tracker.each do |selection,amount|
      puts "$#{format_number(amount*@coffee_options[selection.to_i])} - #{amount} #{@coffee_name[selection.to_i]}"
    end
    puts "\n\nTotal: $#{format_number(@total)}"
  end

  def unsuccessful_checkout
    puts "WARNING: The customer still owes $#{format_number(calc_change)}! Exiting..."
  end

  def successful_checkout
    puts "===Thank You!==="
    print "The total change due is $#{format_number(calc_change)}\n\n"
    puts Time.now
    puts "================"
  end

  def checkout
    puts "What is the amount tendered?"
    get_input
    checkout unless valid_input?
    calc_change
    if  @input.to_f >= @total
      successful_checkout
    else
      unsuccessful_checkout
    end
  end

  def display_subtotal
    @total += (@coffee_options[@selection.to_i]*@input.to_i)
    puts "Subtotal: $#{format_number(@total)}"
  end

#Below are the get and validation methods

  def get_input
    @input = gets.chomp
  end

  def recursive_get
    @selection = get_input
  end

  def check_selection
    checkout if check_done?
    unless valid_selection?
      select_option
      check_selection
    end
  end

  def check_done?
    @input.to_i == 4
  end

  def valid_selection?
    @input.match(/\A[1-3]\z/)
  end

  def valid_amount?
    @input.match(/\A\d*\z/)
  end

  def valid_input?
    @input.match(/\A\d*\.?\d?\d?\z/)
  end

# Below are the computational methods

  def format_number(num)
    sprintf("%.2f",num)
  end

  def item_tracker
    if @item_tracker.has_key?(@selection)
      @item_tracker[@selection] = (@item_tracker[@selection].to_i + @input.to_i)
    else
      @item_tracker[@selection] = @input.to_i
    end
  end

  def calc_change
    (@total - @input.to_f).abs
  end
end

class Runner
  def initialize
    x = Register.new

    x.display_menu
    x.select_option
    until x.check_done?
      if x.valid_selection?
        x.select_amount
        x.check_amount
        x.item_tracker
        x.display_subtotal
        puts "What item is being purchased?"
        x.recursive_get
      elsif !x.check_done?
        puts "WARNING! Input not valid, please enter valid input."
      end
    end
    x.display_complete_sale
    x.checkout
  end
end

Runner.new

