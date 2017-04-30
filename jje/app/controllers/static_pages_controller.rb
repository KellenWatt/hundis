INDEX_PAGE_SIZE = 10

class StaticPagesController < ApplicationController

  def Home
    @homepage_users = User.limit(6).order(score: :desc)
    @easiest_problems = Problem.limit(6).order(score: :asc)
    @now = DateTime.current()
    @least_solved_problems = Problem.limit(6).order(solves: :asc)
    @homepage_tourneys = Tournament.limit(6)
  end

  def users
    @users = do_paging(User)
  end

  def problems
    @problems = do_paging(Problem)
  end

  def tournaments
    @now = DateTime.current()
    @tourneys = do_paging(Tournament)
  end

  def search
    if params[:q] and params[:q].length > 0 then
      @results = []
      @problem_result
      params[:q].split(" ").each do |word|
        @name_results = Problem.where('lower(name) LIKE ?', "%#{word}%".downcase)
        @name_results.each do |result|
          @results.push(result)
        end
        @keyword_results = ProblemKeyword.where('lower(keyword) LIKE ?', "%#{word}%".downcase)
        @keyword_results.each do |result|
          @results.push(result.problem)
        end
        if user_signed_in?
          if current_user.admin
            @tag_results = ProblemTag.where('lower(tag) LIKE ?', "%#{word}%".downcase)
            @tag_results.each do |result|
              @results.push(result.problem)
            end
          end
        end
      end
      if @results.length > 0 then
        @results = @results.uniq{|x| x.problem_id}
      end
    end
  end

  private
    def do_paging (pagetype)
      @pg_count = (pagetype.count / INDEX_PAGE_SIZE.to_f).ceil
      @pg = (params["pg"] || 1).to_i

      if @pg_count == 0
        return []
      elsif @pg < 1
        @pg = 1
      elsif @pg > @pg_count
        @pg = @pg_count
      end

      return pagetype.limit(INDEX_PAGE_SIZE).offset(INDEX_PAGE_SIZE * (@pg - 1))
    end
end
