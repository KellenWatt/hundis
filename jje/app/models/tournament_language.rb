class TournamentLanguage < ApplicationRecord
  self.primary_keys = :tournament_id, :language
  belongs_to :tournament

  LanguageOptions = [
    ['C',         'c'],
    ['C++',       'cpp'],
    ['Python',    'py'],
    ['D',         'd'],
    ['Go',        'go'],
    ['Ruby',      'ruby'],
    ['C#',        'csharp'],
    ['Pascal',    'pascal'],
    ['JavaScript','js'],
    ['Scala',     'scala'],
    ['PHP',       'php'],
    ['Haskell',   'haskell'],
    ['Lua',       'lua'],
    ['Lisp',      'lisp']
  ]
end
