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



def populate_item_list(file, list)
  CSV.foreach(file, headers: true) do |row|
    one_item ={}
    row.each do |array|
## The value is either a string or a float, so this exception tests what it is and assigns it properly
      value = array[1].to_f
      value = array[1] if array[1].to_f == 0.0
## Wheeee placeholder comment
      one_item[(format_hashkey_to_sym(array[0]))] = value
  end
    list << one_item
  end
end
# This stuff above simply populates the current item list. Everything below is the functionality of the register

def display_item_menu
    @item_list.each_with_index do |item, index|
      puts "#{index+1}) Add item - $#{item[:purchasing_price]} - #{capitalize(item[:item_name])}"
    end
    puts 'To complete sale, type "Done".'
end


populate_item_list('item_list.csv',@item_list)
puts "Welcome to James' coffee emporium!\n\n"
display_item_menu

