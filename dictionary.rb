require "trie"

DICTIONARY = Trie.new
File.readlines('./words_alpha.txt').each { |line| DICTIONARY.add(line.strip) }
