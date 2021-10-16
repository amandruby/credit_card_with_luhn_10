def credit_card_provider
  puts "Please enter the input file path with filename and extension for example ../../Desktop/demo.txt"
  file = gets.chomp 
  user_hash = array_to_user_hash_converter file_to_array_converter(file)
  generate_output user_hash
end

def file_to_array_converter file 
  file_array = [] 
  File.open(file, "r"){|f|
    f.each_line {|line|
      file_array << line.chomp.split(" ") 
    }
  }
  file_array
end

def array_to_user_hash_converter file_array
  user_hash = {}
  file_array.each do |element|
    user_hash[element[1]] ||= {"credit_card_valid"=> false, "balance"=> 0}
    if element.size == 4
      user_hash[element[1]]["balance"] = element[3][1..-1].to_i 
      user_hash[element[1]]["credit_card_valid"] =  valid_credit_card? element[2]
    else 
      if user_hash[element[1]]["credit_card_valid"] && element[0] == "Charge"    
        user_hash[element[1]]["balance"] = user_hash[element[1]]["balance"] + element[2][1..-1].to_i 
      elsif user_hash[element[1]]["credit_card_valid"] && element[0] == "Credit"    
        user_hash[element[1]]["balance"] = user_hash[element[1]]["balance"] - element[2][1..-1].to_i 
      end
    end
  end
  user_hash
end

def valid_credit_card? credit_card_number   
  return false if credit_card_number.length > 19 
  valid_credit_card_using_luhn_algo credit_card_number  
end

def valid_credit_card_using_luhn_algo credit_card_number 
  digit_sum = 0 
  credit_card_number.reverse.split("").each_with_index do |element, index|
    unless index%2==0
      temp = element.to_i*2
      digit_sum = digit_sum + (temp > 9 ? temp.to_s.split("").map(&:to_i).sum : temp)  
    else 
      digit_sum = digit_sum + element.to_i
    end
  end 
  digit_sum % 10 == 0 ? true : false  
end

def generate_output user_hash
  Hash[ user_hash.sort_by { |key, val| key } ].each do |key, value|
    p value["credit_card_valid"] ? "#{key}: $#{value['balance']}" : "#{key}: error"
  end
end

credit_card_provider