INDEX_PAGE_SIZE = 10

class StaticPagesController < ApplicationController

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
      @name_results = Problem.where("name = ?", "%#{:q}%")
      @name_results.each do |result|
        @results.push(result)
      end
      @keyword_results = ProblemKeyword.where("keyword = ?", "%#{:q}%")
      @keyword_results.each do |result|
        @results.push(Problem.where("id = ?", result.problem_id))
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
