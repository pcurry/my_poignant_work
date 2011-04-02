class NameCaller
  def method_missing(name, *args)
    puts "You're calling `" + "#{name}" + "' and you say: "
    args.each { |say| puts " " + say }
    puts "\nBut no one is there yet."
  end

  def deirdre(*args)
    puts "Deirdre is right here and you say:"
    args.each { |say| puts " " + say }
    puts "\nAnd she loves every second of it."
    puts "(I think she thinks you're poetic.)"
  end
end
