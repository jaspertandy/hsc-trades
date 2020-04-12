require "csv"
require "json"

file = ARGV[0]

contents = File.readlines(file)

found_names = false
found_items = false
cleaned_rows = []

NAME_NEEDLE = /Marty.*emmie/

contents.each do |line|
  if line =~ NAME_NEEDLE
    found_names = true
    cleaned_rows.push(line)
    next
  end
  if found_names && line[0,2] != ',,'
    found_items = true
  end

  if found_items && found_names
    cleaned_rows.push(line)
  end
end

clean_text = cleaned_rows.join("")

csv = CSV.parse(clean_text)

want = []
can_trade = {}
names = []
count_wants = 0

csv.each do |r|
  if r[0..1] == [nil, nil]
    names = r[2..].reject { |n| n.nil? }
  else
    item = r[1]
    can_trade[item] = {}
    ownership = r[2..]
    names.each_with_index do |name, i|
      if ownership[i] == "WANT" || ownership[i].nil?
        want.push([name, item])
        count_wants += 1
      elsif ownership[i] == "CAN TRADE"
        can_trade[item][name] = 1
      end
    end
  end
end

sorted_wants = want.sort_by { |v| v[0] }
shuffled_wants = []
queue = []

while count_wants > 0
  if queue.size == 0
    queue = names.dup
  end
  next_in_queue = queue.shift
  next_want_index = sorted_wants.index do |v|
    v[0] == next_in_queue
  end
  unless next_want_index.nil? # this person doesn't want anything else
    shuffled_wants.push(sorted_wants[next_want_index])
    sorted_wants.delete_at(next_want_index)
  end
  count_wants -= 1
end

possible_trades = []
impossible_trades = []

shuffled_wants.each do |name, item|
  who_has = can_trade[item].find { |person, amount| amount > 0 }
  if who_has.nil? # no-one can trade
    #puts "#{name} wants #{item} but no-one has one"
    impossible_trades.push({ person: name, item: item })
  else
    person, amount = who_has
    can_trade[item][person] -= 1
    possible_trades.push({ wanter: name, trader: person, item: item })
  end
end

data = {
  generated: DateTime.now,
  impossible_trades: impossible_trades,
  possible_trades: possible_trades
}

output = File.dirname(file) + "/data.json"

File.open(output, "w") { |f| f.write(data.to_json) }

possible_trades.sort_by { |d| [d[:wanter].downcase, d[:trader].downcase] }.each do |data|
  puts "#{data[:wanter]} receives #{data[:item]} from #{data[:trader]}"
end
