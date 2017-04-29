INDEX_PAGE_SIZE = 10

class StaticPagesController < ApplicationController

  def Home
    @homepage_users = do_paging(User)
    @homepage_problems = do_paging(Problem)
    @now = DateTime.current()
    @homepage_tourneys = do_paging(Tournament)
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
