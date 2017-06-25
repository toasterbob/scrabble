require "trie"

DICTIONARY = Trie.new
File.readlines('./words.txt').each { |line| DICTIONARY.add(line.strip) }
