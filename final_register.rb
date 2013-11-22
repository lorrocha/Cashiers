require 'CSV'
require 'pry'

@item_list={}
@shopping_list = {}
@order_number=1
@total = 0

# These methods format different inputs
def format_string_to_sym(word)
  word.gsub!(' ', '_')
  word.intern
end

def capitalize(name)
  names = []
  name.split(' ').each do |word|
    names << word.capitalize
  end
  names.join(' ')
end

def format_number(num)
  sprintf("%.2f",num)
end

def format_number(num)
  sprintf("%.2f",num)
end

def populate_item_list(file, list)
  CSV.foreach(file, headers: true) do |line|                  #line is an array of header,value arrays
    temp_hash = {}
    line.each_with_index do |word, index|                     #So this is taking the array word and assigining an index
      temp_hash[format_string_to_sym(word[0])] = word[1] unless word[0].nil? #Here I'm populating the my temp_hash with a hash of the arrays
      new_key = temp_hash.delete(:sku)                        #Here I'm deleting the key :item and setting it's value to new_key
      list[new_key.to_i] = temp_hash unless new_key.nil?           #Here I'm adding the temp_hash to the new_key key in the @item_list hash
    end
  end
end

# This stuff above simply populates the current item list. Everything below is the functionality of the register

def display_item_menu(list)
  list.each_with_index do |item, index|
    puts "#{item[0]}) Add item - $#{item[1][:purchasing_price]} - #{capitalize(item[1][:item])}"
  end
  puts 'To complete the transaction type "Done".'
end

def gets_input
  @input = gets.chomp
end

def select_option
  puts "Make a selection:"
  @selection = gets_input
  if check_done?
    true
  elsif !valid_selection?
    select_option
  end
end

def select_amount_of_bags
  puts "How many bags?"
  @amount = gets_input
  select_amount_of_bags unless valid_numeric?
end

def display_subtotal
    @total += ((@item_list[@selection.to_i][:purchasing_price]).to_f*@amount.to_i)
    puts "Subtotal: $#{format_number(@total)}"
    @time = Time.new
end
# Time.new.strftime("%Y-%m-%d")] = time:(Time.new.strftime("%H:%M:%S"
def update_shopping_list
  temp_hash = {}
  temp_hash[:total_number_items] = @amount
  temp_hash[:sku] = @selection
  temp_hash[:price] = @item_list[@selection.to_i][:purchasing_price]
  temp_hash[:item_total] = (@item_list[@selection.to_i][:purchasing_price]).to_f*@amount.to_i
  temp_hash[:name] = @item_list[@selection.to_i][:item]
  @shopping_list[@order_number] = temp_hash
  @order_number += 1
end

def display_complete_sale
  puts "===Sale Complete===\n\n\n"
  @shopping_list.each do |key, value|
    puts "$#{format_number(@shopping_list[key][:item_total])} - #{@shopping_list[key][:total_number_items].to_i} #{capitalize(@shopping_list[key][:name])}"
  end
  puts "\n\nTotal: $#{format_number(@total)}"
end

def recursive_gets
  puts "What is the amount tendered?"
  @input = gets_input
  recursive_gets unless valid_input?
end

def checkout
  recursive_gets
  calc_change
  if  @input.to_f >= @total
    successful_checkout
  else
    unsuccessful_checkout
  end
end

def calc_change
  (@total - @input.to_f).abs
end

def unsuccessful_checkout
  puts "================="
  puts "WARNING: The customer still owes $#{format_number(calc_change)}!"
  puts "\n\n==============="
  display_complete_sale
  checkout
end

def successful_checkout
  puts "===Thank You!==="
  print "The total change due is $#{format_number(calc_change)}\n\n"
  puts @time.strftime("%m-%d-%Y %H:%M:%S")
  puts "================"
end

def making_purchase(file, list)
  populate_item_list(file,list)
  display_item_menu(list)
  select_option
  until check_done?
    select_amount_of_bags
    display_subtotal
    update_shopping_list
    select_option
  end
  display_complete_sale
  checkout
end
#The stuff above are methods for basic register functionality

def check_done?
  @input.downcase! unless valid_numeric?
  @input == "done"
end

def valid_selection?
  valid_numeric? && (@input.to_i <= (@item_list.length))
end

def valid_numeric?
  @input.match(/\A\d*\z/) && @input.to_i != 0
end

def valid_input?
  @input.match(/\A\d*\.?\d?\d?\z/)
end
#The stuff above are our validation checks

def display_initial_menu
  puts "What would you like to do? (Enter 1, 2, or 3 to make a selection)"
  puts "1) Report"
  puts "2) Make a Sale"
  puts "3) Quit"
end

def get_initial_input
  @choice = gets_input
  if @choice.to_i == 1
    #REPORT
  elsif @choice.to_i == 2
    making_purchase('item_list.csv', @item_list)
  elsif @choice.to_i == 3
    puts "Thank you for using this Register!"
    puts "Goodbye!"
  else
    puts "WARNING: Not Valid Input."
    get_initial_input
  end
end

#The above handles the initial menu recursion





while @choice.to_i != 3
  display_initial_menu
  get_initial_input
end



