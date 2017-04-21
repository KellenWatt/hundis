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

class ProblemsController < ApplicationController
  def index
  end

  def show
    @problem = Problem.find(params[:id])
    @keywords = ProblemKeyword.where(problem_id: params[:id])
    @tags = ProblemTag.where(problem_id: params[:id])
  end

  def stats
    @problems = Problem.all
  end

  def showUpload
    @problem = Problem.find(params[:id])
  end

  def uploadCode
    uploaded_lang = params[:language]
    uploaded_main = params[:main]
    uploaded_supp = params[:support]
    supp_count = uploaded_supp.length

  end

  def uploadOutput
    uploaded_output = params[:output]
  end
end
