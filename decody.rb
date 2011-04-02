
class DeCody
  
  # Expects 25 characters laid out in a 5 X 5 grid
  def initialize(key)
    @key = justletters(key) 
  end
  
  # Locates the letter in the presumed 5 X 5 grid
  def locate(letter)
    key_loc = @key.index(letter)
    [key_loc/ 5, key_loc % 5]
  end

  def at(row, column)
    @key[(row * 5) + column,1]
  end

  def encode(plaintext)
    pairs = cypher_prep(plaintext, "encode")
    pair_swap(pairs, '+').join
  end

  def decode(cyphertext)
    pairs = cypher_prep(cyphertext)
    clean_text = pair_swap(pairs, '-').join
    # Clean out the 'XqXq' encoding.
    clean_text.gsub(/(([a-pr-z])q)\1/,'\2\2')
  end

  # Transform a given string into a list of pairs of letters
  # for swapping against the key.
  def cypher_prep(text, encode=false)
    working_text = text.downcase.gsub(/[^a-z]/, '')
    pairs = []
    working_text.scan(/..|./) do |pair|
      if pair.length == 1
        pairs += [pair + "x"]
      elsif encode and pair =~ /([a-z])\1/
        # Only q-encode doubled letters while encoding.
        pairs += ["#{$1}q","#{$1}q"]
      else 
        pairs += [pair]
      end
    end
    pairs
  end

  # Given a sign, shift the list 1 unit 
  # in the sign direction.
  def shift_swap(lyst, index, sign)
    lyst[index] = (lyst[index].send(sign,1)) % 5
  end

  # Given a list of pairs, and a sign for which direction
  # to shift if both of the letters are on the same row or
  # column, produces a new list of pairs of letters.
  def pair_swap(pairs, shift_sign)
    pairs.collect do |pair|
      l1 = locate(pair[0,1])
      l2 = locate(pair[1,1])
      if l1.first == l2.first  # on the same column
        shift_swap(l1, 1, shift_sign)
        shift_swap(l2, 1, shift_sign)
      elsif l1.last == l2.last  # on the same row
        shift_swap(l1, 0, shift_sign)
        shift_swap(l2, 0, shift_sign)
     else 
        l1[1], l2[1] = l2[1], l1[1] # normal swap
      end
      [at(*l1), at(*l2)]
    end
  end
end


