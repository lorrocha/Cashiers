require 'CSV'

@item_list=[]
@shopping_list = {}

# These methods format different inputs
def format_hashkey_to_sym(name)
  name.gsub!(' ','_')
  name.downcase.intern
end

def capitalize(name)
  names = []
  name.split(' ').each do |word|
    names << word.capitalize
  end
  names.join(' ')
end





def populate_item_list(file)
  CSV.foreach(file, headers: true) do |row|
    one_item ={}
    row.each do |array|
## The value is either a string or a float, so this exception tests what it is and assigns it properly
      value = array[1].to_f
      value = array[1] if array[1].to_f == 0.0
## Wheeee placeholder comment
      one_item[(format_hashkey_to_sym(array[0]))] = value
  end
    @item_list << one_item
  end
end
# This stuff above simply populates the current item list. Everything below is the functionality of the register

def display_menu
    puts "Welcome to James' coffee emporium!\n\n"
    puts "1) Add item - $#{@item_list[0][:purchasing_price]} - #{capitalize(@item_list[0][:item_name])}"
    puts "2) Add item - $7.50 - Medium Bag"
    puts "3) Add item - $9.75 - Bold Bag"
    puts "4) Complete Sale"
  end






populate_item_list('item_list.csv')
puts @item_list
display_menu
