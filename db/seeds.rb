file = File.open(File.join(Rails.root, 'db', 'diccionario.json'))

json = JSON.load(file)
bar = TTY::ProgressBar.new("word :current [:bar] :total :elapsed :percent", total: json.size, clear: true, head: '>')
bar.resize(50)

words = []
definitions = []

bar.log "parsing words..."
json.each_with_index do |word_data, word_index|
  word = Word.new do |word|
    word.name = word_data['word']
    word.alias = word_data['alias'] if word_data['alias']
  end
  words << word 
  word_data['definitions'].each do |definition_group, definitions_data|
    definitions_data.each do |definition_content|
      definition = Definition.new do |definition_data|
        definition_data.content = definition_content
        definition_data.word_id = word_index + 1
        definition_data.group = definition_group
      end
      definitions << definition
    end
  end
  bar.advance
end

p 'saving words...'
Word.import! words
p "#{words.size} words saved."
p 'saving definitions'
Definition.import! definitions
p "#{words.size} definitions saved."

