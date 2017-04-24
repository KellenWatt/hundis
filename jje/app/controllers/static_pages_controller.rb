INDEX_PAGE_SIZE = 10

class StaticPagesController < ApplicationController

  def users
    @pg_count = (User.count / INDEX_PAGE_SIZE.to_f).ceil
    @pg = (params["pg"] || 1).to_i

    if @pg < 1 or @pg > @pg_count
      raise "bad page number; pg=#{@pg}"
    else
      @users = User.limit(INDEX_PAGE_SIZE).offset(INDEX_PAGE_SIZE * (@pg - 1))
    end
  end

  def problems
    @pg_count = (Problem.count / INDEX_PAGE_SIZE.to_f).ceil
    @pg = (params["pg"] || 1).to_i

    if @pg < 1 or @pg > @pg_count
      raise "bad page number; pg=#{@pg}"
    else
      @problems = Problem.limit(INDEX_PAGE_SIZE).offset(INDEX_PAGE_SIZE * (@pg - 1))
    end
  end

  def tournaments
    @now = DateTime.current()
    @pg_count = (Tournament.count / INDEX_PAGE_SIZE.to_f).ceil
    @pg = (params["pg"] || 1).to_i

    if @pg < 1 or @pg > @pg_count
      raise "bad page number; pg=#{@pg}"
    else
      @tourneys = Tournament.limit(INDEX_PAGE_SIZE).offset(INDEX_PAGE_SIZE * (@pg - 1))
    end
  end
end
